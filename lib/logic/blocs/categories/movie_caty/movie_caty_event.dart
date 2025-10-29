part of 'movie_caty_bloc.dart';

abstract class MovieCatyEvent extends Equatable {
  const MovieCatyEvent();

  @override
  List<Object> get props => [];
}

class LoadMovieCaty extends MovieCatyEvent {
  const LoadMovieCaty();
}
