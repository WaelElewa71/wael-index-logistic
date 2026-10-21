import 'package:first_app/app.dart';
import 'package:first_app/core/data/industry_sectors.dart';
import 'package:first_app/features/home/data/home_mock_data.dart';
import 'package:first_app/features/home/presentation/widgets/home_navigation.dart';
import 'package:first_app/features/home/presentation/widgets/service_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
