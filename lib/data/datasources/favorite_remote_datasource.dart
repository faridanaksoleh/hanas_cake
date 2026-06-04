import 'package:dio/dio.dart';
import '../models/product_model.dart';

class FavoriteRemoteDatasource {
  final Dio dio;

  FavoriteRemoteDatasource({required this.dio});

  /// GET /favorites — Ambil semua produk favorit user
  Future<List<ProductModel>> getFavorites() async {
    try {
      final response = await dio.get('/favorites');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        return data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Gagal memuat favorit');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat favorit');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat favorit: $e');
    }
  }

  /// POST /favorites/toggle/{product_id} — Toggle favorit
  Future<bool> toggleFavorite(int productId) async {
    try {
      final response = await dio.post('/favorites/toggle/$productId');

      if (response.statusCode == 200) {
        return response.data['data']['is_favorited'] as bool;
      } else {
        throw Exception('Gagal toggle favorit');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal toggle favorit');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat toggle favorit: $e');
    }
  }
}
