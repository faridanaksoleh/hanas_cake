import 'package:flutter/material.dart';
import 'package:hanas_cake/core/core.dart';

class OrderFilterPage extends StatefulWidget {
  const OrderFilterPage({super.key});

  @override
  State<OrderFilterPage> createState() => _OrderFilterPageState();
}

class _OrderFilterPageState extends State<OrderFilterPage> {
  String selectedFilter = 'Semua';
  String selectedDate = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text('Filter', style: AppTextStyles.h2.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text('TAMPILKAN BERDASARKAN', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                _buildRadio('Semua', selectedFilter, (val) => setState(() => selectedFilter = val!)),
                _buildRadio('Pemesanan via Aplikasi', selectedFilter, (val) => setState(() => selectedFilter = val!)),
                _buildRadio('Pick Up', selectedFilter, (val) => setState(() => selectedFilter = val!)),
                _buildRadio('Delivery', selectedFilter, (val) => setState(() => selectedFilter = val!)),
                _buildRadio('Pemesanan di store', selectedFilter, (val) => setState(() => selectedFilter = val!)),
                const SpaceHeight(24),
                Text('URUTKAN TANGGAL', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                _buildRadio('Semua', selectedDate, (val) => setState(() => selectedDate = val!)),
                _buildRadio('Pemesanan via Aplikasi', selectedDate, (val) => setState(() => selectedDate = val!)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20), // Warna Hijau Gelap Figma
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('TERAPKAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio(String title, String groupVal, Function(String?) onChange) {
    return RadioListTile<String>(
      title: Text(title, style: AppTextStyles.body),
      value: title,
      groupValue: groupVal,
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
      onChanged: onChange,
    );
  }
}