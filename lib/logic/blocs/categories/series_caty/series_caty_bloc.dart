import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tropical_iptv_ios/repository/api/api.dart';
import 'package:tropical_iptv_ios/repository/models/category.dart';

part 'series_caty_event.dart';
part 'series_caty_state.dart';

class SeriesCatyBloc extends Bloc<SeriesCatyEvent, SeriesCatyState> {
  final IpTvApi iptvApi;

  SeriesCatyBloc(this.iptvApi) : super(SeriesCatyInitial()) {
    on<LoadSeriesCaty>(_onLoadSeriesCaty);
  }

  Future<void> _onLoadSeriesCaty(
    LoadSeriesCaty event,
    Emitter<SeriesCatyState> emit,
  ) async {
    emit(SeriesCatyLoading());

    try {
      // "get_series_categories" é o tipo para categorias de Series
      final categories = await iptvApi.getCategories("get_series_categories");

      if (categories.isEmpty) {
        emit(const SeriesCatyFailed('Nenhuma categoria encontrada'));
      } else {
        emit(SeriesCatySuccess(categories));
      }
    } catch (e) {
      emit(SeriesCatyFailed('Erro ao carregar categorias: ${e.toString()}'));
    }
  }
}
