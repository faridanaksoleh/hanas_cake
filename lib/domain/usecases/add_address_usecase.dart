import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class AddAddressUseCase {
  final AddressRepository repository;

  AddAddressUseCase(this.repository);

  Future<Either<Failure, Address>> execute({
    required String name,
    required String fullAddress,
    required String receiverName,
    required String phoneNumber,
    bool isPrimary = false,
  }) {
    return repository.addAddress(
      name: name,
      fullAddress: fullAddress,
      receiverName: receiverName,
      phoneNumber: phoneNumber,
      isPrimary: isPrimary,
    );
  }
}
