import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? token;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      // Mengambil token dari parameter atau dari json jika tersedia
      token: token ?? json['token'] as String?, 
    );
  }

  @override
  List<Object?> get props => [id, name, email, token];
}
