import 'package:dio/dio.dart';

abstract class OrderRemoteDataSource {
  Future<String> checkout(Map<String, dynamic> payload);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<String> checkout(Map<String, dynamic> payload) async {
    try {
      final response = await dio.post('/checkout', data: payload);
      if (response.statusCode == 200) {
        return response.data['data']['snap_token'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to checkout');
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Server Error');
      }
      throw Exception(e.toString());
    }
  }
}
