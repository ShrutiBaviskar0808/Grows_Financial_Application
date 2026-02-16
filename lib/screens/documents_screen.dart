import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// your imports
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/controllers/services_controller.dart';
import 'package:growsfinancial/utils/constant.dart'; // imageUrl, styles, etc.

class DocumentsScreen extends StatefulWidget {
  static const String id = "/DocumentsScreen";
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  final ServicesController controller = Get.find();

  late final TabController _tabController;
  final Dio _dio = Dio();

  /// progress per url
  final RxMap<String, double> _progressMap = <String, double>{}.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception("Could not launch");
      }
    } catch (_) {
      controller.config.showToastFailure("Unable to open file");
    }
  }

  IconData _fileIcon(String filePath) {
    final ext = p.extension(filePath).replaceFirst('.', '').toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(ext)) return FontAwesomeIcons.fileImage;
    if (ext == 'pdf') return FontAwesomeIcons.filePdf;
    if (['doc', 'docx'].contains(ext)) return FontAwesomeIcons.fileWord;
    if (['xls', 'xlsx', 'csv'].contains(ext)) return FontAwesomeIcons.fileExcel;
    if (['ppt', 'pptx'].contains(ext)) return FontAwesomeIcons.filePowerpoint;
    return FontAwesomeIcons.file;
  }

  bool _isImage(String filePath) {
    final ext = p.extension(filePath).replaceFirst('.', '').toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(ext);
  }

  Future<Directory?> _getSaveDirectory() async {
    if (Platform.isAndroid) {
      final perm = await Permission.storage.request();
      if (perm.isGranted) {
        final dir = Directory("/storage/emulated/0/Download/GrowsFinancial");
        if (!await dir.exists()) await dir.create(recursive: true);
        return dir;
      }

      // Android 13+ OR permission denied -> app documents
      return await getApplicationDocumentsDirectory();
    }

    // iOS
    return await getApplicationDocumentsDirectory();
  }

  Future<void> _downloadFile({
    required String url,
    required String fileName,
    required String key,
  }) async {
    try {
      final dir = await _getSaveDirectory();
      if (dir == null) {
        controller.config.showToastFailure("Storage not available");
        return;
      }

      final savePath = p.join(dir.path, fileName);

      _progressMap[key] = 0;

      await _dio.download(
        url,
        savePath,
        options: Options(
          followRedirects: true,
          receiveTimeout: const Duration(minutes: 2),
          sendTimeout: const Duration(minutes: 2),
        ),
        onReceiveProgress: (received, total) {
          if (total > 0) _progressMap[key] = received / total;
        },
      );

      _progressMap.remove(key);
      controller.config.showToastSuccess("Downloaded: $fileName");

      Get.snackbar(
        "Download complete",
        fileName,
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => OpenFilex.open(savePath),
          child: const Text("OPEN"),
        ),
      );
    } catch (_) {
      _progressMap.remove(key);
      controller.config.showToastFailure("Download failed");
    }
  }

  Map<String, dynamic>? _findGroup(List groups, String type) {
    for (final g in groups) {
      final m = Map<String, dynamic>.from(g as Map);
      final t = (m['type'] ?? '').toString().toLowerCase();
      if (t == type.toLowerCase()) return m;
    }
    return null;
  }

  /// 🔥 Full-width segmented TabBar like screenshot
  Widget _segmentedTabs({
    required int requestedCount,
    required int uploadedCount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          indicator: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,

          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          tabs: [
            Tab(text: "Requested ($requestedCount)"),
            Tab(text: "Uploaded ($uploadedCount)"),
          ],
        ),
      ),
    );
  }

  /// ✅ Requested card (with View/Download if file exists)
  Widget _requestedCard(Map<String, dynamic> d) {
    final title = (d['document_title'] ?? d['title'] ?? '').toString();
    final category = (d['category_name'] ?? d['category'] ?? '').toString();
    final status = (d['status'] ?? '').toString();
    final date = (d['addedOn'] ?? d['requested_on'] ?? '').toString();

    // optional: if API provides file for requested row
    final String path = (d['document_path'] ?? '').toString().trim();
    final bool hasFile = path.isNotEmpty;

    final String url = hasFile ? (imageUrl + path) : "";
    final String fileName = hasFile ? p.basename(path) : "";
    final String key = url;

    final bool isCompleted =
        status == "1" || status.toLowerCase().contains("complete");

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: Colors.orange,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.isEmpty ? "Untitled" : title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.isEmpty ? "-" : category,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: (isCompleted ? Colors.green : Colors.orange)
                        .withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isCompleted ? "Completed" : "Pending",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),

            // ✅ Buttons for requested (only if file exists)
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: hasFile ? () => _openUrl(url) : null,
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text("View"),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: primaryColor.withValues(alpha: 0.35)),
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: hasFile
                        ? () => _downloadFile(
                      url: url,
                      fileName: fileName,
                      key: key,
                    )
                        : null,
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text("Download"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      disabledBackgroundColor:
                      primaryColor.withValues(alpha: 0.35),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            // progress bar
            Obx(() {
              final v = _progressMap[key];
              if (v == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(value: v, minHeight: 6),
                ),
              );
            }),

            if (!hasFile)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "File not uploaded yet",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// ✅ Uploaded card (view + download + thumbnail)
  Widget _uploadedCard(Map<String, dynamic> d) {
    final String path = (d['document_path'] ?? '').toString();
    final String category = (d['category_name'] ?? '').toString();
    final String title = (d['document_title'] ?? '').toString();
    final String uploadedOn = (d['addedOn'] ?? '').toString();

    final String fileName = p.basename(path);
    final String url = imageUrl + path;
    final String key = url;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                if (_isImage(path))
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      url,
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(_fileIcon(path), size: 22),
                    ),
                  )
                else
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Icon(_fileIcon(path), size: 20)),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${category.isEmpty ? "-" : category} • ${title.isEmpty ? "-" : title}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        uploadedOn,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openUrl(url),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text("View"),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: primaryColor.withValues(alpha: 0.35)),
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadFile(
                      url: url,
                      fileName: fileName,
                      key: key,
                    ),
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text("Download"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            Obx(() {
              final v = _progressMap[key];
              if (v == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(value: v, minHeight: 6),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final groups = controller.documentGroups;

      final requestedGroup = _findGroup(groups, "requested");
      final downloadsGroup = _findGroup(groups, "downloads");

      final requestedDocs =
      List<Map<String, dynamic>>.from((requestedGroup?['documents'] ?? []));
      final downloadDocs =
      List<Map<String, dynamic>>.from((downloadsGroup?['documents'] ?? []));

      return Scaffold(
        appBar: CustomAppBar(
          automaticallyImplyLeading: true,
          onTap: () => Get.back(),
        ),
        body: controller.showSpinner.value
            ? controller.config.loadingView()
            : Column(
          children: [
            const SizedBox(height: 8),
            Center(
              child: Text(
                "DOCUMENTS",
                style: titleTextStyle.copyWith(
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ✅ full selected tab bar view like screenshot
            _segmentedTabs(
              requestedCount: requestedDocs.length,
              uploadedCount: downloadDocs.length,
            ),

            const SizedBox(height: 12),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Requested
                  requestedDocs.isEmpty
                      ? const Center(
                    child: Text("No requested documents"),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: requestedDocs.length,
                    itemBuilder: (_, i) =>
                        _requestedCard(requestedDocs[i]),
                  ),

                  // Uploaded
                  downloadDocs.isEmpty
                      ? const Center(
                    child: Text("No uploaded documents"),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: downloadDocs.length,
                    itemBuilder: (_, i) =>
                        _uploadedCard(downloadDocs[i]),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
