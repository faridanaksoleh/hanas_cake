import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> checkout(Map<String, dynamic> payload) async {
    try {
      return await remoteDataSource.checkout(payload);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getOrders() async {
    try {
      return await remoteDataSource.getOrders();
    } catch (e) {
      rethrow;
    }
  }
}
