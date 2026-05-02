import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go('/home');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
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
            'Masuk',
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
                label: 'Alamat email',
                controller: _emailController,
                hintText: 'Alamat email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SpaceHeight(16),

              CustomTextField(
                label: 'Password',
                controller: _passwordController,
                hintText: 'Masukkan password',
                isPassword: true,
              ),
              const SpaceHeight(40),

              (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty)
                  ? AppButton.primary(
                      text: 'Lanjutkan',
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          LoginEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                    )
                  : AppButton.disabled(text: 'Lanjutkan'),
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
      ),
    );
  }
}
