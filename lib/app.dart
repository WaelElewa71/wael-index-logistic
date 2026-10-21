import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localization/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/home/data/home_mock_data.dart';
import 'features/home/presentation/home_screen.dart';

class IndexApp extends StatefulWidget {
  const IndexApp({super.key});
  @override
  State<IndexApp> createState() => _IndexAppState();
}

class _IndexAppState extends State<IndexApp> {
  Locale _locale = const Locale('ar');
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Index Logistics',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    locale: _locale,
    supportedLocales: AppStrings.supportedLocales,
    localizationsDelegates: const [
      AppStrings.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: HomeScreen(
      services: homeServices,
      partners: samplePartners,
      onLocaleChanged: (locale) => setState(() => _locale = locale),
    ),
  );
}
