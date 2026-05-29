import 'package:dartz/dartz.dart';

import '../datasources/address_remote_datasource.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../../core/errors/failures.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDatasource remoteDatasource;

  AddressRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      final models = await remoteDatasource.getAddresses();
      final addresses = models.map((m) => m.toEntity()).toList();
      return Right(addresses);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress({
    required String name,
    required String fullAddress,
    required String receiverName,
    required String phoneNumber,
    bool isPrimary = false,
  }) async {
    try {
      final data = {
        'title': name,
        'detail_address': fullAddress,
        'latitude': 0.0,
        'longitude': 0.0,
        'receiver_name': receiverName,
        'receiver_phone': phoneNumber,
        'is_primary': isPrimary,
      };
      final model = await remoteDatasource.addAddress(data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress({
    required int id,
    String? name,
    String? fullAddress,
    String? receiverName,
    String? phoneNumber,
    bool? isPrimary,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['title'] = name;
      if (fullAddress != null) data['detail_address'] = fullAddress;
      data['latitude'] = 0.0;
      data['longitude'] = 0.0;
      if (receiverName != null) data['receiver_name'] = receiverName;
      if (phoneNumber != null) data['receiver_phone'] = phoneNumber;
      if (isPrimary != null) data['is_primary'] = isPrimary;

      final model = await remoteDatasource.updateAddress(id, data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(int id) async {
    try {
      await remoteDatasource.deleteAddress(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> setPrimaryAddress(int id) async {
    try {
      final model = await remoteDatasource.setPrimaryAddress(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
