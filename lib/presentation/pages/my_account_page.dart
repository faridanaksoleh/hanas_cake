import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _tglLahirController = TextEditingController();
  final _jenisKelaminController = TextEditingController();
  final _teleponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      _usernameController.text = authState.user.name;
      _emailController.text = authState.user.email;
      _teleponController.text = authState.user.phone ?? '';
    } else if (authState is ProfileLoaded) {
      _usernameController.text = authState.user.name;
      _emailController.text = authState.user.email;
      _teleponController.text = authState.user.phone ?? '';
    }
    context.read<AuthBloc>().add(GetProfileEvent());
  }

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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui')),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is ProfileLoaded) {
          if (_usernameController.text.isEmpty)
            _usernameController.text = state.user.name;
          if (_emailController.text.isEmpty)
            _emailController.text = state.user.email;
          if (_teleponController.text.isEmpty)
            _teleponController.text = state.user.phone ?? '';
        } else if (state is ProfileUpdateSuccess) {
          if (_usernameController.text.isEmpty)
            _usernameController.text = state.user.name;
          if (_emailController.text.isEmpty)
            _emailController.text = state.user.email;
          if (_teleponController.text.isEmpty)
            _teleponController.text = state.user.phone ?? '';
        } else if (state is AuthSuccess) {
          if (_usernameController.text.isEmpty)
            _usernameController.text = state.user.name;
          if (_emailController.text.isEmpty)
            _emailController.text = state.user.email;
          if (_teleponController.text.isEmpty)
            _teleponController.text = state.user.phone ?? '';
        }
      },
      builder: (context, state) {
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
      },
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
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
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
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Fitur ubah foto profil akan hadir di versi 2.0!',
                ),
              ),
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.primaryMid,
                backgroundImage: const AssetImage('assets/images/pp.png'),
              ),
              Positioned(
                bottom: -10,
                left: 0,
                right: 0,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/pencil.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
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

  /// Pensil edit suffix
  Widget _editIcon() {
    return Container(
      width: 24,
      alignment: Alignment.center,
      child: SvgPicture.asset('assets/icons/pencil.svg', width: 30, height: 30),
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
          onTap: () => GoRouter.of(context).push('/delete-account'),
          child: Container(
            width: double.infinity,
            height: 60,
            color: AppColors.dangerBg,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/trash_outline.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.dangerText,
                    BlendMode.srcIn,
                  ),
                  width: 20,
                  height: 20,
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
          onTap: () {
            context.read<AuthBloc>().add(
              UpdateProfileEvent(
                name: _usernameController.text,
                email: _emailController.text,
                phone: _teleponController.text,
              ),
            );
          },
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
