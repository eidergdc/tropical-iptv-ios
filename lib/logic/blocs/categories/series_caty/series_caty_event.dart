part of 'series_caty_bloc.dart';

abstract class SeriesCatyEvent extends Equatable {
  const SeriesCatyEvent();

  @override
  List<Object> get props => [];
}

class LoadSeriesCaty extends SeriesCatyEvent {
  const LoadSeriesCaty();
}
