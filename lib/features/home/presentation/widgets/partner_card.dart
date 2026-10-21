import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/home_models.dart';

class PartnerCard extends StatelessWidget {
  const PartnerCard({super.key, required this.partner, required this.onTap});
  final BusinessPartner partner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpace.radius),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(AppSpace.iconRadius),
                ),
                child: Text(
                  partner.initial,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.text(partner.name),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpace.xs),
                    Text.rich(
                      TextSpan(
                        children: [
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(Icons.location_on_outlined, size: 16),
                          ),
                          TextSpan(text: ' ${strings.text(partner.city)}'),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpace.sm),
                    Text(
                      strings['sample'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF397D78),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpace.sm),
                    Wrap(
                      spacing: AppSpace.sm,
                      runSpacing: AppSpace.sm,
                      children: [
                        for (final tag in partner.tags)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpace.sm,
                              vertical: AppSpace.xs,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F6F5),
                              borderRadius: BorderRadius.circular(AppSpace.sm),
                            ),
                            child: Text(
                              strings.text(tag),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: const Color(0xFF5B747A)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.xs),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
