import 'package:equatable/equatable.dart';
import '../../../domain/entities/address.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<Address> addresses;

  const AddressLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class AddressActionSuccess extends AddressState {
  final String message;

  const AddressActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressFailure extends AddressState {
  final String message;

  const AddressFailure(this.message);

  @override
  List<Object?> get props => [message];
}
