import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, email, phone, avatar];
}
