import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final _usernameController = TextEditingController(text: 'RINA');
  final _emailController = TextEditingController();
  final _tglLahirController = TextEditingController();
  final _jenisKelaminController = TextEditingController();
  final _teleponController = TextEditingController(text: '+62 1111111111');

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _tglLahirController.dispose();
    _jenisKelaminController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // BUILD
  // ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomButtons(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SpaceHeight(20),
            _buildProfilePicture(),
            const SpaceHeight(32),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // 1. APP BAR
  // ──────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 64,
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
        'Akun Saya',
        style: AppTextStyles.display.copyWith(
          fontSize: 22,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // 2. PROFILE PICTURE + BADGE
  // ──────────────────────────────────────────────────────────
  Widget _buildProfilePicture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Member badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryMid,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Member sejak : 16 April 2026',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SpaceHeight(16),
        // Avatar with edit button
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: AppColors.primaryMid,
              child: const Icon(
                Icons.person_rounded,
                size: 56,
                color: AppColors.primaryLight,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primaryMid,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  size: 15,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────
  // 3. FORM FIELDS
  // ──────────────────────────────────────────────────────────
  Widget _buildForm() {
    return Column(
      children: [
        CustomTextField(
          label: 'Username',
          controller: _usernameController,
          hintText: 'Username',
          labelColor: AppColors.textSecondary,
          suffixWidget: _editIcon(),
        ),
        const SpaceHeight(20),
        CustomTextField(
          label: 'Email',
          controller: _emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          labelColor: AppColors.textSecondary,
          suffixWidget: _editIcon(),
        ),
        const SpaceHeight(20),
        CustomTextField(
          label: 'Tanggal Lahir',
          controller: _tglLahirController,
          hintText: 'Tanggal Lahir',
          labelColor: AppColors.textSecondary,
          suffixWidget: _editIcon(),
        ),
        const SpaceHeight(20),
        CustomTextField(
          label: 'Jenis Kelamin',
          controller: _jenisKelaminController,
          hintText: 'Jenis Kelamin',
          labelColor: AppColors.textSecondary,
          suffixWidget: _editIcon(),
        ),
        const SpaceHeight(20),
        CustomTextField(
          label: 'Nomor Telepon',
          controller: _teleponController,
          hintText: 'Nomor Telepon',
          keyboardType: TextInputType.phone,
          labelColor: AppColors.textSecondary,
          suffixWidget: _editIcon(),
        ),
      ],
    );
  }

  /// Pensil edit suffix — lingkaran kecil coklat muda
  Widget _editIcon() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.primaryMid,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.edit,
        size: 14,
        color: AppColors.primary,
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // 4. BOTTOM BUTTONS
  // ──────────────────────────────────────────────────────────
  Widget _buildBottomButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hapus Akun
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            height: 60,
            color: AppColors.dangerBg,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.dangerText,
                  size: 20,
                ),
                const SpaceWidth(8),
                Text(
                  'HAPUS AKUN',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.dangerText,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Simpan — hijau solid, radius 0
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            height: 56,
            color: AppColors.successText,
            alignment: Alignment.center,
            child: Text(
              'Simpan',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
