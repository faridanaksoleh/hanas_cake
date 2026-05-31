import 'package:equatable/equatable.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();
  
  @override
  List<Object?> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<dynamic> orders;

  const OrderHistoryLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  const OrderHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
