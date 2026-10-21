/// Framework-independent localized content for taxonomy and demo models.
class LocalizedText {
  const LocalizedText(this.ar, this.en, this.fr);
  final String ar;
  final String en;
  final String fr;
  String resolve(String languageCode) => switch (languageCode) {
    'en' => en,
    'fr' => fr,
    _ => ar,
  };
}
