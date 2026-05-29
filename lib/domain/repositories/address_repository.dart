import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/address.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<Address>>> getAddresses();
  Future<Either<Failure, Address>> addAddress({
    required String name,
    required String fullAddress,
    required String receiverName,
    required String phoneNumber,
    bool isPrimary = false,
  });
  Future<Either<Failure, Address>> updateAddress({
    required int id,
    String? name,
    String? fullAddress,
    String? receiverName,
    String? phoneNumber,
    bool? isPrimary,
  });
  Future<Either<Failure, void>> deleteAddress(int id);
  Future<Either<Failure, void>> setPrimaryAddress(int id);
}
