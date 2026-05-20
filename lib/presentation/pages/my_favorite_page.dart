import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage({super.key});

  @override
  State<MyFavoritePage> createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  // Semua item di halaman ini default-nya sudah di-favoritkan
  Set<String> favoriteItems = {'fav_1', 'fav_2', 'fav_3'};

  void toggleFavorite(String id) {
    setState(() {
      if (favoriteItems.contains(id)) {
        favoriteItems.remove(id);
      } else {
        favoriteItems.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih sesuai Figma
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              GoRouter.of(context).go('/delivery');
            }
          },
        ),
        title: Text(
          'My Favorite',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _buildFavoriteListItem(
            id: 'fav_1',
            badgeAsset: 'assets/icons/most_popular.svg',
            name: 'Croissant mentega',
            subtitle: 'Croissant mentega premium dengan lapisan...',
            priceString: 'Rp15.000',
            imagePath: 'assets/images/croissant_mentega.png',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, thickness: 1, color: AppColors.border),
          ),
          _buildFavoriteListItem(
            id: 'fav_2',
            badgeAsset: 'assets/icons/most_popular.svg',
            name: 'Croissant mentega',
            subtitle: 'Croissant mentega premium dengan lapisan...',
            priceString: 'Rp15.000',
            imagePath: 'assets/images/croissant_mentega.png',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, thickness: 1, color: AppColors.border),
          ),
          _buildFavoriteListItem(
            id: 'fav_3',
            badgeAsset: 'assets/icons/most_popular.svg',
            name: 'Croissant mentega',
            subtitle: 'Croissant mentega premium dengan lapisan...',
            priceString: 'Rp15.000',
            imagePath: 'assets/images/croissant_mentega.png',
          ),
          const SizedBox(height: 32), // Jarak aman bawah
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // HELPER WIDGETS
  // ─────────────────────────────────────────────────────────

  Widget _buildFavoriteListItem({
    required String id,
    required String badgeAsset,
    required String name,
    required String subtitle,
    required String priceString,
    required String imagePath,
  }) {
    final isFav = favoriteItems.contains(id);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 100,
                height: 100,
                color: AppColors.primaryXLight,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 6,
              left: 6,
              child: SvgPicture.asset(badgeAsset, height: 20),
            ),
          ],
        ),
        const SpaceWidth(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SpaceHeight(4),
                        Text(
                          subtitle,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.3, // Menyesuaikan line-height Figma
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => toggleFavorite(id),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SpaceHeight(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    priceString,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const ShapeDecoration(
                      color: AppColors.primary,
                      shape: OvalBorder(),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}