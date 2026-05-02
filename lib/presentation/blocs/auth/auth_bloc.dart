import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthLocalDatasource localDatasource;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
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
  }
}
