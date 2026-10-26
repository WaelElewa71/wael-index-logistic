import '../../../core/domain/localized_text.dart';
import '../../../core/data/industry_sectors.dart';
import '../domain/home_models.dart';

Future<HomeData> loadHomeMockData() async => HomeData(
  services: homeServices,
  partners: samplePartners,
  sectors: industrySectors,
);

const homeServices = <ServiceItem>[
  ServiceItem(
    IndexService.directory,
    LocalizedText(
      'دليل الشركات والخدمات',
      'Company & service directory',
      'Annuaire des sociétés et services',
    ),
  ),
  ServiceItem(
    IndexService.calculator,
    LocalizedText(
      'حاسبة الحاويات والشحن',
      'Container & shipping calculator',
      'Calculateur de conteneurs et transport',
    ),
  ),
  ServiceItem(
    IndexService.dangerousGoods,
    LocalizedText(
      'دليل البضائع الخطرة',
      'Dangerous goods guide',
      'Guide des marchandises dangereuses',
    ),
  ),
  ServiceItem(
    IndexService.quotations,
    LocalizedText(
      'طلبات الأسعار والعروض',
      'Quotation requests',
      'Demandes de devis',
    ),
  ),
  ServiceItem(
    IndexService.networking,
    LocalizedText(
      'شبكة الأعمال والتوفيق',
      'Business networking',
      'Réseau professionnel',
    ),
  ),
  ServiceItem(
    IndexService.tools,
    LocalizedText('أدوات ذكية', 'Smart tools', 'Outils intelligents'),
  ),
  ServiceItem(
    IndexService.jobs,
    LocalizedText(
      'وظائف وفرص لوجستية',
      'Logistics jobs & opportunities',
      'Emplois et opportunités logistiques',
    ),
  ),
];

/// Fictional fixtures without verification, rates or real contact details.
const samplePartners = <BusinessPartner>[
  BusinessPartner(
    id: 'demo_shipping',
    sectorIds: ['food_agriculture', 'textiles_clothing_leather'],
    initial: 'M',
    name: LocalizedText(
      'مرسى للشحن — نموذج',
      'Marsa Shipping — demo',
      'Marsa Transport — démo',
    ),
    city: LocalizedText('الإسكندرية', 'Alexandria', 'Alexandrie'),
    tags: [
      LocalizedText(
        'شحن دولي',
        'International shipping',
        'Transport international',
      ),
      LocalizedText('شحن جوي', 'Air freight', 'Fret aérien'),
    ],
  ),
  BusinessPartner(
    id: 'demo_customs',
    sectorIds: ['chemicals_fertilizers', 'construction_metals'],
    initial: 'W',
    name: LocalizedText(
      'وصل للتخليص — نموذج',
      'Wasl Customs — demo',
      'Wasl Douane — démo',
    ),
    city: LocalizedText('القاهرة', 'Cairo', 'Le Caire'),
    tags: [
      LocalizedText('تخليص جمركي', 'Customs clearance', 'Dédouanement'),
      LocalizedText(
        'شحن دولي',
        'International shipping',
        'Transport international',
      ),
    ],
  ),
];
