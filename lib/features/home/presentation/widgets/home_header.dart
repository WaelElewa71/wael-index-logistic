import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onLocaleChanged,
    required this.onProfile,
    required this.onNotifications,
  });
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback onProfile;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final welcome = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(strings['greeting'], style: Theme.of(context).textTheme.bodySmall),
        Text(
          strings['welcome'],
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<Locale>(
          tooltip: strings['language'],
          onSelected: onLocaleChanged,
          itemBuilder: (_) => const [
            PopupMenuItem(value: Locale('ar'), child: Text('العربية')),
            PopupMenuItem(value: Locale('en'), child: Text('English')),
            PopupMenuItem(value: Locale('fr'), child: Text('Français')),
          ],
          child: Container(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpace.iconRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              strings.locale.languageCode.toUpperCase(),
              style: const TextStyle(
                color: AppColors.teal,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpace.sm),
        IconButton.filledTonal(
          onPressed: onNotifications,
          tooltip: strings['notifications'],
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.navy,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpace.iconRadius),
            ),
            side: const BorderSide(color: AppColors.border),
          ),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        const SizedBox(width: AppSpace.sm),
        IconButton.filled(
          onPressed: onProfile,
          tooltip: strings['profile'],
          style: IconButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpace.iconRadius),
            ),
          ),
          icon: const Icon(Icons.person_outline_rounded),
        ),
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360 ||
            MediaQuery.textScalerOf(context).scale(16) > 22) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              welcome,
              const SizedBox(height: AppSpace.md),
              actions,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: welcome),
            const SizedBox(width: AppSpace.sm),
            actions,
          ],
        );
      },
    );
  }
}
