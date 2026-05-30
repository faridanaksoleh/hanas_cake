import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/order_repository.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRepository repository;

  CheckoutBloc(this.repository) : super(CheckoutInitial()) {
    on<SubmitCheckoutEvent>((event, emit) async {
      emit(CheckoutLoading());
      try {
        final snapToken = await repository.checkout(event.payload);
        emit(CheckoutSuccess(snapToken));
      } catch (e) {
        emit(CheckoutError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
