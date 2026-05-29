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
      name: json['title']?.toString() ?? json['name']?.toString() ?? '',
      fullAddress: json['detail_address']?.toString() ?? json['full_address']?.toString() ?? '',
      receiverName: json['receiver_name']?.toString() ?? '',
      phoneNumber: json['receiver_phone']?.toString() ?? json['phone_number']?.toString() ?? '',
      isPrimary: json['is_primary'] == true || json['is_primary'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'detail_address': fullAddress,
      'latitude': 0.0,
      'longitude': 0.0,
      'receiver_name': receiverName,
      'receiver_phone': phoneNumber,
      'is_primary': isPrimary,
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
