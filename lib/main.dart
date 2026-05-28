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
import 'package:hanas_cake/domain/usecases/logout_usecase.dart';
import 'package:hanas_cake/domain/usecases/get_profile_usecase.dart';
import 'package:hanas_cake/domain/usecases/update_profile_usecase.dart';
import 'package:hanas_cake/domain/usecases/change_password_usecase.dart';
import 'package:hanas_cake/presentation/blocs/auth/auth_bloc.dart';
import 'package:hanas_cake/presentation/blocs/auth/auth_event.dart';

import 'package:hanas_cake/presentation/pages/add_address_page.dart';
import 'package:hanas_cake/presentation/pages/delete_account_page.dart';
import 'package:hanas_cake/presentation/pages/home_page.dart';
import 'package:hanas_cake/presentation/pages/landing_page.dart';
import 'package:hanas_cake/presentation/pages/login_page.dart';
import 'package:hanas_cake/presentation/pages/my_account_page.dart';
import 'package:hanas_cake/presentation/pages/payment_method_page.dart';
import 'package:hanas_cake/presentation/pages/pick_up_page.dart';
import 'package:hanas_cake/presentation/pages/profile_page.dart';
import 'package:hanas_cake/presentation/pages/register_page.dart';
import 'package:hanas_cake/presentation/pages/saved_address_page.dart';
import 'package:hanas_cake/presentation/pages/splash_page.dart';
import 'package:hanas_cake/presentation/pages/terms_and_conditions_page.dart';
import 'package:hanas_cake/presentation/pages/privacy_policy_page.dart';
import 'package:hanas_cake/presentation/pages/notification_page.dart';
import 'package:hanas_cake/presentation/pages/main_layout.dart';
import 'package:hanas_cake/presentation/pages/order_page.dart';
import 'package:hanas_cake/presentation/pages/order_filter_page.dart';
import 'package:hanas_cake/presentation/pages/order_detail_page.dart';
import 'package:hanas_cake/presentation/pages/pre_order_page.dart';
import 'package:hanas_cake/presentation/pages/delivery_page.dart';
import 'package:hanas_cake/presentation/pages/branch_list_page.dart';
import 'package:hanas_cake/presentation/pages/location_picker_page.dart';
import 'package:hanas_cake/presentation/pages/my_favorite_page.dart';
import 'package:hanas_cake/presentation/pages/product_detail_page.dart';
import 'package:hanas_cake/presentation/pages/checkout_page.dart';
import 'package:hanas_cake/presentation/pages/payment_success_page.dart';
import 'package:hanas_cake/presentation/pages/settings_page.dart';
import 'package:hanas_cake/presentation/pages/setup_pin_page.dart';
import 'package:hanas_cake/presentation/pages/notification_settings_page.dart';
import 'package:hanas_cake/presentation/pages/language_settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Setup Dependencies (Idealnya menggunakan library seperti get_it)
    const secureStorage = FlutterSecureStorage();
    final authLocalDatasource = AuthLocalDatasource(
      secureStorage: secureStorage,
    );

    // Dio untuk network request
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://hanascake.syauqiebill.my.id/api',
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await authLocalDatasource.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    final authRemoteDatasource = AuthRemoteDatasource(dio: dio);
    final authRepository = AuthRepositoryImpl(
      remoteDatasource: authRemoteDatasource,
      localDatasource: authLocalDatasource,
    );

    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
    final getProfileUseCase = GetProfileUseCase(authRepository);
    final updateProfileUseCase = UpdateProfileUseCase(authRepository);
    final changePasswordUseCase = ChangePasswordUseCase(authRepository);

    final _rootNavigatorKey = GlobalKey<NavigatorState>();

    // 2. Setup GoRouter
    final GoRouter router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      redirect: (context, state) async {
        final token = await authLocalDatasource.getToken();
        final isAuthenticated = token != null && token.isNotEmpty;
        
        final isAuthRoute = state.matchedLocation == '/login' || 
                            state.matchedLocation == '/register' || 
                            state.matchedLocation == '/landing';
                            
        final isSplash = state.matchedLocation == '/';

        if (!isAuthenticated && !isAuthRoute && !isSplash) {
          // Redirect to landing if trying to access protected routes without token
          return '/landing';
        }

        if (isAuthenticated && isAuthRoute) {
          // Redirect to home if trying to access auth routes while already logged in
          return '/home';
        }

        return null; // No redirect needed
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashPage()),
        GoRoute(
          path: '/landing',
          builder: (context, state) => const LandingPage(),
        ),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/pre-order',
          builder: (context, state) => const PreOrderPage(),
        ),
        GoRoute(
          path: '/delivery',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final isFromCart = extra?['isFromCart'] as bool? ?? false;
            return DeliveryPage(isFromCart: isFromCart);
          },
        ),
        GoRoute(
          path: '/product-detail',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final isPickUp = extra?['isPickUp'] as bool? ?? false;
            return ProductDetailPage(isPickUp: isPickUp);
          },
        ),
        GoRoute(
          path: '/checkout',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final isPickUp = extra?['isPickUp'] as bool? ?? false;
            return CheckoutPage(isPickUp: isPickUp);
          },
        ),
        GoRoute(
          path: '/payment-success',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final isPickUp = extra?['isPickUp'] as bool? ?? false;
            return PaymentSuccessPage(isPickUp: isPickUp);
          },
        ),
        GoRoute(
          path: '/branch-list',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final isPickUp = extra?['isPickUp'] as bool? ?? false;
            return BranchListPage(isPickUp: isPickUp);
          },
        ),
        GoRoute(
          path: '/location-picker',
          builder: (context, state) => const LocationPickerPage(),
        ),
        GoRoute(
          path: '/my-favorite',
          builder: (context, state) => const MyFavoritePage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/settings/notifications',
          builder: (context, state) => const NotificationSettingsPage(),
        ),
        GoRoute(
          path: '/settings/language',
          builder: (context, state) => const LanguageSettingsPage(),
        ),
        GoRoute(
          path: '/setup-pin',
          builder: (context, state) => const SetupPinPage(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainLayout(navigationShell: navigationShell);
          },
          branches: [
            // TAB 0: HOME
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    final hasActiveOrder =
                        extra?['hasActiveOrder'] as bool? ?? false;
                    final isPickUpActiveOrder =
                        extra?['isPickUp'] as bool? ?? false;
                    return HomePage(
                      hasActiveOrder: hasActiveOrder,
                      isPickUpActiveOrder: isPickUpActiveOrder,
                    );
                  },
                ),
              ],
            ),

            // TAB 2: ORDER
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/order',
                  builder: (context, state) => const OrderPage(),
                  routes: [
                    GoRoute(
                      path: 'filter',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) => const OrderFilterPage(),
                    ),
                    GoRoute(
                      path: 'detail',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final extra = state.extra as Map<String, dynamic>?;
                        final isPickUp = extra?['isPickUp'] as bool? ?? false;
                        return OrderDetailPage(isPickUp: isPickUp);
                      },
                    ),
                  ],
                ),
              ],
            ),
            // TAB 3: PROFILE
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/pickup',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final isFromCart = extra?['isFromCart'] as bool? ?? false;
            return PickUpPage(isFromCart: isFromCart);
          },
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
        GoRoute(
          path: '/payment-method',
          builder: (context, state) => const PaymentMethodPage(),
        ),
        GoRoute(
          path: '/terms',
          builder: (context, state) => const TermsAndConditionsPage(),
        ),
        GoRoute(
          path: '/privacy',
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
        GoRoute(
          path: '/notification',
          builder: (context, state) => const NotificationPage(),
        ),
      ],
    );

    // 3. Setup MaterialApp dengan Router dan Global BlocProvider
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            logoutUseCase: logoutUseCase,
            getProfileUseCase: getProfileUseCase,
            updateProfileUseCase: updateProfileUseCase,
            changePasswordUseCase: changePasswordUseCase,
            localDatasource: authLocalDatasource,
          )..add(CheckTokenEvent()),
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
