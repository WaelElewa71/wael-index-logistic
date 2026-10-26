import 'package:flutter/material.dart';

import '../../../../core/domain/industry_sector.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';

class SectorFilter extends StatelessWidget {
  const SectorFilter({
    super.key,
    required this.sectors,
    required this.selectedId,
    required this.onSelected,
  });

  final List<IndustrySector> sectors;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings['sectors'],
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpace.sm),
        Wrap(
          spacing: AppSpace.sm,
          runSpacing: AppSpace.sm,
          children: [
            ChoiceChip(
              label: Text(strings['allSectors']),
              selected: selectedId == null,
              onSelected: (_) => onSelected(null),
            ),
            for (final sector in sectors)
              ChoiceChip(
                label: Text(strings.text(sector.name), softWrap: true),
                selected: selectedId == sector.id,
                onSelected: (selected) =>
                    onSelected(selected ? sector.id : null),
              ),
          ],
        ),
      ],
    );
  }
}
