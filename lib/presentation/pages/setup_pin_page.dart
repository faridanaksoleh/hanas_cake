import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class SetupPinPage extends StatelessWidget {
  const SetupPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface, // Background abu-abu muda sesuai figma
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            }
          },
        ),
        title: Text(
          "PIN Hana's bakery",
          // 🔥 FIX: Disamakan dengan standar OrderPage (pakai h1)
          style: AppTextStyles.h1.copyWith(
            color: AppColors.primary, 
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Konten Tengah
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Text(
                    'TINGKATKAN KEAMANAN',
                    style: AppTextStyles.h1.copyWith( // 🔥 FIX: Diganti ke h1 agar pas besarnya
                      color: AppColors.primary,
                    ),
                  ),
                  const SpaceHeight(12),
                  Text(
                    'Agar login selanjutnya lebih mudah dan aman,\nbikin PIN yuk!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary, 
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Area Tombol Bawah
            Container(
              width: double.infinity,
              color: AppColors.white, 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol NANTI SAJA
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: TextButton(
                      onPressed: () => GoRouter.of(context).pop(), 
                      style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: Text(
                        'NANTI SAJA',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Tombol BUAT PIN
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Arahkan ke halaman pembuatan PIN sebenernya (Input Angka)
                        // GoRouter.of(context).push('/create-pin');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // Cokelat Solid
                        elevation: 0,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: Text(
                        'BUAT PIN',
                        style: AppTextStyles.body.copyWith(
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
      ),
    );
  }
}