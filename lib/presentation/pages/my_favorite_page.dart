import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:hanas_cake/core/core.dart';
import '../../domain/entities/product.dart';
import '../blocs/favorite/favorite_bloc.dart';
import '../blocs/favorite/favorite_event.dart';
import '../blocs/favorite/favorite_state.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage({super.key});

  @override
  State<MyFavoritePage> createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(price);
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
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is FavoriteError && state.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  ),
                  const SpaceHeight(16),
                  ElevatedButton(
                    onPressed: () => context.read<FavoriteBloc>().add(LoadFavoritesEvent()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final favorites = state is FavoriteLoaded ? state.favorites : <Product>[];

          if (favorites.isEmpty) {
            return Center(
              child: Text(
                'Belum ada produk favorit',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(height: 1, thickness: 1, color: AppColors.border),
            ),
            itemBuilder: (context, index) {
              final p = favorites[index];
              return _buildFavoriteListItem(
                product: p,
                badgeAsset: 'assets/icons/most_popular.svg',
                name: p.name,
                subtitle: p.description ?? '',
                priceString: _formatPrice(p.price),
                imagePath: p.imageUrl,
              );
            },
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // HELPER WIDGETS
  // ─────────────────────────────────────────────────────────

  Widget _buildFavoriteListItem({
    required Product product,
    required String badgeAsset,
    required String name,
    required String subtitle,
    required String priceString,
    required String imagePath,
  }) {
    final isNetworkImage = imagePath.startsWith('http');

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
                child: isNetworkImage && imagePath.isNotEmpty
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(Icons.image, color: Colors.grey),
                      )
                    : Image.asset(imagePath, fit: BoxFit.contain),
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
                  BlocBuilder<FavoriteBloc, FavoriteState>(
                    builder: (context, favState) {
                      final isFav = favState is FavoriteLoaded &&
                          favState.favorites.any((p) => p.id == product.id);
                      return GestureDetector(
                        onTap: () {
                          context.read<FavoriteBloc>().add(ToggleFavoriteEvent(product));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? AppColors.dangerText : AppColors.textSecondary,
                            size: 24,
                          ),
                        ),
                      );
                    },
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