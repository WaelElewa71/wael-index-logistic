import 'dart:async';

import 'package:first_app/features/home/data/home_mock_data.dart';
import 'package:first_app/features/home/domain/home_models.dart';
import 'package:first_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:first_app/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('initial -> loading -> success exposes the catalogue', () async {
    final cubit = HomeCubit(loadData: loadHomeMockData);
    addTearDown(cubit.close);
    expect(cubit.state.status, HomeStatus.initial);
    final states = <HomeStatus>[];
    final subscription = cubit.stream.listen(
      (state) => states.add(state.status),
    );
    addTearDown(subscription.cancel);
    await cubit.load();
    await Future<void>.delayed(Duration.zero);
    expect(states, [HomeStatus.loading, HomeStatus.success]);
    expect(cubit.state.data!.services, hasLength(7));
    expect(cubit.state.data!.sectors, hasLength(8));
    expect(cubit.state.filteredPartners, hasLength(2));
    expect(() => cubit.state.data!.partners.clear(), throwsUnsupportedError);
  });

  test('load failure can be retried successfully', () async {
    var fail = true;
    final cubit = HomeCubit(
      loadData: () async {
        if (fail) throw StateError('test failure');
        return loadHomeMockData();
      },
    );
    addTearDown(cubit.close);
    final states = <HomeStatus>[];
    final subscription = cubit.stream.listen(
      (state) => states.add(state.status),
    );
    addTearDown(subscription.cancel);
    await cubit.load();
    expect(cubit.state.status, HomeStatus.error);
    fail = false;
    await cubit.load();
    await Future<void>.delayed(Duration.zero);
    expect(states, [
      HomeStatus.loading,
      HomeStatus.error,
      HomeStatus.loading,
      HomeStatus.success,
    ]);
  });

  test('search and sector filters combine and reset independently', () async {
    final cubit = HomeCubit(loadData: loadHomeMockData);
    addTearDown(cubit.close);
    await cubit.load();
    for (final query in [
      ' MARSA ',
      'الإسكندرية',
      'Alexandrie',
      'Air freight',
    ]) {
      cubit.search(query);
      expect(cubit.state.filteredPartners.single.id, 'demo_shipping');
    }
    cubit.selectSector('chemicals_fertilizers');
    expect(cubit.state.filteredPartners, isEmpty);
    cubit.search('');
    expect(cubit.state.filteredPartners.single.id, 'demo_customs');
    cubit.selectSector('unknown');
    expect(cubit.state.selectedSectorId, 'chemicals_fertilizers');
    cubit.selectSector('furniture_wood');
    expect(cubit.state.filteredPartners, isEmpty);
    cubit.selectTab(3);
    cubit.resetFilters();
    expect(cubit.state.query, isEmpty);
    expect(cubit.state.selectedSectorId, isNull);
    expect(cubit.state.filteredPartners, hasLength(2));
    expect(cubit.state.selectedTab, 3);
  });

  test('tabs validate bounds and avoid redundant emissions', () async {
    final cubit = HomeCubit(loadData: loadHomeMockData);
    addTearDown(cubit.close);
    final tabs = <int>[];
    final subscription = cubit.stream.listen(
      (state) => tabs.add(state.selectedTab),
    );
    addTearDown(subscription.cancel);
    for (final tab in [-1, 5, 0, 2, 2, 0]) {
      cubit.selectTab(tab);
    }
    await Future<void>.delayed(Duration.zero);
    expect(tabs, [2, 0]);
  });

  test(
    'duplicate loads are ignored and completion after close is safe',
    () async {
      final completer = Completer<HomeData>();
      var calls = 0;
      final cubit = HomeCubit(
        loadData: () {
          calls++;
          return completer.future;
        },
      );
      final pending = cubit.load();
      await cubit.load();
      expect(calls, 1);
      await cubit.close();
      completer.complete(await loadHomeMockData());
      await pending;
      expect(cubit.state.status, HomeStatus.loading);
    },
  );
}
