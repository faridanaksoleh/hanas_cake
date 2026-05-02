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
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString())); 
    }
  }
}
