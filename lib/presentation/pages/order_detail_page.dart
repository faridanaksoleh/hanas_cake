import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface, // Background body tetap surface
      appBar: AppBar(
        // 🔥 FIX: Background AppBar diubah jadi putih solid
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
          'Rincian Pesanan',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.primary, 
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push('/order/filter'),
            icon: SvgPicture.asset(
              'assets/icons/sliders_outline.svg',
              width: 24,
              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            ),
          ),
          const SpaceWidth(8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Croissant Mentega...', 
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.textSecondary),
                          const SpaceWidth(8),
                          Text(
                            '21 Apr 2026', 
                            style: AppTextStyles.micro.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SpaceHeight(12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2.28), 
                        child: Image.asset(
                          'assets/images/croissant.png', 
                          width: 65, 
                          height: 65, 
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rp 15.000', 
                            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SpaceHeight(2),
                          Text(
                            '1 menu', 
                            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SpaceHeight(12),
                  const Divider(height: 1, thickness: 1, color: AppColors.border), 
                  const SpaceHeight(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selesai', 
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Belum ada penilaian', 
                              style: AppTextStyles.micro.copyWith(color: AppColors.border),
                            ),
                          ),
                          const SpaceWidth(12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: const Size(0, 36),
                              elevation: 0,
                            ),
                            child: Text(
                              'Pesan lagi', 
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.white, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}