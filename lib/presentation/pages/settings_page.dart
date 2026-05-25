import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              GoRouter.of(context).go('/home');
            }
          },
        ),
        title: Text(
          'Pengaturan',
          // 🔥 FIX: Disamakan dengan standar OrderPage (pakai h1, tanpa bold)
          style: AppTextStyles.h1.copyWith(
            color: AppColors.primary, 
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSettingsItem(
            title: "Atur PIN Hana's Bakery",
            onTap: () => GoRouter.of(context).push('/setup-pin'), 
          ),
          _buildSettingsItem(
            title: "Atur Notifikasi",
            onTap: () => GoRouter.of(context).push('/settings/notifications'), 
          ),
          _buildSettingsItem(
            title: "Ganti Bahasa",
            onTap: () => GoRouter.of(context).push('/settings/language'), 
            hideBorder: true, 
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({required String title, required VoidCallback onTap, bool hideBorder = false}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, 
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          // 🔥 FIX: Menggunakan warna border standar aplikasi
          border: hideBorder 
              ? null 
              : const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}