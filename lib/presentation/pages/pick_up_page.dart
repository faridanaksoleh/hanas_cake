import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class PickUpPage extends StatefulWidget {
  const PickUpPage({super.key});

  @override
  State<PickUpPage> createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> {
  String _selectedChip = 'Semua';

  final List<String> _categories = ['Semua', 'Roti & Donat', 'Pastri', 'Kue', 'Minuman'];

  // ────────────────────────────────────────────────────────
  // DATA MOCK
  // ────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _mustTryItems = [
    {'name': 'Croissant mentega', 'category': 'Pastri', 'price': 'Rp15.000', 'badge': 'Best Seller', 'badgeColor': 0xFFDCFCE7, 'badgeTextColor': 0xFF166534},
    {'name': 'Croissant mentega', 'category': 'Pastri', 'price': 'Rp15.000', 'badge': 'Top Ordered', 'badgeColor': 0xFFEEF2FF, 'badgeTextColor': 0xFF3454D1},
    {'name': 'Croissant mentega', 'category': 'Pastri', 'price': 'Rp15.000', 'badge': 'Most Popular', 'badgeColor': 0xFFFEF3C7, 'badgeTextColor': 0xFF92400E},
    {'name': 'Croissant mentega', 'category': 'Pastri', 'price': 'Rp15.000', 'badge': 'Most Popular', 'badgeColor': 0xFFFEF3C7, 'badgeTextColor': 0xFF92400E},
    {'name': 'Croissant mentega', 'category': 'Pastri', 'price': 'Rp15.000', 'badge': 'Most Popular', 'badgeColor': 0xFFFEF3C7, 'badgeTextColor': 0xFF92400E},
  ];

  final List<Map<String, String>> _allItems = [
    {'name': 'Croissant mentega', 'category': 'Pastri', 'price': 'Rp15.000', 'desc': 'Croissant mentega premium dengan lapisan...'},
    {'name': 'Croissant mentega', 'category': 'Pastri', 'price': 'Rp15.000', 'desc': 'Croissant mentega premium dengan lapisan...'},
    {'name': 'Croissant mentega', 'category': 'Pastri', 'price': 'Rp15.000', 'desc': 'Croissant mentega premium dengan lapisan...'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildAddress(),
            const SpaceHeight(20),
            _buildMyFavorite(),
            const SpaceHeight(20),
            _buildCategoryChips(),
            const SpaceHeight(20),
            _buildMustTry(),
            const SpaceHeight(20),
            _buildAllItems(),
            const SpaceHeight(32),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  // 1. HEADER
  // ────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.primaryLight,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: back + search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (GoRouter.of(context).canPop()) {
                        GoRouter.of(context).pop();
                      }
                    },
                    child: SvgPicture.asset(
                      Assets.icons.caretLeft,
                      colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  SvgPicture.asset(
                    Assets.icons.magnifyingglassOutline,
                    colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
            // Content row: image left, text+button right
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Character image
                  Image.asset(
                    Assets.images.youngManWalkingWithCoffee.path,
                    height: 130,
                    fit: BoxFit.contain,
                  ),
                  const SpaceWidth(8),
                  // Title + description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pick Up',
                          style: AppTextStyles.display.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          'Ambil di Store tanpa antri',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceWidth(8),
                  // Ubah button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Ubah',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  // 2. ADDRESS
  // ────────────────────────────────────────────────────────
  Widget _buildAddress() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Store icon in circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.secondaryXLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: AppColors.secondary,
              size: 22,
            ),
          ),
          const SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alamat Cabang terdekat',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '19.48 km • ',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                    Text(
                      'Terdekat',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  // 3. MY FAVORITE
  // ────────────────────────────────────────────────────────
  Widget _buildMyFavorite() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Favorite',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Lihat Semua',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SpaceHeight(12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            separatorBuilder: (_, __) => const SpaceWidth(12),
            itemBuilder: (context, index) => _buildFavoriteCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCard() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Image placeholder
          Container(
            width: 88,
            decoration: const BoxDecoration(
              color: AppColors.primaryMid,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
            ),
          ),
          const SpaceWidth(12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Croissant mentega',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Croissant mentega...',
                              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SpaceWidth(8),
                      SvgPicture.asset(
                        Assets.icons.heartFilled,
                        colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp15.000',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: AppColors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SpaceWidth(12),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  // 4. CATEGORY CHIPS
  // ────────────────────────────────────────────────────────
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Star icon chip (active/featured)
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.star_rounded, color: AppColors.white, size: 22),
            ),
          ),
          const SpaceWidth(8),
          ..._categories.map((cat) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildChip(cat),
          )),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    final isSelected = _selectedChip == label;
    final isRoti = label == 'Roti & Donat';

    return GestureDetector(
      onTap: () => setState(() => _selectedChip = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isRoti
              ? AppColors.secondaryXLight
              : isSelected
                  ? AppColors.primaryXLight
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isRoti
                ? AppColors.secondary
                : isSelected
                    ? AppColors.primary
                    : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isRoti
                ? AppColors.secondary
                : isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
            fontWeight: isRoti || isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  // 5. MUST TRY
  // ────────────────────────────────────────────────────────
  Widget _buildMustTry() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 22),
              const SpaceWidth(6),
              Text(
                'Must Try!',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${_mustTryItems.length} item',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SpaceHeight(4),
          // Dashed divider
          _buildDashedDivider(),
          const SpaceHeight(12),
          // 2-column grid
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _mustTryItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final item = _mustTryItems[index];
              return _MustTryCard(
                name: item['name'] as String,
                category: item['category'] as String,
                price: item['price'] as String,
                badgeLabel: item['badge'] as String,
                badgeColor: Color(item['badgeColor'] as int),
                badgeTextColor: Color(item['badgeTextColor'] as int),
              );
            },
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  // 6. ALL ITEMS
  // ────────────────────────────────────────────────────────
  Widget _buildAllItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Semua',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${_allItems.length} item',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SpaceHeight(4),
          _buildDashedDivider(),
          const SpaceHeight(8),
          ..._allItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                _AllItemCard(
                  name: item['name']!,
                  category: item['category']!,
                  price: item['price']!,
                  desc: item['desc']!,
                ),
                if (index < _allItems.length - 1)
                  Divider(
                    color: AppColors.border.withValues(alpha: 0.5),
                    height: 1,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(builder: (context, constraints) {
      const dashWidth = 4.0;
      const dashSpace = 4.0;
      final totalWidth = constraints.constrainWidth();
      final dashCount = (totalWidth / (dashWidth + dashSpace)).floor();
      return Row(
        children: List.generate(dashCount, (_) => Container(
          width: dashWidth,
          height: 1,
          margin: const EdgeInsets.only(right: dashSpace),
          color: AppColors.border,
        )),
      );
    });
  }
}

// ────────────────────────────────────────────────────────
// MUST TRY CARD
// ────────────────────────────────────────────────────────
class _MustTryCard extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  const _MustTryCard({
    required this.name,
    required this.category,
    required this.price,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder with badge
          Stack(
            children: [
              Container(
                height: 130,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryXLight,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _badgeIcon(),
                        size: 12,
                        color: badgeTextColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        badgeLabel,
                        style: AppTextStyles.micro.copyWith(
                          color: badgeTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: AppTextStyles.micro.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: AppColors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _badgeIcon() {
    if (badgeLabel == 'Best Seller') return Icons.workspace_premium_rounded;
    if (badgeLabel == 'Top Ordered') return Icons.thumb_up_rounded;
    return Icons.star_rounded;
  }
}

// ────────────────────────────────────────────────────────
// ALL ITEM CARD (horizontal list)
// ────────────────────────────────────────────────────────
class _AllItemCard extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String desc;

  const _AllItemCard({
    required this.name,
    required this.category,
    required this.price,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image placeholder with badge
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryXLight,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 11, color: AppColors.warningText),
                      const SizedBox(width: 3),
                      Text(
                        'Most Popular',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.warningText,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SpaceWidth(12),
          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SpaceWidth(8),
          // Heart + Add button
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.favorite_border_rounded, color: AppColors.textSecondary, size: 22),
              const SpaceHeight(24),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: AppColors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
