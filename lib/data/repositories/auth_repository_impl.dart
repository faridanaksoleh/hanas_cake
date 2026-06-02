import 'package:dartz/dartz.dart';

import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final userModel = await remoteDatasource.login(email, password);
      
      if (userModel.token != null) {
        await localDatasource.saveToken(userModel.token!);
      }

      final user = User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        phone: userModel.phone,
        avatar: userModel.avatar,
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString())); 
    }
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password) async {
    try {
      final userModel = await remoteDatasource.register(name, email, password);
      
      if (userModel.token != null) {
        await localDatasource.saveToken(userModel.token!);
      }

      final user = User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        phone: userModel.phone,
        avatar: userModel.avatar,
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString())); 
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDatasource.logout();
      await localDatasource.removeToken();
      return const Right(null);
    } catch (e) {
      // Tetap hapus token lokal meskipun request gagal
      await localDatasource.removeToken();
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final userModel = await remoteDatasource.getProfile();

      final user = User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        phone: userModel.phone,
        avatar: userModel.avatar,
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({String? name, String? email, String? phone, String? avatarPath}) async {
    try {
      final userModel = await remoteDatasource.updateProfile(
        name: name,
        email: email,
        phone: phone,
        avatarPath: avatarPath,
      );

      final user = User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        phone: userModel.phone,
        avatar: userModel.avatar,
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({required String currentPassword, required String newPassword}) async {
    try {
      await remoteDatasource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDatasource.deleteAccount();
      await localDatasource.removeToken();
      return const Right(null);
    } catch (e) {
      await localDatasource.removeToken();
      return Left(ServerFailure(e.toString()));
    }
  }
}

