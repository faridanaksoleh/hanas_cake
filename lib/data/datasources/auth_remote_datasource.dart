import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource({required this.dio});

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data['data'];
        final userJson = responseData['user'];
        final token = responseData['token'];
        
        return UserModel.fromJson(userJson, token: token);
      } else {
        throw Exception('Gagal melakukan login');
      }
    } on DioException catch (e) {
      // Menangkap error dari backend (misal: kredensial salah, validasi gagal, dll)
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan pada server');
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak diketahui: $e');
    }
  }
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': '08123456789',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data['data'];
        final userJson = responseData['user'];
        final token = responseData['token'];
        
        return UserModel.fromJson(userJson, token: token);
      } else {
        throw Exception('Gagal melakukan pendaftaran');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan pada server');
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak diketahui: $e');
    }
  }
}
