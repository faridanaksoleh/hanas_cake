import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class LogoutSuccess extends AuthState {}

class ProfileLoaded extends AuthState {
  final User user;

  const ProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileUpdateSuccess extends AuthState {
  final User user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class PasswordChangeSuccess extends AuthState {}

