abstract class OrderRepository {
  Future<String> checkout(Map<String, dynamic> payload);
  Future<List<dynamic>> getOrders();
}
