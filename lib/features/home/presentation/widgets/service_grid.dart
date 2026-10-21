import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/home_models.dart';

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key, required this.items, required this.onSelected});
  final List<ServiceItem> items;
  final ValueChanged<ServiceItem> onSelected;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final largeText = MediaQuery.textScalerOf(context).scale(16) > 23;
      final columns = largeText || constraints.maxWidth < 280
          ? 1
          : constraints.maxWidth >= AppSpace.desktop
          ? 4
          : constraints.maxWidth >= AppSpace.tablet
          ? 3
          : 2;
      final width =
          (constraints.maxWidth - AppSpace.sm * (columns - 1)) / columns;
      return Wrap(
        spacing: AppSpace.sm,
        runSpacing: AppSpace.sm,
        children: [
          for (final item in items)
            SizedBox(
              width: item.id == IndexService.jobs
                  ? constraints.maxWidth
                  : width,
              child: _ServiceCard(item: item, onTap: () => onSelected(item)),
            ),
        ],
      );
    },
  );
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item, required this.onTap});
  final ServiceItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, background, foreground) = switch (item.id) {
      IndexService.directory => (
        Icons.apartment_rounded,
        AppColors.mint,
        AppColors.teal,
      ),
      IndexService.calculator => (
        Icons.calculate_outlined,
        AppColors.blue,
        const Color(0xFF356F94),
      ),
      IndexService.dangerousGoods => (
        Icons.health_and_safety_outlined,
        AppColors.peach,
        const Color(0xFFB87436),
      ),
      IndexService.quotations => (
        Icons.description_outlined,
        AppColors.purple,
        const Color(0xFF8574AC),
      ),
      IndexService.networking => (
        Icons.account_tree_outlined,
        AppColors.blue,
        const Color(0xFF356F94),
      ),
      IndexService.tools => (
        Icons.auto_awesome_outlined,
        AppColors.mint,
        AppColors.teal,
      ),
      IndexService.jobs => (
        Icons.business_center_outlined,
        AppColors.peach,
        const Color(0xFFB87436),
      ),
    };
    final badge = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpace.iconRadius),
      ),
      child: Icon(icon, color: foreground, size: 28),
    );
    final title = Text(
      AppStrings.of(context).text(item.title),
      style: Theme.of(context).textTheme.titleMedium,
    );
    final jobs = item.id == IndexService.jobs;
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpace.radius),
        side: BorderSide(
          color: jobs ? const Color(0xFFBFDDDA) : AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.md),
          child: jobs
              ? Row(
                  children: [
                    badge,
                    const SizedBox(width: AppSpace.md),
                    Expanded(child: title),
                    const SizedBox(width: AppSpace.sm),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                )
              : ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 132),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      badge,
                      const SizedBox(height: AppSpace.sm),
                      title,
                      const SizedBox(height: AppSpace.xs),
                      const Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Icon(Icons.arrow_forward, size: 18),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
