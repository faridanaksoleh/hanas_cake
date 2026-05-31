import 'package:equatable/equatable.dart';

abstract class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrderHistoryEvent extends OrderHistoryEvent {}
