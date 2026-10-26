import '../../../core/domain/localized_text.dart';
import '../../../core/domain/industry_sector.dart';

/// A snapshot of the local Home catalogue, independent of its data source.
class HomeData {
  HomeData({
    required List<ServiceItem> services,
    required List<BusinessPartner> partners,
    required List<IndustrySector> sectors,
  }) : services = List.unmodifiable(services),
       partners = List.unmodifiable(partners),
       sectors = List.unmodifiable(sectors);

  final List<ServiceItem> services;
  final List<BusinessPartner> partners;
  final List<IndustrySector> sectors;
}

enum IndexService {
  directory,
  calculator,
  dangerousGoods,
  quotations,
  networking,
  tools,
  jobs,
}

class ServiceItem {
  const ServiceItem(this.id, this.title);
  final IndexService id;
  final LocalizedText title;
}

class BusinessPartner {
  const BusinessPartner({
    required this.id,
    required this.initial,
    required this.name,
    required this.city,
    required this.tags,
    this.sectorIds = const [],
  });
  final String id;
  final String initial;
  final LocalizedText name;
  final LocalizedText city;
  final List<LocalizedText> tags;
  final List<String> sectorIds;
}
