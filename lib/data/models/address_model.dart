import '../../domain/entities/address.dart';

class AddressModel {
  final int id;
  final String name;
  final String fullAddress;
  final String receiverName;
  final String phoneNumber;
  final bool isPrimary;

  const AddressModel({
    required this.id,
    required this.name,
    required this.fullAddress,
    required this.receiverName,
    required this.phoneNumber,
    required this.isPrimary,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      fullAddress: json['full_address']?.toString() ?? json['address']?.toString() ?? '',
      receiverName: json['receiver_name']?.toString() ?? json['contact_name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? json['phone']?.toString() ?? '',
      isPrimary: json['is_primary'] == true || json['is_primary'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'full_address': fullAddress,
      'receiver_name': receiverName,
      'phone_number': phoneNumber,
      'is_primary': isPrimary ? 1 : 0,
    };
  }

  Address toEntity() {
    return Address(
      id: id,
      name: name,
      fullAddress: fullAddress,
      receiverName: receiverName,
      phoneNumber: phoneNumber,
      isPrimary: isPrimary,
    );
  }

  factory AddressModel.fromEntity(Address entity) {
    return AddressModel(
      id: entity.id,
      name: entity.name,
      fullAddress: entity.fullAddress,
      receiverName: entity.receiverName,
      phoneNumber: entity.phoneNumber,
      isPrimary: entity.isPrimary,
    );
  }
}
