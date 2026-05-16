import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; // Tetap perlu untuk caretLeft
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // QRIS — active method
            _buildQrisOption(),
            const SpaceHeight(24),
            // Section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Metode Pembayaran Lainnya',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SpaceHeight(12),
            // Other payment methods (🔥🔥 PAKAI .png 🔥🔥)
            _buildOtherPayment(
              iconPath: 'assets/icons/gopay.png',
              title: 'Gopay',
            ),
            _buildOtherPayment(
              iconPath: 'assets/icons/dana.png',
              title: 'Dana',
            ),
            _buildOtherPayment(
              iconPath: 'assets/icons/shopeepay.png',
              title: 'Shopeepay',
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // APP BAR
  // ──────────────────────────────────────────────────────────
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          icon: SvgPicture.asset(
            Assets.icons.caretLeft, // Panah kiri biasanya aman di web
            colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            width: 22,
            height: 22,
          ),
          onPressed: () {
            if (GoRouter.of(context).canPop()) GoRouter.of(context).pop();
          },
        ),
      ),
      title: Text(
        'Metode Pembayaran',
        style: AppTextStyles.display.copyWith(
          fontSize: 22,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // QRIS OPTION (ACTIVE)
  // ──────────────────────────────────────────────────────────
  Widget _buildQrisOption() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          // Icon with shadow AND Border
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1), // Border abu tipis
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              // 🔥🔥 PAKAI Image.asset agar muncul di web 🔥🔥
              child: Image.asset(
                'assets/icons/qris.png',
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SpaceWidth(14),
          // Title
          Text(
            'QRIS',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Active radio indicator
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.secondary, width: 2),
            ),
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // OTHER PAYMENT HELPER
  // ──────────────────────────────────────────────────────────
  Widget _buildOtherPayment({
    required String iconPath,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Icon with shadow AND border
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1), // Border abu tipis
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              // 🔥🔥 PAKAI Image.asset agar muncul di web 🔥🔥
              child: Image.asset(
                iconPath,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SpaceWidth(14),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceHeight(2),
                Text(
                  'Aktifkan sekarang',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }
}