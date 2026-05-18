import 'package:flutter/material.dart';
import 'package:hanas_cake/core/core.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text('Rincian Pesanan', style: AppTextStyles.h2.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryXLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Croissant Mentega...', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                      const Text('21 Apr 2026', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SpaceHeight(12),
                  Row(
                    children: [
                      Image.asset('assets/images/croissant.png', width: 70),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Rp 15.000', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                          const Text('1 menu', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Selesai'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                        child: const Text('Belum ada penilaian', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        child: const Text('Pesan lagi', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}