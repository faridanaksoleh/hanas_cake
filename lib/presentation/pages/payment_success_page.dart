import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import 'package:url_launcher/url_launcher.dart'; // 🔥 Wajib untuk buka WhatsApp

class PaymentSuccessPage extends StatelessWidget {
  final bool isPickUp;

  const PaymentSuccessPage({super.key, this.isPickUp = false});

  Future<void> _launchWhatsApp(BuildContext context) async {
    final Uri url = Uri.parse('https://wa.me/6285798203978');

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch WhatsApp');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Gagal membuka WhatsApp. Pastikan aplikasi terinstal.',
            ),
            backgroundColor: AppColors.dangerBg,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        // 🔥 FIX: Layout dipisah 100% agar tidak saling merusak
        child: isPickUp
            ? _buildPickUpView(context)
            : _buildDeliveryView(context),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // UI KHUSUS PICK UP (TIDAK DIUBAH SAMA SEKALI)
  // ─────────────────────────────────────────────────────────
  Widget _buildPickUpView(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Row(
            children: [
              Image.asset(
                'assets/images/payment_success.png',
                width: 100,
                fit: BoxFit.contain,
              ),
              const SpaceWidth(20),
              Expanded(
                child: Text(
                  'Payment Success',
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryXLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/branch2.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SpaceWidth(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alamat Cabang terdekat',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SpaceHeight(4),
                    RichText(
                      text: TextSpan(
                        text: '19.48 km • ',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terdekat',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.surface),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '853',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
              const SpaceHeight(12),
              Text(
                'Tunjukkan halaman ini kepada\nkasir untuk ambil pesanan.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _launchWhatsApp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/whatsapp_logo.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SpaceWidth(8),
                      Text(
                        'Hubungi CS',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SpaceHeight(12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/home', extra: {
                      'hasActiveOrder': true, 
                      'isPickUp': isPickUp,
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // UI KHUSUS DELIVERY (BARU: SESUAI FIGMA)
  // ─────────────────────────────────────────────────────────
  Widget _buildDeliveryView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/payment_success.png',
                width: 220,
                fit: BoxFit.contain,
              ),
              const SpaceHeight(32),
              Text(
                'Payment Success',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold, // Tambahan bold agar tajam
                ),
              ),
              const SpaceHeight(12),
              Text(
                'Thanks for your order',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SpaceHeight(4),
              Text(
                'Order-ID :abc123',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Sementara arahkan ke order detail
                    GoRouter.of(
                      context,
                    ).push('/order/detail', extra: {'isPickUp': isPickUp});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Track Order',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SpaceHeight(12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/home', extra: {
                      'hasActiveOrder': true, 
                      'isPickUp': isPickUp,
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
