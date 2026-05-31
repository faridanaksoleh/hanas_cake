import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/order_repository.dart';
import 'order_history_event.dart';
import 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderRepository repository;

  OrderHistoryBloc(this.repository) : super(OrderHistoryInitial()) {
    on<FetchOrderHistoryEvent>((event, emit) async {
      emit(OrderHistoryLoading());
      try {
        final orders = await repository.getOrders();
        emit(OrderHistoryLoaded(orders));
      } catch (e) {
        emit(OrderHistoryError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
