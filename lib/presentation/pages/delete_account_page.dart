import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/auth/auth_event.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  String? selectedReason;
  final _alasanController = TextEditingController();

  final List<String> _reasons = [
    'Saya ingin memulai akun dari awal',
    'Akun saya sering error',
    'Privasi akun kurang terjaga',
    'Lainnya',
  ];

  @override
  void dispose() {
    _alasanController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // BUILD
  // ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permintaan hapus akun sedang diproses oleh admin.')),
          );
          context.go('/landing');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomButtons(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceHeight(8),
            // Header text
            Text(
              'ALASAN HAPUS AKUN',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            const SpaceHeight(8),
            Text(
              'Sampaikan alasanmu agar kami bisa meningkatkan layanan yang lebih baik lagi',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SpaceHeight(24),
            // Reason options
            ...(_reasons.map((reason) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildReasonOption(reason),
            ))),
            // Conditional "Lainnya" input
            if (selectedReason == 'Lainnya') ...[
              const SpaceHeight(12),
              Text(
                'ALASAN LAINNYA',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const SpaceHeight(12),
              CustomTextField(
                label: 'Alasan kamu*',
                controller: _alasanController,
                hintText: 'Tulis alasan kamu',
                labelColor: AppColors.textSecondary,
                suffixWidget: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryMid,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SpaceHeight(6),
              Text(
                'Pastikan alasan kamu berjumlah minimal 3 karakter',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // APP BAR
  // ──────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
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
        'Hapus Akun Saya',
        style: AppTextStyles.display.copyWith(
          fontSize: 22,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // REASON OPTION
  // ──────────────────────────────────────────────────────────
  Widget _buildReasonOption(String title) {
    final isSelected = selectedReason == title;
    return GestureDetector(
      onTap: () => setState(() => selectedReason = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio circle
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.secondary : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SpaceWidth(14),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // BOTTOM BUTTONS
  // ──────────────────────────────────────────────────────────
  Widget _buildBottomButtons() {
    final hasSelection = selectedReason != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // "TIDAK JADI" text button
        GestureDetector(
          onTap: () {
            if (GoRouter.of(context).canPop()) GoRouter.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              'TIDAK JADI',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        // "HAPUS AKUN" button — grey when no selection, red when selected
        GestureDetector(
          onTap: hasSelection ? () {
            context.read<AuthBloc>().add(DeleteAccountEvent());
          } : null,
          child: Container(
            width: double.infinity,
            height: 60,
            color: hasSelection ? AppColors.dangerText : AppColors.border,
            alignment: Alignment.center,
            child: Text(
              'HAPUS AKUN',
              style: AppTextStyles.h3.copyWith(
                color: hasSelection ? AppColors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
