import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;

  DeleteAddressUseCase(this.repository);

  Future<Either<Failure, void>> execute(int id) {
    return repository.deleteAddress(id);
  }
}
