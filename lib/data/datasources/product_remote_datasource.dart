import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  final Dio dio;

  ProductRemoteDatasource({required this.dio});

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('/categories');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        return data
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Gagal memuat kategori');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat kategori');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat kategori: $e');
    }
  }

  Future<List<ProductModel>> getProducts({int? categoryId, int page = 1}) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (categoryId != null) {
        queryParams['category_id'] = categoryId;
      }

      final response = await dio.get('/products', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['data']['data'] as List<dynamic>;
        return data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Gagal memuat produk');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat produk');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat produk: $e');
    }
  }

  Future<ProductModel> getProductDetail(int id) async {
    try {
      final response = await dio.get('/products/$id');

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return ProductModel.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail produk');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal memuat detail produk');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat detail produk: $e');
    }
  }
}
