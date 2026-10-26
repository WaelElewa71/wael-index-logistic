import '../../domain/home_models.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.query = '',
    this.selectedSectorId,
    this.selectedTab = 0,
  });

  final HomeStatus status;
  final HomeData? data;
  final String query;
  final String? selectedSectorId;
  final int selectedTab;

  List<BusinessPartner> get filteredPartners {
    final normalized = query.trim().toLowerCase();
    return List.unmodifiable(
      (data?.partners ?? <BusinessPartner>[]).where(
        (partner) =>
            (selectedSectorId == null ||
                partner.sectorIds.contains(selectedSectorId)) &&
            [
              partner.name.ar,
              partner.name.en,
              partner.name.fr,
              partner.city.ar,
              partner.city.en,
              partner.city.fr,
              for (final tag in partner.tags) ...[tag.ar, tag.en, tag.fr],
            ].any((text) => text.toLowerCase().contains(normalized)),
      ),
    );
  }

  HomeState copyWith({
    HomeStatus? status,
    HomeData? data,
    String? query,
    String? selectedSectorId,
    bool clearSector = false,
    int? selectedTab,
  }) => HomeState(
    status: status ?? this.status,
    data: data ?? this.data,
    query: query ?? this.query,
    selectedSectorId: clearSector
        ? null
        : selectedSectorId ?? this.selectedSectorId,
    selectedTab: selectedTab ?? this.selectedTab,
  );
}
