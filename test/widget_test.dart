import 'package:first_app/app.dart';
import 'package:first_app/core/data/industry_sectors.dart';
import 'package:first_app/features/home/data/home_mock_data.dart';
import 'package:first_app/features/home/presentation/widgets/home_navigation.dart';
import 'package:first_app/features/home/presentation/widgets/service_grid.dart';
import 'package:first_app/core/localization/app_strings.dart';
import 'package:first_app/core/theme/app_theme.dart';
import 'package:first_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:first_app/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Loading and error are visible and retry restores Home', (
    tester,
  ) async {
    var fail = true;
    final cubit = HomeCubit(
      loadData: () async {
        if (fail) throw StateError('test failure');
        return loadHomeMockData();
      },
    );
    addTearDown(cubit.close);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('ar'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          AppStrings.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: BlocProvider.value(
          value: cubit,
          child: HomeScreen(onLocaleChanged: (_) {}),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await cubit.load();
    await tester.pumpAndSettle();
    expect(find.text('تعذر تحميل البيانات'), findsOneWidget);
    fail = false;
    await tester.tap(find.text('إعادة المحاولة'));
    await tester.pumpAndSettle();
    expect(find.byType(ServiceGrid), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Bottom navigation updates selection and preserves it across locales',
    (tester) async {
      await tester.pumpWidget(const IndexApp());
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(HomeNavigation),
          matching: find.text('الدليل'),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<HomeNavigation>(find.byType(HomeNavigation))
            .selectedIndex,
        1,
      );
      await tester.tap(find.text('AR'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<HomeNavigation>(find.byType(HomeNavigation))
            .selectedIndex,
        1,
      );
      await tester.tap(
        find.descendant(
          of: find.byType(HomeNavigation),
          matching: find.text('Home'),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<HomeNavigation>(find.byType(HomeNavigation))
            .selectedIndex,
        0,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Sector selection combines with search and all sectors clears it',
    (tester) async {
      await tester.pumpWidget(const IndexApp());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Marsa');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      final sector = find.widgetWithText(
        ChoiceChip,
        'الأغذية والحاصلات الزراعية',
      );
      await tester.ensureVisible(sector);
      await tester.tap(sector);
      await tester.pumpAndSettle();
      expect(tester.widget<ChoiceChip>(sector).selected, isTrue);
      expect(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('مرسى للشحن — نموذج'),
        ),
        findsOneWidget,
      );
      final otherSector = find.widgetWithText(
        ChoiceChip,
        'الكيماويات والأسمدة',
      );
      await tester.ensureVisible(otherSector);
      await tester.tap(otherSector);
      await tester.pumpAndSettle();
      expect(find.text('لا توجد نتائج تجريبية مطابقة'), findsOneWidget);
      final all = find.widgetWithText(ChoiceChip, 'كل القطاعات');
      await tester.ensureVisible(all);
      await tester.tap(all);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('مرسى للشحن — نموذج'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  test('Eight sectors have stable unique identifiers and translated names', () {
    expect(industrySectors, hasLength(8));
    expect(industrySectors.map((sector) => sector.id).toSet(), hasLength(8));
    for (final sector in industrySectors) {
      for (final language in ['ar', 'en', 'fr']) {
        expect(sector.name.resolve(language), isNotEmpty);
      }
    }
  });

  testWidgets(
    'Starts at Arabic Home and keeps navigation visible after scrolling',
    (tester) async {
      await tester.pumpWidget(const IndexApp());
      await tester.pumpAndSettle();
      expect(find.text('أهلاً بيك يا ضيفنا'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(ServiceGrid))),
        TextDirection.rtl,
      );
      expect(homeServices, hasLength(7));
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -1600),
      );
      await tester.pumpAndSettle();
      expect(find.text('بيانات تجريبية'), findsNWidgets(2));
      expect(find.byType(HomeNavigation).hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Switches to English and French with correct direction', (
    tester,
  ) async {
    await tester.pumpWidget(const IndexApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('AR'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, our guest'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(ServiceGrid))),
      TextDirection.ltr,
    );
    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();
    expect(find.text('Bonjour, cher visiteur'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Search filters fictional companies and explains HS and UN limits',
    (tester) async {
      await tester.pumpWidget(const IndexApp());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Marsa');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('مرسى للشحن — نموذج'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('وصل للتخليص — نموذج'),
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final width in [320.0, 390.0, 768.0, 1280.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('No overflow at width $width and text scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(const IndexApp());
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();
        expect(find.byType(ChoiceChip), findsNWidgets(9));
        expect(tester.takeException(), isNull);
        await tester.drag(
          find.descendant(
            of: find.byType(BottomSheet),
            matching: find.byType(SingleChildScrollView),
          ),
          const Offset(0, -5000),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -5000),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
