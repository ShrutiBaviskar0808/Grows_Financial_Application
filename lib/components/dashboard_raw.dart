import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/controllers/dashboard_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class DashboardRaw extends StatelessWidget {
  final String leftIcon, title;
  final List<dynamic> actions;
  final void Function(dynamic) onActionTap;

  const DashboardRaw({
    super.key,
    required this.leftIcon,
    required this.title,
    required this.actions,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(leftIcon, height: 56),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: titleTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: boldFont,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: actions.map((item) {
                final m = (item as Map); // map item

                // ✅ support both API keys and your static keys
                final String icon = (m['icon'] ?? m['service_icon'] ?? '').toString();
                final String text = (m['title'] ?? m['service_name'] ?? m['name'] ?? '').toString();

                return _actionChip(
                  icon: icon,
                  text: text,
                  onTap: () => onActionTap(item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionChip({
    required String icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final dashboardController = Get.find<DashboardController>();

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// 🔥 Try Asset First
            if (icon.isNotEmpty)
              Image.asset(
                icon,
                height: 22,
                color: primaryColor,
                errorBuilder: (context, error, stackTrace) {

                  /// 🔥 If asset fails → try MDI icon
                  final mdiIcon =
                  dashboardController.mdiIconMap[icon];

                  if (mdiIcon != null) {
                    return Icon(
                      mdiIcon,
                      size: 22,
                      color: primaryColor,
                    );
                  }

                  /// 🔥 Final fallback
                  return Icon(
                    Icons.widgets,
                    size: 22,
                    color: primaryColor,
                  );
                },
              ),

            const SizedBox(width: 8),

            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: titleTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: boldFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
