import 'package:dio/dio.dart';
import '../models/address_model.dart';

class AddressRemoteDatasource {
  final Dio dio;

  AddressRemoteDatasource({required this.dio});

  /// GET /addresses
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await dio.get('/addresses');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] is List
            ? response.data['data'] as List<dynamic>
            : (response.data['data']['data'] as List<dynamic>?) ?? [];
        return data
            .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Gagal memuat daftar alamat');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal memuat daftar alamat');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat alamat: $e');
    }
  }

  /// POST /addresses
  Future<AddressModel> addAddress(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('/addresses', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data['data'] as Map<String, dynamic>;
        return AddressModel.fromJson(responseData);
      } else {
        throw Exception('Gagal menambahkan alamat');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal menambahkan alamat');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menambahkan alamat: $e');
    }
  }

  /// PUT /addresses/{id}
  Future<AddressModel> updateAddress(int id, Map<String, dynamic> data) async {
    try {
      final response = await dio.put('/addresses/$id', data: data);

      if (response.statusCode == 200) {
        final responseData = response.data['data'] as Map<String, dynamic>;
        return AddressModel.fromJson(responseData);
      } else {
        throw Exception('Gagal memperbarui alamat');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal memperbarui alamat');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memperbarui alamat: $e');
    }
  }

  /// DELETE /addresses/{id}
  Future<void> deleteAddress(int id) async {
    try {
      final response = await dio.delete('/addresses/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus alamat');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal menghapus alamat');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghapus alamat: $e');
    }
  }

  /// PATCH /addresses/{id}/primary
  Future<void> setPrimaryAddress(int id) async {
    try {
      final response = await dio.patch('/addresses/$id/primary');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal mengatur alamat utama');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal mengatur alamat utama');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengatur alamat utama: $e');
    }
  }
}
