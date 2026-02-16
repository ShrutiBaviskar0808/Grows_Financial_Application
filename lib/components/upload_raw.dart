import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

class UploadRaw extends StatelessWidget {
  final IconData iconData;
  final File file;
  final String name;
  final VoidCallback onTap;

  const UploadRaw({
    super.key,
    required this.iconData,
    required this.file,
    required this.name,
    required this.onTap,
  });

  bool get isImage {
    final ext = p.extension(file.path).replaceFirst('.', '').toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(ext);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: isImage
            ? ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.file(
            file,
            width: 42,
            height: 42,
            fit: BoxFit.cover,
            // ✅ prevents heavy decode / memory spikes
            cacheWidth: 120,
            errorBuilder: (_, __, ___) => Icon(iconData),
          ),
        )
            : Icon(iconData, size: 26),
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.clear, color: Colors.red),
          onPressed: onTap,
        ),
      ),
    );
  }
}
