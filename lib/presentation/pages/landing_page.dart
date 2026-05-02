import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Gambar Roti dengan Gradient Overlay
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/bg_landing.png',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.surface.withValues(alpha: 0.0),
                          AppColors.surface.withValues(alpha: 0.0),
                          AppColors.surface.withValues(alpha: 0.8),
                          AppColors.surface,
                        ],
                        stops: const [0.0, 0.5, 0.85, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Konten Utama (Logo, Teks, Tombol)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpaceHeight(MediaQuery.of(context).size.height * 0.40),
                Image.asset(
                  'assets/images/home.png',
                  width: 140,
                ),
                const SpaceHeight(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        'Temukan\nKue & Roti Favoritmu',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.display.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SpaceHeight(12),
                      Text(
                        'Pilih aneka kue manis, roti fresh, dan dessert lezat\ndalam satu aplikasi',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceHeight(48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      AppButton.primary(
                        text: 'Daftar',
                        onPressed: () => GoRouter.of(context).push('/register'),
                      ),
                      const SpaceHeight(16),
                      AppButton.outline(
                        text: 'Masuk',
                        onPressed: () => GoRouter.of(context).push('/login'),
                      ),
                    ],
                  ),
                ),
                const SpaceHeight(40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}