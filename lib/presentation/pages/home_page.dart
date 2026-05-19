import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart'; 
import 'package:hanas_cake/core/core.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SpaceHeight(24),
              _buildPromoBanner(),
              const SpaceHeight(24),
              _buildOrderOptions(),
              const SpaceHeight(16),
              _buildPreorderBanner(),
              const SpaceHeight(32),
              _buildCustomerService(),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // TOP BAR 
  // ─────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi Rina, Selamat Datang!',
              style: AppTextStyles.display.copyWith( 
                color: AppColors.primary, 
                fontWeight: FontWeight.bold,
                fontSize: 22, 
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            GoRouter.of(context).push('/notification');
          }, 
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              // 🔥 FIX: Pakai SVG Bell sesuai request
              child: SvgPicture.asset(
                'assets/icons/bell.svg',
                width: 24,
                height: 24,
                // Pastikan warnanya putih
                colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // 1. PROMO BANNER 
  // ─────────────────────────────────────────────────────────
  Widget _buildPromoBanner() {
    return Container(
      height: 170, 
      width: double.infinity,
      clipBehavior: Clip.hardEdge, 
      decoration: BoxDecoration(
        color: AppColors.primary, 
        borderRadius: BorderRadius.circular(16), 
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/promo.png', 
              fit: BoxFit.fitHeight, 
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.primary, 
                    AppColors.primary, 
                    AppColors.primary.withValues(alpha: 0.0), 
                  ],
                  stops: const [0.0, 0.55, 1.0], 
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Promo Hari Ini',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400, 
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Diskon 20%\nuntuk semua pastri',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600, 
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Berlaku Sampai Pukul 17.00 WIB',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary, 
                      borderRadius: BorderRadius.circular(8), 
                    ),
                    child: Text(
                      'Pesan sekarang',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 2. ORDER OPTIONS
  // ─────────────────────────────────────────────────────────
  Widget _buildOrderOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pesan Sekarang?',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SpaceHeight(12),
        Row(
          children: [
            Expanded(child: _buildPickUpCard()),
            const SpaceWidth(12),
            Expanded(child: _buildDeliveryCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildPickUpCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 140, 
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 4,  
              bottom: 8, 
              child: Image.asset(
                'assets/images/home_pickup.png', 
                height: 110,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              right: 12,
              top: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pick Up',
                    style: AppTextStyles.h2.copyWith( 
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ambil di Store\ntanpa antri',
                    style: AppTextStyles.caption.copyWith( 
                      color: AppColors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard() {
    return Container(
      height: 140,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.primaryMid,
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: AppColors.primaryLight, width: 1.5),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 14,
            top: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery',
                  style: AppTextStyles.h2.copyWith( 
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Garansi tepat\nwaktu. dijamin!',
                  style: AppTextStyles.caption.copyWith( 
                    color: AppColors.primaryLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 4, 
            bottom: 8, 
            child: Image.asset(
              'assets/images/home_delivery.png', 
              height: 105,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 3. PREORDER BANNER
  // ─────────────────────────────────────────────────────────
  Widget _buildPreorderBanner() {
    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/pre-order'),
      child: Container(
        height: 120, 
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pre-Order',
                  style: AppTextStyles.h2.copyWith( 
                    color: AppColors.primaryLight, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceHeight(6),
                Text(
                  'Rencanakan momen spesial\nbareng hana\'s bakery',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 25, 
            bottom: 0,
            child: Image.asset(
              'assets/images/home_preorder.png', 
              height: 105,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    ));
  }

  // ─────────────────────────────────────────────────────────
  // 4. CUSTOMER SERVICE
  // ─────────────────────────────────────────────────────────
  Widget _buildCustomerService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perlu Bantuan?',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SpaceHeight(12),
        // WhatsApp CS card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/icons/whatsapp1.svg', 
                  fit: BoxFit.contain,
                ),
              ),
              const SpaceWidth(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hana's Bakery Customer Service (chat only)",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '081-2222-3333',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.successText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        const SpaceHeight(12),
        
        // HALAL CARD dengan GestureDetector
        GestureDetector(
          onTap: () => _showHalalModal(context), 
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/halal.png', 
                  width: 36, 
                  height: 36,
                  fit: BoxFit.contain,
                ),
                const SpaceWidth(12),
                Expanded(
                  child: Text(
                    "Hana's Bakery sudah tersertifikasi halal oleh MUI",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // BOTTOM SHEET MODAL (POP-UP HALAL)
  // ─────────────────────────────────────────────────────────
  void _showHalalModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              // Garis Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SpaceHeight(24),
              // Judul Modal
              Text(
                'Sertifikasi Halal',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceHeight(16),
              // Sub Judul
              Text(
                "Hana's Bakery sudah terferifikasi halal oleh MUI",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SpaceHeight(16),
              // Inner Card Halal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // 🔥 FIX: Custom Hex Color #7A5248 dengan opacity 30% sesuai Figma
                  color: const Color(0xFF7A5248).withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/halal.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                    const SpaceWidth(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Majelis Ulama Indonesia',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '( NOMOR SERTIFIKAT HALAL )',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceHeight(24),
              // Bullet Points
              _buildBulletPoint('Bebas dari bahan-bahan yang dilarang syariat islam'),
              const SpaceHeight(12),
              _buildBulletPoint('Diproses dan disajikan sesuai dengan standar islami'),
              const SpaceHeight(32),
              // Tombol Mengerti
              GestureDetector(
                onTap: () => Navigator.pop(context), 
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Saya Mengerti',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SpaceHeight(16), 
            ],
          ),
        );
      },
    );
  }

  // Helper untuk bikin List Bullet
  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 12),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.textPrimary,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}