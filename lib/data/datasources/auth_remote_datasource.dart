import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource({required this.dio});

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/api/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Struktur ini menyesuaikan format standar balikan Sanctum pada umumnya
        // Ubah key 'user'/'token' jika struktur JSON backend Anda berbeda
        final data = response.data;
        final userJson = data['user'];
        final token = data['token'];
        
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
}
