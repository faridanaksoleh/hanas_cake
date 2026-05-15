import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: _buildProfileCard(context),
                    ),
                  ),
                  const SpaceHeight(16),
                  // Pengaturan section
                  _buildMenuSection(children: [
                    _buildMenuItem(title: 'Alamat Tersimpan'),
                    _buildMenuItem(title: 'Pembayaran'),
                    _buildMenuItem(title: 'Pengaturan', isLast: true),
                  ]),
                  const SpaceHeight(16),
                  // Informasi & Sosial Media section
                  _buildMenuSection(children: [
                    _buildMenuItem(title: 'Syarat dan Ketentuan'),
                    _buildMenuItem(title: 'Kebijakan Privasi'),
                    _buildMenuItem(
                      title: 'Media Sosial',
                      isLast: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/instagram.png',
                            width: 24,
                            height: 24,
                          ),
                          const SpaceWidth(12),
                          Image.asset(
                            'assets/icons/facebook.png',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SpaceHeight(16),
                  // Help Center section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildHelpCenter(),
                  ),
                  const SpaceHeight(24),
                ],
              ),
            ),
          ),
          // Logout button — full width, flush bottom
          SizedBox(
            width: double.infinity,
            child: AppButton.logout(
              text: 'Logout',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 1. PROFILE CARD
  // ─────────────────────────────────────────────────────────
  Widget _buildProfileCard(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/my-account'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primaryMid,
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.primaryLight,
                size: 32,
              ),
            ),
            const SpaceWidth(14),
            // Name + phone
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RINA',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceHeight(2),
                  Text(
                    '+62999999',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.80),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 2. MENU SECTION WRAPPER
  // ─────────────────────────────────────────────────────────
  Widget _buildMenuSection({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 3. MENU ITEM HELPER
  // ─────────────────────────────────────────────────────────
  Widget _buildMenuItem({
    required String title,
    Widget? trailing,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(12)) : BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: AppColors.border, width: 0.8),
                ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 4. HELP CENTER
  // ─────────────────────────────────────────────────────────
  Widget _buildHelpCenter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perlu Bantuan?',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SpaceHeight(10),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // WhatsApp icon
                Image.asset(
                  'assets/icons/whatsapp.png',
                  width: 24,
                  height: 24,
                ),
                const SpaceWidth(12),
                // Text info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hana's Bakery Customer Service (chat only)",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SpaceHeight(2),
                      Text(
                        '081-2222-3333',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.successText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
