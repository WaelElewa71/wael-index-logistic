import '../../../core/domain/localized_text.dart';

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
