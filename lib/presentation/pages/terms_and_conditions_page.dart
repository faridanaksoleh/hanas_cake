import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.icons.caretLeft,
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
          'Syarat-syarat dan Ketentuan',
          style: AppTextStyles.display.copyWith(
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // 🔥 Ini margin leganya biar nggak nempel ke layar
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selamat datang di aplikasi Hana's Cake.",
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SpaceHeight(24),
            Text(
              '1. Pemesanan & Pembayaran',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceHeight(8),
            Text(
              "Semua pesanan yang telah dikonfirmasi dan dibayar melalui sistem (Midtrans) tidak dapat dibatalkan atau diubah. Pastikan rincian pesanan Anda sudah benar sebelum melakukan konfirmasi.",
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SpaceHeight(24),
            Text(
              '2. Pengiriman & Pengambilan',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceHeight(8),
            Text(
              "Untuk metode Delivery, pesanan akan dikirimkan sesuai dengan alamat yang tertera. Untuk metode Pick Up, harap tunjukkan ID Pesanan Anda kepada staf di toko.",
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SpaceHeight(24),
            Text(
              '3. Ketersediaan Produk',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceHeight(8),
            Text(
              "Menu yang tampil bergantung pada ketersediaan stok harian. Jika terjadi kehabisan stok setelah pembayaran berhasil, Customer Service kami akan menghubungi Anda untuk proses pengembalian dana (refund).",
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}