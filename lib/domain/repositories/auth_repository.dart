import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String name, String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, User>> updateProfile({String? name, String? phone, String? avatarPath});
  Future<Either<Failure, void>> changePassword({required String currentPassword, required String newPassword});
}
