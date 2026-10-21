import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../domain/localized_text.dart';

class AppStrings {
  const AppStrings(this.locale);
  final Locale locale;
  static const supportedLocales = [Locale('ar'), Locale('en'), Locale('fr')];
  static const delegate = _StringsDelegate();
  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings)!;
  String text(LocalizedText value) => value.resolve(locale.languageCode);
  String operator [](String key) => text(_values[key]!);
  static const _values = <String, LocalizedText>{
    'greeting': LocalizedText(
      'مساء الخير',
      'Welcome to Index',
      'Bienvenue chez Index',
    ),
    'welcome': LocalizedText(
      'أهلاً بيك يا ضيفنا',
      'Hello, our guest',
      'Bonjour, cher visiteur',
    ),
    'language': LocalizedText(
      'اختيار اللغة',
      'Choose language',
      'Choisir la langue',
    ),
    'notifications': LocalizedText(
      'الإشعارات',
      'Notifications',
      'Notifications',
    ),
    'noNotifications': LocalizedText(
      'لا توجد إشعارات حاليًا',
      'No notifications yet',
      'Aucune notification pour le moment',
    ),
    'search': LocalizedText(
      'دور على شركة، رمز HS Code، أو رقم UN…',
      'Search company, HS Code or UN Number…',
      'Société, code SH ou numéro ONU…',
    ),
    'searchAction': LocalizedText('بحث', 'Search', 'Rechercher'),
    'searchNote': LocalizedText(
      'البحث التجريبي يعرض الشركات النموذجية فقط. بيانات HS وUN ستتوفر لاحقًا.',
      'Demo search covers sample companies only. HS and UN data will be available later.',
      'La recherche concerne les sociétés fictives. Les données SH et ONU seront disponibles ultérieurement.',
    ),
    'noResults': LocalizedText(
      'لا توجد نتائج تجريبية مطابقة',
      'No matching sample results',
      'Aucun résultat fictif correspondant',
    ),
    'quote': LocalizedText(
      'عروض أسعار',
      'Shipping quotations',
      'Devis de transport',
    ),
    'promo': LocalizedText(
      'طلب واحد، وفرص أكتر للشحن',
      'One request. More shipping opportunities.',
      'Une demande, plus de possibilités de transport.',
    ),
    'requestQuote': LocalizedText(
      'اعمل طلب سعر',
      'Request a quote',
      'Demander un devis',
    ),
    'services': LocalizedText(
      'خدمات إندكس',
      'Index services',
      'Services Index',
    ),
    'servicesTitle': LocalizedText(
      'كل اللي محتاجه في مكان واحد',
      'Everything you need in one place',
      'Tout ce dont vous avez besoin, au même endroit',
    ),
    'partners': LocalizedText(
      'شركاء ممكن يفيدوك',
      'Potential business partners',
      'Partenaires potentiels',
    ),
    'seeAll': LocalizedText('شوف الكل', 'View all', 'Tout voir'),
    'sample': LocalizedText(
      'بيانات تجريبية',
      'Sample data',
      'Données fictives',
    ),
    'sampleNote': LocalizedText(
      'شركات افتراضية للعرض فقط، دون توثيق أو توصية.',
      'Fictional companies for demonstration, without verification or endorsement.',
      'Sociétés fictives de démonstration, sans vérification ni recommandation.',
    ),
    'comingSoon': LocalizedText(
      'هذه الخدمة ستتوفر في مرحلة لاحقة.',
      'This service will be available in a later phase.',
      'Ce service sera disponible lors d’une prochaine phase.',
    ),
    'home': LocalizedText('الرئيسية', 'Home', 'Accueil'),
    'directory': LocalizedText('الدليل', 'Directory', 'Annuaire'),
    'requests': LocalizedText('طلباتي', 'My requests', 'Demandes'),
    'tools': LocalizedText('الأدوات', 'Tools', 'Outils'),
    'profile': LocalizedText('حسابي', 'Profile', 'Profil'),
  };
}

class _StringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _StringsDelegate();
  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales.any(
    (value) => value.languageCode == locale.languageCode,
  );
  @override
  Future<AppStrings> load(Locale locale) =>
      SynchronousFuture(AppStrings(locale));
  @override
  bool shouldReload(_StringsDelegate old) => false;
}
