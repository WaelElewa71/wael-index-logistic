import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'widgets/home_header.dart';
import 'widgets/home_navigation.dart';
import 'widgets/partner_card.dart';
import 'widgets/quotation_banner.dart';
import 'widgets/service_grid.dart';
import 'widgets/sector_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onLocaleChanged});
  final ValueChanged<Locale> onLocaleChanged;
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
    final cubit = context.read<HomeCubit>();
    cubit.search(_searchController.text);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              previous.query != current.query ||
              previous.selectedSectorId != current.selectedSectorId ||
              previous.data != current.data,
          builder: (context, state) => FractionallySizedBox(
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
                  SectorFilter(
                    sectors: state.data?.sectors ?? const [],
                    selectedId: state.selectedSectorId,
                    onSelected: cubit.selectSector,
                  ),
                  const SizedBox(height: AppSpace.md),
                  if (state.filteredPartners.isEmpty)
                    Text(strings['noResults']),
                  for (final partner in state.filteredPartners)
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      bottomNavigationBar: BlocSelector<HomeCubit, HomeState, int>(
        selector: (state) => state.selectedTab,
        builder: (context, selectedTab) => HomeNavigation(
          selectedIndex: selectedTab,
          onSelected: (index) {
            context.read<HomeCubit>().selectTab(index);
            if (index == 0) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            } else {
              _futureFeature();
            }
          },
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.data != current.data,
          builder: (context, state) {
            if (state.status == HomeStatus.initial ||
                state.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == HomeStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(strings['loadError']),
                      const SizedBox(height: AppSpace.md),
                      FilledButton(
                        onPressed: context.read<HomeCubit>().load,
                        child: Text(strings['retry']),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpace.maxWidth,
                  ),
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
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<HomeCubit>().search('');
                                  },
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
                              items: state.data!.services,
                              onSelected: (_) => _futureFeature(),
                            ),
                            const SizedBox(height: AppSpace.section),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    strings['partners'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<HomeCubit>().resetFilters();
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
                                        MediaQuery.textScalerOf(context)
                                                .scale(16) <
                                            24
                                    ? 2
                                    : 1;
                                final width =
                                    (box.maxWidth -
                                        AppSpace.md * (columns - 1)) /
                                    columns;
                                return Wrap(
                                  spacing: AppSpace.md,
                                  runSpacing: AppSpace.md,
                                  children: [
                                    for (final partner in state.data!.partners)
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
            );
          },
        ),
      ),
    );
  }
}
