import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    // List menu navbar beserta path routing-nya
    final List<Map<String, dynamic>> tabs = [
      {
        'icon': 'assets/icons/home.svg',
        'label': 'Home',
        'route': '/home',
      },
      {
        'icon': 'assets/icons/voucher.svg', 
        'label': 'Voucher',
        'route': '/voucher', 
      },
      {
        'icon': 'assets/icons/order.svg', 
        'label': 'Order',
        'route': '/order', 
      },
      {
        'icon': 'assets/icons/profile.svg', 
        'label': 'Profile',
        'route': '/profile', 
      },
    ];

    return Container(
      // 🔥 FIX 1: Background pakai primaryMid sesuai request
      decoration: const BoxDecoration(
        color: AppColors.primaryMid, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(tabs.length, (index) {
            final isActive = currentIndex == index;

            return GestureDetector(
              onTap: () {
                // Jangan pindah kalau tab sudah aktif
                if (!isActive) {
                  context.go(tabs[index]['route']); 
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300), // Kecepatan animasi
                curve: Curves.easeInOutCubic, // Gaya animasi biar smooth
                padding: EdgeInsets.symmetric(
                  horizontal: isActive ? 16.0 : 12.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  // 🔥 FIX 2: Corner radius dibuat 12, tidak bulat 100 lagi!
                  borderRadius: BorderRadius.circular(12), 
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Manipulasi Warna SVG
                    SvgPicture.asset(
                      tabs[index]['icon'],
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        isActive ? AppColors.white : AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    // Teks Muncul / Hilang
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      child: SizedBox(
                        width: isActive ? null : 0, 
                        child: Padding(
                          padding: EdgeInsets.only(left: isActive ? 8.0 : 0.0),
                          child: Text(
                            tabs[index]['label'],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}