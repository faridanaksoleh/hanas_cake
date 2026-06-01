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

  Future<void> logout() async {
    try {
      await dio.post('/logout');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal logout');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat logout: $e');
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await dio.get('/profile');

      if (response.statusCode == 200) {
        final userJson = response.data['data'];
        return UserModel.fromJson(userJson);
      } else {
        throw Exception('Gagal memuat profil');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat profil');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat profil: $e');
    }
  }

  Future<UserModel> updateProfile({String? name, String? email, String? phone, String? avatarPath}) async {
    try {
      final formData = FormData();

      if (name != null) formData.fields.add(MapEntry('name', name));
      if (email != null) formData.fields.add(MapEntry('email', email));
      if (phone != null) formData.fields.add(MapEntry('phone', phone));
      if (avatarPath != null) {
        formData.files.add(MapEntry(
          'avatar',
          await MultipartFile.fromFile(avatarPath),
        ));
      }

      final response = await dio.post('/profile/update', data: formData);

      if (response.statusCode == 200) {
        final userJson = response.data['data'];
        return UserModel.fromJson(userJson);
      } else {
        throw Exception('Gagal memperbarui profil');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memperbarui profil');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memperbarui profil: $e');
    }
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    try {
      final response = await dio.post(
        '/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengganti password');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengganti password');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengganti password: $e');
    }
  }
}

