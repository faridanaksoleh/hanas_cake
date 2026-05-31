import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when the page loads
    context.read<AuthBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.go('/landing');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.surface,
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
                  const SpaceHeight(14),
                  // Pengaturan section
                  _buildMenuSection(children: [
                    _buildMenuItem(
                      title: 'Alamat Tersimpan',
                      onTap: () => GoRouter.of(context).push('/saved-address'),
                    ),
                    _buildMenuItem(
                      title: 'Pembayaran',
                      onTap: () => GoRouter.of(context).push('/payment-method'),
                    ),
                    _buildMenuItem(
                      title: 'Pengaturan', 
                      isLast: true,
                      onTap: () => GoRouter.of(context).push('/settings'),
                    ),
                  ]),
                  const SpaceHeight(14),
                  // Informasi & Sosial Media section
                  _buildMenuSection(children: [
                    _buildMenuItem(
                      title: 'Syarat dan Ketentuan',
                      onTap: () => GoRouter.of(context).push('/terms'),
                    ),
                    _buildMenuItem(
                      title: 'Kebijakan Privasi',
                      onTap: () => GoRouter.of(context).push('/privacy'),
                    ),
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
                  const SpaceHeight(14),
                  // Help Center section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildHelpCenter(),
                  ),
                ],
              ),
            ),
          ),
          // Logout button — full width, flush bottom
          SizedBox(
            width: double.infinity,
            child: AppButton.logout(
              text: 'Logout',
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ),
        ],
      ),
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
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            String name = 'Pelanggan';
            String phone = '-';
            
            if (state is AuthLoading) {
              name = 'Memuat...';
              phone = 'Memuat...';
            } else if (state is ProfileLoaded) {
              name = state.user.name;
              phone = state.user.phone ?? '-';
            } else if (state is ProfileUpdateSuccess) {
              name = state.user.name;
              phone = state.user.phone ?? '-';
            } else if (state is AuthSuccess) {
              name = state.user.name;
            }

            return Row(
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
                        name,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SpaceHeight(2),
                      Text(
                        phone,
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
            );
          },
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(12)) : BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                SvgPicture.asset(
                  'assets/icons/whatsapp1.svg',
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
