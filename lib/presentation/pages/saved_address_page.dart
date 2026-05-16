import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class SavedAddressPage extends StatefulWidget {
  const SavedAddressPage({super.key});

  @override
  State<SavedAddressPage> createState() => _SavedAddressPageState();
}

class _SavedAddressPageState extends State<SavedAddressPage> {
  // Toggle this to switch between empty/filled UI
  bool isEmpty = false;

  // Mock address data
  final List<Map<String, String>> _addresses = [
    {
      'name': 'Kantor',
      'address':
          'jl. Gatot Subroto No. 10, Rt.4 /RW.4, Mampang Prpt., Kec. mampang Prpt., Kota Jakarta Selatan, DAerah Khusus ibukota Jakarta 12790,',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomButton(),
      body: isEmpty ? _buildEmptyState() : _buildAddressList(),
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
        'Alamat Tersimpan',
        style: AppTextStyles.display.copyWith(
          fontSize: 22,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // EMPTY STATE
  // ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.images.address.path,
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            const SpaceHeight(24),
            Text(
              'Belum ada alamat yang tersimpan',
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceHeight(8),
            Text(
              'Mau lebih praktis dan cepat? simpan alamatmu yuk!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // ADDRESS LIST
  // ──────────────────────────────────────────────────────────
  Widget _buildAddressList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: _addresses.length,
      separatorBuilder: (_, __) => const SpaceHeight(12),
      itemBuilder: (context, index) {
        final addr = _addresses[index];
        return _buildAddressCard(
          name: addr['name']!,
          address: addr['address']!,
        );
      },
    );
  }

  Widget _buildAddressCard({required String name, required String address}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: name + Ubah + delete
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Ubah',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SpaceWidth(12),
              GestureDetector(
                onTap: () => _showDeleteDialog(context, name, address),
                child: SvgPicture.asset(
                  Assets.icons.trashOutline,
                  colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          const SpaceHeight(10),
          // Address text
          Text(
            address,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // DELETE BOTTOM SHEET
  // ──────────────────────────────────────────────────────────
  void _showDeleteDialog(BuildContext context, String name, String address) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Text(
                'Yakin Hapus Alamat Ini?',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceHeight(16),
              // Address summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SpaceHeight(6),
                    Text(
                      address,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceHeight(20),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: 'Kembali',
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                  const SpaceWidth(12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        setState(() {
                          isEmpty = true;
                        });
                      },
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.dangerText,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Hapus',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  // ──────────────────────────────────────────────────────────
  // BOTTOM BUTTON
  // ──────────────────────────────────────────────────────────
  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: AppButton.primary(
        text: 'Tambah Alamat',
        onPressed: () => GoRouter.of(context).push('/add-address'),
      ),
    );
  }
}
