import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class OrderFilterPage extends StatefulWidget {
  const OrderFilterPage({super.key});

  @override
  State<OrderFilterPage> createState() => _OrderFilterPageState();
}

class _OrderFilterPageState extends State<OrderFilterPage> {
  // 🔥 KEMBALI KE SINGLE SELECT (Hanya bisa pilih 1 per kategori)
  String selectedFilter = 'Semua';
  String selectedDate = 'Terbaru';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, 
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              GoRouter.of(context).go('/order');
            }
          },
        ),
        title: Text(
          'Filter',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.normal, 
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SpaceHeight(24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'TAMPILKAN BERDASARKAN',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SpaceHeight(8),
                _buildRadio('Semua', selectedFilter, (val) => setState(() => selectedFilter = val!)),
                _buildDivider(),
                _buildRadio('Pemesanan via Aplikasi', selectedFilter, (val) => setState(() => selectedFilter = val!)),
                _buildDivider(),
                _buildRadio('Pick Up', selectedFilter, (val) => setState(() => selectedFilter = val!)),
                _buildDivider(),
                _buildRadio('Delivery', selectedFilter, (val) => setState(() => selectedFilter = val!)),
                _buildDivider(),
                _buildRadio('Pemesanan di store', selectedFilter, (val) => setState(() => selectedFilter = val!)),
                
                const SpaceHeight(16),
                Container(height: 8, color: AppColors.surface), 
                const SpaceHeight(24),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'URUTKAN TANGGAL',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SpaceHeight(8),
                _buildRadio('Terbaru', selectedDate, (val) => setState(() => selectedDate = val!)),
                _buildDivider(),
                _buildRadio('Terlama', selectedDate, (val) => setState(() => selectedDate = val!)),
                
                const SpaceHeight(40), 
              ],
            ),
          ),
          
          SizedBox(
            width: double.infinity,
            height: 56, 
            child: ElevatedButton(
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop({'tipe': selectedFilter, 'urutan': selectedDate});
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successText, 
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, 
                ),
                elevation: 0,
              ),
              child: const Text(
                'TERAPKAN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // HELPER WIDGETS
  // ─────────────────────────────────────────────────────────
  
  // 🔥 KEMBALI MENGGUNAKAN RADIOLISTTILE ASLI
  Widget _buildRadio(String title, String groupVal, Function(String?) onChange) {
    return RadioListTile<String>(
      title: Text(
        title, 
        style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
      ),
      value: title,
      groupValue: groupVal,
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      controlAffinity: ListTileControlAffinity.leading, 
      onChanged: onChange,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border,
      indent: 64, 
      endIndent: 24,
    );
  }
}