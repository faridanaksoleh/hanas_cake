import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'package:hanas_cake/core/theme/app_theme.dart';
import 'package:hanas_cake/data/datasources/auth_local_datasource.dart';
import 'package:hanas_cake/data/datasources/auth_remote_datasource.dart';
import 'package:hanas_cake/data/repositories/auth_repository_impl.dart';
import 'package:hanas_cake/domain/usecases/login_usecase.dart';
import 'package:hanas_cake/domain/usecases/register_usecase.dart';
import 'package:hanas_cake/presentation/blocs/auth/auth_bloc.dart';

import 'package:hanas_cake/presentation/pages/add_address_page.dart';
import 'package:hanas_cake/presentation/pages/delete_account_page.dart';
import 'package:hanas_cake/presentation/pages/home_page.dart';
import 'package:hanas_cake/presentation/pages/landing_page.dart';
import 'package:hanas_cake/presentation/pages/login_page.dart';
import 'package:hanas_cake/presentation/pages/my_account_page.dart';
import 'package:hanas_cake/presentation/pages/pick_up_page.dart';
import 'package:hanas_cake/presentation/pages/profile_page.dart';
import 'package:hanas_cake/presentation/pages/register_page.dart';
import 'package:hanas_cake/presentation/pages/saved_address_page.dart';
import 'package:hanas_cake/presentation/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Setup Dependencies (Idealnya menggunakan library seperti get_it)
    // Dio untuk network request
    final dio = Dio(BaseOptions(baseUrl: 'https://hanascake.syauqiebill.my.id/api')); 
    const secureStorage = FlutterSecureStorage();
    
    final authRemoteDatasource = AuthRemoteDatasource(dio: dio);
    final authLocalDatasource = AuthLocalDatasource(secureStorage: secureStorage);
    
    final authRepository = AuthRepositoryImpl(
      remoteDatasource: authRemoteDatasource,
      localDatasource: authLocalDatasource,
    );
    
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);

    // 2. Setup GoRouter
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/landing',
          builder: (context, state) => const LandingPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/pickup',
          builder: (context, state) => const PickUpPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: '/my-account',
          builder: (context, state) => const MyAccountPage(),
        ),
        GoRoute(
          path: '/delete-account',
          builder: (context, state) => const DeleteAccountPage(),
        ),
        GoRoute(
          path: '/saved-address',
          builder: (context, state) => const SavedAddressPage(),
        ),
        GoRoute(
          path: '/add-address',
          builder: (context, state) => const AddAddressPage(),
        ),
      ],
    );

    // 3. Setup MaterialApp dengan Router dan Global BlocProvider
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            localDatasource: authLocalDatasource,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: "Hana's Cake",
        debugShowCheckedModeBanner: false, // Menghilangkan banner merah
        theme: AppTheme.applicationTheme,
        routerConfig: router,
      ),
    );
  }
}
