import 'package:flutter/material.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/home_models.dart';
import 'widgets/home_header.dart';
import 'widgets/home_navigation.dart';
import 'widgets/partner_card.dart';
import 'widgets/quotation_banner.dart';
import 'widgets/service_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onLocaleChanged,
    required this.services,
    required this.partners,
  });
  final ValueChanged<Locale> onLocaleChanged;
  final List<ServiceItem> services;
  final List<BusinessPartner> partners;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _notice(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _futureFeature() => _notice(AppStrings.of(context)['comingSoon']);

  void _search() {
    FocusScope.of(context).unfocus();
    final strings = AppStrings.of(context);
    final query = _searchController.text.trim().toLowerCase();
    final matches = widget.partners
        .where(
          (partner) => [
            partner.name.ar,
            partner.name.en,
            partner.name.fr,
            partner.city.ar,
            partner.city.en,
            partner.city.fr,
            for (final tag in partner.tags) ...[tag.ar, tag.en, tag.fr],
          ].any((text) => text.toLowerCase().contains(query)),
        )
        .toList();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: .75,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings['searchAction'],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpace.sm),
              Text(strings['searchNote']),
              const SizedBox(height: AppSpace.md),
              if (matches.isEmpty) Text(strings['noResults']),
              for (final partner in matches)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpace.md),
                  child: PartnerCard(
                    partner: partner,
                    onTap: () => _notice(strings['sampleNote']),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      bottomNavigationBar: HomeNavigation(
        onSelected: (index) {
          if (index == 0) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          } else {
            _futureFeature();
          }
        },
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpace.maxWidth),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final padding = constraints.maxWidth < 360
                      ? AppSpace.md
                      : AppSpace.lg;
                  return Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeader(
                          onLocaleChanged: widget.onLocaleChanged,
                          onProfile: _futureFeature,
                          onNotifications: () =>
                              _notice(strings['noNotifications']),
                        ),
                        const SizedBox(height: AppSpace.xl),
                        TextField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _search(),
                          decoration: InputDecoration(
                            hintText: strings['search'],
                            prefixIcon: IconButton(
                              tooltip: strings['searchAction'],
                              onPressed: _search,
                              icon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.teal,
                              ),
                            ),
                            suffixIcon: IconButton(
                              tooltip: MaterialLocalizations.of(context)
                                  .deleteButtonTooltip,
                              onPressed: _searchController.clear,
                              icon: const Icon(Icons.close, size: 18),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpace.lg),
                        QuotationBanner(onRequest: _futureFeature),
                        const SizedBox(height: AppSpace.section),
                        Text(
                          strings['services'],
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: const Color(0xFF198481)),
                        ),
                        const SizedBox(height: AppSpace.xs),
                        Text(
                          strings['servicesTitle'],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpace.lg),
                        ServiceGrid(
                          items: widget.services,
                          onSelected: (_) => _futureFeature(),
                        ),
                        const SizedBox(height: AppSpace.section),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                strings['partners'],
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                _search();
                              },
                              child: Text(strings['seeAll']),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpace.xs),
                        Text(
                          strings['sampleNote'],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: AppSpace.md),
                        LayoutBuilder(
                          builder: (context, box) {
                            final columns =
                                box.maxWidth >= AppSpace.tablet &&
                                    MediaQuery.textScalerOf(context).scale(16) <
                                        24
                                ? 2
                                : 1;
                            final width =
                                (box.maxWidth - AppSpace.md * (columns - 1)) /
                                columns;
                            return Wrap(
                              spacing: AppSpace.md,
                              runSpacing: AppSpace.md,
                              children: [
                                for (final partner in widget.partners)
                                  SizedBox(
                                    width: width,
                                    child: PartnerCard(
                                      partner: partner,
                                      onTap: () =>
                                          _notice(strings['sampleNote']),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppSpace.lg),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
