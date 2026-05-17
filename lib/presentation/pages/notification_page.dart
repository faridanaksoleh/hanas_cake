import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // 🔥 Ubah jadi true kalau mau lihat tampilan "No message (s) to show"
  bool isEmpty = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, 
        title: Text(
          'Kotak Masuk',
          style: AppTextStyles.display.copyWith(
            fontSize: 22,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // 🔥 FIX: Tombol X anti-merah dengan GoRouter.of(context)
          IconButton(
            icon: const Icon(
              Icons.close,
              color: AppColors.textSecondary,
              size: 24,
            ),
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                GoRouter.of(context).pop();
              } else {
                GoRouter.of(context).push('/home'); // Fallback aman
              }
            },
          ),
          const SpaceWidth(8),
        ],
      ),
      body: isEmpty ? _buildEmptyState() : _buildFilledState(),
    );
  }

  // ─────────────────────────────────────────────────────────
  // EMPTY STATE
  // ─────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No message (s) to show',
        style: AppTextStyles.body.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // FILLED STATE (LIST NOTIFIKASI)
  // ─────────────────────────────────────────────────────────
  Widget _buildFilledState() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: 2, 
      separatorBuilder: (context, index) => const SpaceHeight(12),
      itemBuilder: (context, index) {
        return _buildNotificationCard();
      },
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryXLight, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 1), 
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teks Kiri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pesanan Telah Tiba di Tujuan',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceHeight(6),
                Text(
                  'Pastikan pesananmu sudah sesuai.\nJika menemukan masalah beritahu\nkami secepatnya, ya',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary, 
                    height: 1.4,
                  ),
                ),
                const SpaceHeight(12),
                // Waktu & Status
                Text(
                  '21-04-2026   19:04   Riwayat Status',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SpaceWidth(12),
          // Gambar Kanan Montok Pas
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/croissant.png', 
              width: 96, 
              height: 96,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}