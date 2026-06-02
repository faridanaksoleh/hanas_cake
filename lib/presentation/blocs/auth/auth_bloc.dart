import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/get_profile_usecase.dart';
import '../../../domain/usecases/update_profile_usecase.dart';
import '../../../domain/usecases/change_password_usecase.dart';
import '../../../domain/usecases/delete_account_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final AuthLocalDatasource localDatasource;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    required this.deleteAccountUseCase,
    required this.localDatasource,
  }) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      
      final result = await loginUseCase.execute(event.email, event.password);
      
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthSuccess(user)),
      );
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      
      final result = await registerUseCase.execute(event.name, event.email, event.password);
      
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthSuccess(user)),
      );
    });

    on<CheckTokenEvent>((event, emit) async {
      emit(AuthLoading());
      final token = await localDatasource.getToken();
      if (token != null && token.isNotEmpty) {
        emit(const AuthSuccess(User(id: 0, name: '', email: '')));
      } else {
        emit(AuthInitial());
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await logoutUseCase.execute();
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (_) => emit(LogoutSuccess()),
      );
    });

    on<GetProfileEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await getProfileUseCase.execute();
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(ProfileLoaded(user)),
      );
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await updateProfileUseCase.execute(
        name: event.name,
        email: event.email,
        phone: event.phone,
        avatarPath: event.avatarPath,
      );
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(ProfileUpdateSuccess(user)),
      );
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await changePasswordUseCase.execute(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (_) => emit(PasswordChangeSuccess()),
      );
    });

    on<DeleteAccountEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await deleteAccountUseCase.execute();
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (_) => emit(DeleteAccountSuccess()),
      );
    });
  }
}
