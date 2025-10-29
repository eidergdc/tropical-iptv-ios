part of 'movie_caty_bloc.dart';

abstract class MovieCatyState extends Equatable {
  const MovieCatyState();

  @override
  List<Object> get props => [];
}

class MovieCatyInitial extends MovieCatyState {}

class MovieCatyLoading extends MovieCatyState {}

class MovieCatySuccess extends MovieCatyState {
  final List<CategoryModel> categories;

  const MovieCatySuccess(this.categories);

  @override
  List<Object> get props => [categories];
}

class MovieCatyFailed extends MovieCatyState {
  final String message;

  const MovieCatyFailed(this.message);

  @override
  List<Object> get props => [message];
}
