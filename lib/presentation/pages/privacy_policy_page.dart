import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Kebijakan Privasi - Hana\'s Bakery',
          style: AppTextStyles.display.copyWith(
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hana's Cake sangat menghargai privasi pengguna kami.",
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SpaceHeight(24),
            Text(
              '1. Pengumpulan Informasi',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceHeight(8),
            Text(
              "Kami mengumpulkan informasi pribadi yang Anda berikan saat mendaftar, seperti nama, alamat email, nomor telepon, dan lokasi pengiriman. Data ini mutlak diperlukan untuk memproses pesanan Anda.",
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SpaceHeight(24),
            Text(
              '2. Penggunaan Data',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceHeight(8),
            Text(
              "Data Anda HANYA digunakan untuk keperluan internal transaksi, pelacakan pengiriman pesanan, dan peningkatan layanan aplikasi. Kami tidak akan membagikan atau menjual data Anda kepada pihak ketiga mana pun.",
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SpaceHeight(24),
            Text(
              '3. Keamanan Transaksi',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceHeight(8),
            Text(
              "Seluruh proses pembayaran dikelola dengan enkripsi aman oleh Payment Gateway resmi (Midtrans). Kami tidak menyimpan data sensitif seperti detail kartu kredit atau PIN Anda di server kami.",
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
