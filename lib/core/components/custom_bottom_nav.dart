import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hanas_cake/core/core.dart'; 

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tabs = [
      {'icon': 'assets/icons/home.svg', 'label': 'Home'},
      {'icon': 'assets/icons/order.svg', 'label': 'Order'},
      {'icon': 'assets/icons/profile.svg', 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryMid, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 48, // Kunci tinggi navbar agar stabil seimbang
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Membagi rata lebar grid menjadi 4 bagian presisi sesuai figma
              final tabWidth = constraints.maxWidth / tabs.length;

              return Stack(
                children: [
                  // ──────────────────────────────────────────────────
                  // 1. LAPISAN BELAKANG: BACKGROUND SLIDING PILL
                  // ──────────────────────────────────────────────────
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    left: currentIndex * tabWidth, 
                    width: tabWidth,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      // 🔥 FIX DEWA: OverflowBox mengizinkan pill cokelat melebar melebihi jatah grid tanpa memicu error
                      child: OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // Row dummy di dalam pill untuk mendeteksi panjang teks otomatis
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 24, height: 24), // Ukuran dummy ikon
                              const SizedBox(width: 6),
                              Text(
                                tabs[currentIndex]['label']!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.transparent, // Dibuat transparan karena hanya cetakan lebar
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ──────────────────────────────────────────────────
                  // 2. LAPISAN DEPAN: ICONS & LABELS TEXT
                  // ──────────────────────────────────────────────────
                  Row(
                    children: List.generate(tabs.length, (index) {
                      final isActive = currentIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTap(index),
                          child: Center(
                            // 🔥 FIX DEWA: Foreground juga dibungkus OverflowBox agar teks panjang leluasa mengembang
                            child: OverflowBox(
                              maxWidth: double.infinity,
                              maxHeight: double.infinity,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Ikon SVG dinamis warna
                                    SvgPicture.asset(
                                      tabs[index]['icon']!,
                                      width: 24,
                                      height: 24,
                                      colorFilter: ColorFilter.mode(
                                        isActive ? AppColors.white : AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    // Animasi pelebaran teks saat aktif
                                    AnimatedSize(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOutCubic,
                                      child: SizedBox(
                                        width: isActive ? null : 0, 
                                        child: ClipRect(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (isActive) const SizedBox(width: 6),
                                              Text(
                                                tabs[index]['label']!,
                                                style: AppTextStyles.bodySmall.copyWith(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}