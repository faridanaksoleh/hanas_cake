import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, User>> execute({String? name, String? phone, String? avatarPath}) {
    return repository.updateProfile(name: name, phone: phone, avatarPath: avatarPath);
  }
}
