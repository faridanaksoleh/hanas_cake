import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class SetPrimaryAddressUseCase {
  final AddressRepository repository;

  SetPrimaryAddressUseCase(this.repository);

  Future<Either<Failure, Address>> execute(int id) {
    return repository.setPrimaryAddress(id);
  }
}
