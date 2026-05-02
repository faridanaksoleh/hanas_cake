import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 16.0),
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.icons.caretLeft,
              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              height: 20,
              width: 20,
            ),
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                GoRouter.of(context).pop();
              } else {
                GoRouter.of(context).go('/landing');
              }
            },
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Text(
            'Daftar',
            style: AppTextStyles.display.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceHeight(24),
              CustomTextField(
                label: 'Masukan Nama',
                controller: _nameController,
                hintText: 'Nama*',
                keyboardType: TextInputType.name,
                maxLength: 25,
              ),
              const SpaceHeight(16),

              CustomTextField(
                label: 'Alamat Email',
                controller: _emailController,
                hintText: 'example@gmail.comm',
                keyboardType: TextInputType.emailAddress,
              ),
              const SpaceHeight(16),

              CustomTextField(
                label: 'Password',
                controller: _passwordController,
                hintText: 'Min. 8 karakter',
                isPassword: true,
              ),
              const SpaceHeight(16),

              CustomTextField(
                label: 'Konfirmasi Password',
                controller: _confirmPasswordController,
                hintText: 'Samakan password',
                isPassword: true,
              ),
              const SpaceHeight(40),

              AppButton.primary(
                text: 'Lanjutkan',
                onPressed: () {
                  // TODO: Aksi pendaftaran
                },
              ),
              const SpaceHeight(24),
              
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, height: 1.5),
                    children: [
                      const TextSpan(text: "Dengan masuk hana's cake, kamu telah menyetujui\n"),
                      TextSpan(
                        text: 'Syarat & Ketentuan',
                        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      const TextSpan(text: ' dan '),
                      TextSpan(
                        text: 'Kebijakan Privasi',
                        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
