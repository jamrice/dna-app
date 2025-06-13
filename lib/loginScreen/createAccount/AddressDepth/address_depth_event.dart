import 'package:equatable/equatable.dart';
import 'address_depth_server_model.dart';

abstract class AddressDepthEvent extends Equatable {}

class AddressDepthMajorEvent extends AddressDepthEvent {
  @override
  List<Object?> get props => [];
}

class AddressDepthMiddleEvent extends AddressDepthEvent {
  final AddressDepthServerModel selected;

  AddressDepthMiddleEvent({required this.selected});
  @override
  List<Object?> get props => [selected];
}

class AddressDepthMinorEvent extends AddressDepthEvent {
  final AddressDepthServerModel selected;

  AddressDepthMinorEvent({required this.selected});
  @override
  List<Object?> get props => [selected];
}

class AddressDepthFinishEvent extends AddressDepthEvent {
  final AddressDepthServerModel selected;

  AddressDepthFinishEvent({required this.selected});

  @override
  List<Object?> get props => [selected];
}

class AddressDepthResetEvent extends AddressDepthEvent {
  final int type;

  AddressDepthResetEvent({required this.type});
  @override
  List<Object?> get props => [];
}