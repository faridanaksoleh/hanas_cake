import 'package:equatable/equatable.dart';
import '../../../domain/entities/address.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class GetAddressesEvent extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final Address address;

  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateAddressEvent extends AddressEvent {
  final int id;
  final Address address;

  const UpdateAddressEvent(this.id, this.address);

  @override
  List<Object?> get props => [id, address];
}

class DeleteAddressEvent extends AddressEvent {
  final int id;

  const DeleteAddressEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SetPrimaryAddressEvent extends AddressEvent {
  final int id;

  const SetPrimaryAddressEvent(this.id);

  @override
  List<Object?> get props => [id];
}
