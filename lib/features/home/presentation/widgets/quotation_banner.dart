import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';

class QuotationBanner extends StatelessWidget {
  const QuotationBanner({super.key, required this.onRequest});
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpace.radius),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF103B56),
                    Color(0xFF154B63),
                    Color(0xFF187E81),
                  ],
                ),
              ),
            ),
          ),
          const PositionedDirectional(
            end: -35,
            bottom: -45,
            child: ExcludeSemantics(
              child: Icon(
                Icons.near_me_outlined,
                size: 210,
                color: Color(0x227FC3CA),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings['quote'],
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: const Color(0xFF9DE0DB)),
                ),
                const SizedBox(height: AppSpace.sm),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 410),
                    child: Text(
                      strings['promo'],
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.lg),
                TextButton(
                  onPressed: onRequest,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB9EFEB),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(48, 48),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: Text(strings['requestQuote'])),
                      const SizedBox(width: AppSpace.sm),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
