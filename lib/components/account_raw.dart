import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/controllers/account_controller.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/screens/services_screen.dart';

class AccountRaw extends StatelessWidget {
  final dynamic account;
  final AccountController controller = Get.find();
  final BackdropNavController nav = Get.find();

  AccountRaw({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final bool isBusiness = (account['type'] ?? '') != "Personal";

    final String title = (account['name'] ?? '').toString();
    final String businessType =
        (account['business_type'] ?? '').toString().trim();
    final String legalName =
        (account['legal_name'] ?? account['name'] ?? '').toString().trim();

    // If you only have "sin" currently, use it as BN/SIN value.
    // Ideally, use account['bn'] for business.
    final String bnOrSin = (account['sin'] ?? '').toString();
    final String maskedBnOrSin = controller.config.maskDetails(bnOrSin);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        if (isBusiness) {
          controller.config.setStringSharedPreferences(
            "businessID",
            account['clientID'].toString(),
          );
        }

        nav.openPage(
          ServicesScreen.id,
          arguments: {
            "type":
                businessType == "Sole proprietor"
                    ? businessType
                    : (account['type'] ?? ''),
            "title": title,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B2E4A), Color(0xFF06263F)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left icon (shop)
            _LeftIcon(isBusiness: isBusiness),

            const SizedBox(width: 14),

            // Right content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Title pill
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0B2E4A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Info rows (like the image)
                  Visibility(
                    visible: isBusiness,
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: FontAwesomeIcons.bullseye,
                          text: "Business Type : $businessType",
                        ),

                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  _InfoRow(
                    icon: FontAwesomeIcons.certificate,
                    text: "Legal Name : $legalName",
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: FontAwesomeIcons.idCard,
                    text:
                        "${isBusiness ? "Business Number" : "SIN"} : $maskedBnOrSin",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftIcon extends StatelessWidget {
  final bool isBusiness;

  const _LeftIcon({required this.isBusiness});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Center(
        child: Icon(
          isBusiness ? FontAwesomeIcons.store : FontAwesomeIcons.user,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.95)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              height: 1.25,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ),
      ],
    );
  }
}
