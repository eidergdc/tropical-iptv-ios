part of 'series_caty_bloc.dart';

abstract class SeriesCatyState extends Equatable {
  const SeriesCatyState();

  @override
  List<Object> get props => [];
}

class SeriesCatyInitial extends SeriesCatyState {}

class SeriesCatyLoading extends SeriesCatyState {}

class SeriesCatySuccess extends SeriesCatyState {
  final List<CategoryModel> categories;

  const SeriesCatySuccess(this.categories);

  @override
  List<Object> get props => [categories];
}

class SeriesCatyFailed extends SeriesCatyState {
  final String message;

  const SeriesCatyFailed(this.message);

  @override
  List<Object> get props => [message];
}
