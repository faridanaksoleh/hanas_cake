import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // Dummy State untuk toggle
  bool promoNotif = true;
  bool orderNotif = true;
  bool appInfoNotif = false;

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
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(
          'Atur Notifikasi',
          style: AppTextStyles.h1.copyWith(color: AppColors.primary),
        ),
      ),
      body: Column(
        children: [
          _buildToggleItem(
            title: 'Promo & Diskon',
            subtitle: 'Dapatkan info promo dan penawaran menarik.',
            value: promoNotif,
            onChanged: (val) => setState(() => promoNotif = val),
          ),
          _buildToggleItem(
            title: 'Status Pesanan',
            subtitle: 'Pembaruan status dari pesanan yang sedang berjalan.',
            value: orderNotif,
            onChanged: (val) => setState(() => orderNotif = val),
          ),
          _buildToggleItem(
            title: 'Info Aplikasi',
            subtitle: 'Pemberitahuan terkait update dan fitur baru.',
            value: appInfoNotif,
            onChanged: (val) => setState(() => appInfoNotif = val),
            hideBorder: true,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool hideBorder = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: hideBorder 
            ? null 
            : const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                const SpaceHeight(4),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SpaceWidth(16),
          CupertinoSwitch(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}