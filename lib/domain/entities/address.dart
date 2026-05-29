import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int id;
  final String name;
  final String fullAddress;
  final String receiverName;
  final String phoneNumber;
  final bool isPrimary;

  const Address({
    required this.id,
    required this.name,
    required this.fullAddress,
    required this.receiverName,
    required this.phoneNumber,
    required this.isPrimary,
  });

  @override
  List<Object?> get props => [id, name, fullAddress, receiverName, phoneNumber, isPrimary];
}
