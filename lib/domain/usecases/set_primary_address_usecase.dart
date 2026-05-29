import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/address_repository.dart';

class SetPrimaryAddressUseCase {
  final AddressRepository repository;

  SetPrimaryAddressUseCase(this.repository);

  Future<Either<Failure, void>> execute(int id) {
    return repository.setPrimaryAddress(id);
  }
}
