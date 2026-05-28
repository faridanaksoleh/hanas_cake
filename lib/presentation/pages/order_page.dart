import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // 🔥 Ubah jadi true untuk tes tampilan "Belum Ada Riwayat Pesanan"
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primary,
            size: 20,
          ),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              GoRouter.of(context).go('/home');
            }
          },
        ),
        title: Text(
          'Riwayat Pesanan',
          style: AppTextStyles.h1.copyWith(color: AppColors.primary),
        ),
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push('/order/filter'),
            icon: SvgPicture.asset(
              'assets/icons/sliders_outline.svg',
              width: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SpaceWidth(8),
        ],
      ),
      body: isEmpty ? _buildEmptyState() : _buildOrderList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Belum Ada Riwayat Pesanan',
        style: AppTextStyles.body.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    // 🔥 DATA DUMMY UNTUK TES UI BERDASARKAN FIGMA
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 3,
      separatorBuilder: (context, index) => const SpaceHeight(16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildOrderCard(status: 'Sedang disiapkan', isPickUp: false);
        } else if (index == 1) {
          return _buildOrderCard(status: 'Selesai', isPickUp: true);
        } else {
          return _buildOrderCard(status: 'Selesai', isPickUp: false);
        }
      },
    );
  }

  // 🔥 FUNGSI BUILDER KARTU DINAMIS
  Widget _buildOrderCard({required String status, required bool isPickUp}) {
    return GestureDetector(
      // 🔥 FIX: Arahkan ke Detail Pesanan dengan membawa state yang benar
      onTap: () => GoRouter.of(
        context,
      ).push('/order/detail', extra: {'isPickUp': isPickUp}),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
            bottom: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Croissant Mentega...',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SpaceWidth(8),
                    Text(
                      '21 Apr 2026',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SpaceHeight(12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/croissant.png',
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rp 15.000',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SpaceHeight(2),
                    Text(
                      '1 menu',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SpaceHeight(12),
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            const SpaceHeight(12),

            // 🔥 BOTTOM ROW (STATUS, METODE, TOMBOL)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Pesanan (Sedang disiapkan / Selesai)
                Text(
                  status,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                // Indikator Metode & Tombol
                Row(
                  children: [
                    // 🔥 ICON & TEKS ADAPTIF (Moped vs Tote)
                    SvgPicture.asset(
                      isPickUp
                          ? 'assets/icons/tote_simple.svg'
                          : 'assets/icons/moped.svg',
                      width: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SpaceWidth(4),
                    Text(
                      isPickUp ? 'Pick Up' : 'Delivery',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceWidth(12),

                    // Tombol Pesan Lagi
                    ElevatedButton(
                      onPressed: () {
                        // Arahkan ke Checkout dengan metode yang sama
                        GoRouter.of(
                          context,
                        ).push('/checkout', extra: {'isPickUp': isPickUp});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 36),
                        elevation: 0,
                      ),
                      child: Text(
                        'Pesan lagi',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
