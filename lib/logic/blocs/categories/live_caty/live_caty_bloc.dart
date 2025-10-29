import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tropical_iptv_ios/repository/api/api.dart';
import 'package:tropical_iptv_ios/repository/models/category.dart';

part 'live_caty_event.dart';
part 'live_caty_state.dart';

class LiveCatyBloc extends Bloc<LiveCatyEvent, LiveCatyState> {
  final IpTvApi iptvApi;

  LiveCatyBloc(this.iptvApi) : super(LiveCatyInitial()) {
    on<LoadLiveCaty>(_onLoadLiveCaty);
  }

  Future<void> _onLoadLiveCaty(
    LoadLiveCaty event,
    Emitter<LiveCatyState> emit,
  ) async {
    emit(LiveCatyLoading());

    try {
      // "get_live_categories" é o tipo para categorias Live TV
      final categories = await iptvApi.getCategories("get_live_categories");

      if (categories.isEmpty) {
        emit(const LiveCatyFailed('Nenhuma categoria encontrada'));
      } else {
        emit(LiveCatySuccess(categories));
      }
    } catch (e) {
      emit(LiveCatyFailed('Erro ao carregar categorias: ${e.toString()}'));
    }
  }
}
