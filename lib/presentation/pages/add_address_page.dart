import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanas_cake/core/core.dart';

import '../../domain/entities/address.dart';
import '../blocs/address/address_bloc.dart';
import '../blocs/address/address_event.dart';
import '../blocs/address/address_state.dart';

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
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressActionSuccess) {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            }
          } else if (state is AddressFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
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
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            }
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
  // SECTION HEADER - DIPERBESAR UKURAN FONT NYA
  // ──────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 18, // Menambahkan fontSize 18 untuk memperbesar teks
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // BOTTOM BUTTON
  // ──────────────────────────────────────────────────────────
  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          return AppButton.primary(
            text: state is AddressLoading ? 'Menyimpan...' : 'Simpan',
            onPressed: state is AddressLoading
                ? () {} // Disable when loading
                : () {
                    // Validasi input dasar
                    if (_namaAlamatController.text.isEmpty || _namaPenerimaController.text.isEmpty || _nomorTeleponController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon lengkapi data alamat yang wajib diisi'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Debugging input
                    print('DEBUG FORM -> Label: ${_namaAlamatController.text}, Alamat: ${_detailAlamatController.text}, Penerima: ${_namaPenerimaController.text}, HP: ${_nomorTeleponController.text}');

                    final newAddress = Address(
                      id: 0, // id is auto-generated by the server
                      name: _namaAlamatController.text,
                      fullAddress: _detailAlamatController.text.isNotEmpty 
                          ? _detailAlamatController.text 
                          : _namaAlamatController.text,
                      receiverName: _namaPenerimaController.text,
                      phoneNumber: _nomorTeleponController.text,
                      isPrimary: false,
                    );
                    context.read<AddressBloc>().add(AddAddressEvent(newAddress));
                  },
          );
        },
      ),
    );
  }
}