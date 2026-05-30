import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class SubmitCheckoutEvent extends CheckoutEvent {
  final Map<String, dynamic> payload;

  const SubmitCheckoutEvent(this.payload);

  @override
  List<Object> get props => [payload];
}
