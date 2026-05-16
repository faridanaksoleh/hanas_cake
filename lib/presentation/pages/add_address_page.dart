import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _namaAlamatController = TextEditingController();
  final _detailAlamatController = TextEditingController();
  final _namaPenerimaController = TextEditingController(text: 'RINA');
  final _nomorTeleponController = TextEditingController(text: '+6280000000000');

  @override
  void dispose() {
    _namaAlamatController.dispose();
    _detailAlamatController.dispose();
    _namaPenerimaController.dispose();
    _nomorTeleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            _buildSearchBar(),
            const SpaceHeight(24),
            // Detail Alamat section
            _buildSectionHeader('Detail Alamat'),
            const SpaceHeight(16),
            CustomTextField(
              label: 'Nama Alamat',
              controller: _namaAlamatController,
              hintText: 'Contoh: Rumah, Kantor',
              isOutlineBorder: true,
              labelColor: AppColors.textSecondary,
            ),
            const SpaceHeight(16),
            CustomTextField(
              label: 'Detail Alamat (opsional)',
              controller: _detailAlamatController,
              hintText: 'Contoh: Tower A, Kamar Nomo 22',
              isOutlineBorder: true,
              labelColor: AppColors.textSecondary,
            ),
            const SpaceHeight(28),
            // Divider
            const Divider(color: AppColors.border, height: 1),
            const SpaceHeight(24),
            // Detail Penerima section
            _buildSectionHeader('Detail Penerima'),
            const SpaceHeight(16),
            CustomTextField(
              label: 'Nama Penerima',
              controller: _namaPenerimaController,
              hintText: 'Nama Penerima',
              isOutlineBorder: true,
              labelColor: AppColors.textSecondary,
            ),
            const SpaceHeight(16),
            CustomTextField(
              label: 'Nomor Telepon',
              controller: _nomorTeleponController,
              hintText: 'Nomor Telepon',
              keyboardType: TextInputType.phone,
              isOutlineBorder: true,
              labelColor: AppColors.textSecondary,
            ),
            const SpaceHeight(32),
          ],
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
        'Tambah Alamat',
        style: AppTextStyles.display.copyWith(
          fontSize: 22,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // SEARCH BAR
  // ──────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 22,
          ),
          const SpaceWidth(10),
          Text(
            'Cari Lokasi',
            style: AppTextStyles.body.copyWith(
              color: AppColors.border,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // SECTION HEADER
  // ──────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // BOTTOM BUTTON
  // ──────────────────────────────────────────────────────────
  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: AppButton.primary(
        text: 'Simpan',
        onPressed: () {
          // TODO: implement save logic
          if (GoRouter.of(context).canPop()) GoRouter.of(context).pop();
        },
      ),
    );
  }
}
