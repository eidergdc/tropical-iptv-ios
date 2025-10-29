import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tropical_iptv_ios/repository/api/api.dart';
import 'package:tropical_iptv_ios/repository/models/category.dart';

part 'movie_caty_event.dart';
part 'movie_caty_state.dart';

class MovieCatyBloc extends Bloc<MovieCatyEvent, MovieCatyState> {
  final IpTvApi iptvApi;

  MovieCatyBloc(this.iptvApi) : super(MovieCatyInitial()) {
    on<LoadMovieCaty>(_onLoadMovieCaty);
  }

  Future<void> _onLoadMovieCaty(
    LoadMovieCaty event,
    Emitter<MovieCatyState> emit,
  ) async {
    emit(MovieCatyLoading());

    try {
      // "get_vod_categories" é o tipo para categorias de Movies
      final categories = await iptvApi.getCategories("get_vod_categories");

      if (categories.isEmpty) {
        emit(const MovieCatyFailed('Nenhuma categoria encontrada'));
      } else {
        emit(MovieCatySuccess(categories));
      }
    } catch (e) {
      emit(MovieCatyFailed('Erro ao carregar categorias: ${e.toString()}'));
    }
  }
}
