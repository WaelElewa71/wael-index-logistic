import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/home_models.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.loadData}) : super(const HomeState());

  final Future<HomeData> Function() loadData;

  Future<void> load() async {
    if (isClosed || state.status == HomeStatus.loading) return;
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final data = await loadData();
      if (!isClosed) {
        emit(state.copyWith(status: HomeStatus.success, data: data));
      }
    } catch (_) {
      if (!isClosed) emit(state.copyWith(status: HomeStatus.error));
    }
  }

  void search(String query) {
    if (query == state.query) return;
    emit(state.copyWith(query: query));
  }

  void selectSector(String? id) {
    if (id == state.selectedSectorId) return;
    if (id != null &&
        !(state.data?.sectors.any((sector) => sector.id == id) ?? false)) {
      return;
    }
    emit(state.copyWith(selectedSectorId: id, clearSector: id == null));
  }

  void selectTab(int index) {
    if (index < 0 || index > 4 || index == state.selectedTab) return;
    emit(state.copyWith(selectedTab: index));
  }

  void resetFilters() {
    emit(state.copyWith(query: '', clearSector: true));
  }
}
