import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import '../../../data/datasources/auth_local_datasource.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    const secureStorage = FlutterSecureStorage();
    final localDatasource = AuthLocalDatasource(secureStorage: secureStorage);
    
    final String? token = await localDatasource.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      GoRouter.of(context).go('/home');
    } else {
      GoRouter.of(context).go('/landing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cake,
              size: 100,
              color: AppColors.primary,
            ),
            const SpaceHeight(24),
            Text(
              "Hana's Cake",
              style: AppTextStyles.display.copyWith(
                color: AppColors.primary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
