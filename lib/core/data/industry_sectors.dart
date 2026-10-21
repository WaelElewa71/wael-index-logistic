import '../domain/industry_sector.dart';
import '../domain/localized_text.dart';

const industrySectors = <IndustrySector>[
  IndustrySector(
    id: 'food_agriculture',
    name: LocalizedText(
      'المنتجات الغذائية والزراعية',
      'Food and Agricultural Products',
      'Produits alimentaires et agricoles',
    ),
  ),
  IndustrySector(
    id: 'textiles_clothing_leather',
    name: LocalizedText(
      'المنسوجات والملابس والجلود',
      'Textiles, Clothing and Leather',
      'Textiles, vêtements et cuir',
    ),
  ),
  IndustrySector(
    id: 'chemicals_fertilizers',
    name: LocalizedText(
      'الكيماويات والأسمدة',
      'Chemicals and Fertilizers',
      'Produits chimiques et engrais',
    ),
  ),
  IndustrySector(
    id: 'construction_metals',
    name: LocalizedText(
      'مواد البناء والمعادن',
      'Construction Materials and Metals',
      'Matériaux de construction et métaux',
    ),
  ),
  IndustrySector(
    id: 'engineering_electronics_appliances',
    name: LocalizedText(
      'الصناعات الهندسية والإلكترونيات والأجهزة',
      'Engineering Industries, Electronics and Appliances',
      'Industries mécaniques, électronique et appareils',
    ),
  ),
  IndustrySector(
    id: 'pharmaceuticals_medical',
    name: LocalizedText(
      'الأدوية والمستلزمات الطبية',
      'Pharmaceuticals and Medical Supplies',
      'Produits pharmaceutiques et fournitures médicales',
    ),
  ),
  IndustrySector(
    id: 'handicrafts_heritage',
    name: LocalizedText(
      'الحرف اليدوية والمنتجات التراثية',
      'Handicrafts and Heritage Products',
      'Artisanat et produits du patrimoine',
    ),
  ),
  IndustrySector(
    id: 'furniture_wood',
    name: LocalizedText(
      'الأثاث والصناعات الخشبية',
      'Furniture and Wood Industries',
      'Meubles et industries du bois',
    ),
  ),
];
