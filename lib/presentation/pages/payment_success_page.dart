import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import 'package:url_launcher/url_launcher.dart'; // 🔥 Wajib untuk buka WhatsApp

class PaymentSuccessPage extends StatelessWidget {
  // 🔥 BEST PRACTICE: Parameter dinamis untuk mode Delivery / Pick Up
  final bool isPickUp;
  
  const PaymentSuccessPage({super.key, this.isPickUp = false});

  // 🔥 Fungsi sakti buat langsung lompat ke WA kamu
  Future<void> _launchWhatsApp(BuildContext context) async {
    // Nomor diisi sesuai request dengan kode negara 62
    final Uri url = Uri.parse('https://wa.me/6285798203978');
    
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch WhatsApp');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal membuka WhatsApp. Pastikan aplikasi terinstal.'),
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
        child: Column(
          children: [
            // ─────────────────────────────────────────────────────────
            // 1. HEADER (ADAPTIF)
            // ─────────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              color: isPickUp ? AppColors.primary : AppColors.primaryMid, // Cokelat untuk PickUp
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                children: [
                  Image.asset(
                    isPickUp ? 'assets/images/payment_success.png' : 'assets/images/home_delivery.png', // Fallback delivery
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                  const SpaceWidth(20),
                  Expanded(
                    child: Text(
                      'Payment Success',
                      style: AppTextStyles.h1.copyWith(
                        color: isPickUp ? AppColors.white : AppColors.primary,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─────────────────────────────────────────────────────────
            // 2. INFO LOKASI (KHUSUS PICK UP)
            // ─────────────────────────────────────────────────────────
            if (isPickUp) ...[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: const BoxDecoration(color: AppColors.secondaryXLight, shape: BoxShape.circle),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/branch2.svg', 
                          width: 24, 
                          height: 24, 
                          // Murni bawaan Figma tanpa ColorFilter
                        ),
                      ),
                    ),
                    const SpaceWidth(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alamat Cabang terdekat', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                          const SpaceHeight(4),
                          RichText(
                            text: TextSpan(
                              text: '19.48 km • ',
                              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
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
            ],

            // ─────────────────────────────────────────────────────────
            // 3. KONTEN TENGAH (ADAPTIF)
            // ─────────────────────────────────────────────────────────
            Expanded(
              child: isPickUp 
                // KONTEN PICK UP (Nomor Antrian Besar)
                ? Column(
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
                  )
                // KONTEN DELIVERY (Placeholder standar)
                : Center(
                    child: Text(
                      'Pesanan sedang diproses\ndan akan segera diantar!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(color: AppColors.primary),
                    ),
                  ),
            ),

            // ─────────────────────────────────────────────────────────
            // 4. TOMBOL AKSI BAWAH
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Tombol Hubungi CS (Khusus Pick Up)
                  if (isPickUp) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _launchWhatsApp(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 🔥 FIX: Mewarnai logo cokelat menjadi PUTIH solid dengan ColorFilter
                            SvgPicture.asset(
                              'assets/icons/whatsapp_logo.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                            const SpaceWidth(8),
                            Text('Hubungi CS', style: AppTextStyles.h3.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SpaceHeight(12),
                  ],

                  // Tombol Back to Home (Berlaku untuk keduanya)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        // 🔥 MENGARAH KE HOME DAN MENGHIDUPKAN BANNER
                        context.go('/home', extra: {'hasActiveOrder': true});
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Back to Home',
                        style: AppTextStyles.h3.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
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
}