import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, void>> execute({required String currentPassword, required String newPassword}) {
    return repository.changePassword(currentPassword: currentPassword, newPassword: newPassword);
  }
}
