import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/components/custom_bottom_nav.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan diisi oleh halaman yang sedang aktif (Home, Voucher, dll)
      body: navigationShell,
      // Navbar dipasang PERMANEN di sini
      bottomNavigationBar: CustomBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          // goBranch ini yang bikin transisi antar tab mulus pakai IndexedStack
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}