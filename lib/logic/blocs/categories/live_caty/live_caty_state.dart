part of 'live_caty_bloc.dart';

abstract class LiveCatyState extends Equatable {
  const LiveCatyState();

  @override
  List<Object> get props => [];
}

class LiveCatyInitial extends LiveCatyState {}

class LiveCatyLoading extends LiveCatyState {}

class LiveCatySuccess extends LiveCatyState {
  final List<CategoryModel> categories;

  const LiveCatySuccess(this.categories);

  @override
  List<Object> get props => [categories];
}

class LiveCatyFailed extends LiveCatyState {
  final String message;

  const LiveCatyFailed(this.message);

  @override
  List<Object> get props => [message];
}
