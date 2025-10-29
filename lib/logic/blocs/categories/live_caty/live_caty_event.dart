part of 'live_caty_bloc.dart';

abstract class LiveCatyEvent extends Equatable {
  const LiveCatyEvent();

  @override
  List<Object> get props => [];
}

class LoadLiveCaty extends LiveCatyEvent {
  const LoadLiveCaty();
}
