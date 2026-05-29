import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;

  UpdateAddressUseCase(this.repository);

  Future<Either<Failure, Address>> execute({
    required int id,
    String? name,
    String? fullAddress,
    String? receiverName,
    String? phoneNumber,
    bool? isPrimary,
  }) {
    return repository.updateAddress(
      id: id,
      name: name,
      fullAddress: fullAddress,
      receiverName: receiverName,
      phoneNumber: phoneNumber,
      isPrimary: isPrimary,
    );
  }
}
