import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';

class HomeNavigation extends StatelessWidget {
  const HomeNavigation({
    super.key,
    required this.onSelected,
    required this.selectedIndex,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  static const _items = [
    ('home', Icons.home_outlined),
    ('directory', Icons.menu_book_outlined),
    ('requests', Icons.description_outlined),
    ('tools', Icons.build_outlined),
    ('profile', Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: AppColors.border)),
    ),
    child: SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpace.maxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _items.length; i++)
                  Expanded(
                    child: Semantics(
                      selected: i == selectedIndex,
                      child: InkWell(
                        onTap: () => onSelected(i),
                        borderRadius: BorderRadius.circular(
                          AppSpace.iconRadius,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpace.xs,
                            vertical: AppSpace.sm,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: AppSpace.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: i == selectedIndex
                                      ? AppColors.mint
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    AppSpace.iconRadius,
                                  ),
                                ),
                                child: Icon(
                                  _items[i].$2,
                                  size: 26,
                                  color: i == selectedIndex
                                      ? AppColors.teal
                                      : AppColors.muted,
                                ),
                              ),
                              const SizedBox(height: AppSpace.xs),
                              Text(
                                AppStrings.of(context)[_items[i].$1],
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: i == selectedIndex
                                          ? const Color(0xFF157E7C)
                                          : const Color(0xFF647980),
                                      fontWeight: i == selectedIndex
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
