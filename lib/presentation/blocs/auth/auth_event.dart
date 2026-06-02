import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class CheckTokenEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class GetProfileEvent extends AuthEvent {}

class UpdateProfileEvent extends AuthEvent {
  final String? name;
  final String? email;
  final String? phone;
  final String? avatarPath;

  const UpdateProfileEvent({this.name, this.email, this.phone, this.avatarPath});

  @override
  List<Object> get props => [name ?? '', email ?? '', phone ?? '', avatarPath ?? ''];
}

class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class DeleteAccountEvent extends AuthEvent {}
