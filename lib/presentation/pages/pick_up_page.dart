import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import 'package:hanas_cake/presentation/pages/branch_list_page.dart'; 

class PickUpPage extends StatefulWidget {
  final bool isFromCart;
  const PickUpPage({super.key, this.isFromCart = false});

  @override
  State<PickUpPage> createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> {
  // ────────────────────────────────────────────────────────
  // STATE & LOGIC
  // ────────────────────────────────────────────────────────
  BranchItem? selectedBranch;
  bool isBranchSelected = false; 
  
  final GlobalKey _semuaSectionKey = GlobalKey();
  Set<String> favoriteItems = {};
  
  String _selectedChip = 'Semua';
  final List<String> _categories = ['Semua', 'Roti & Donat', 'Pastri', 'Kue', 'Minuman'];

  void toggleFavorite(String id) {
    setState(() {
      if (favoriteItems.contains(id)) {
        favoriteItems.remove(id);
      } else {
        favoriteItems.add(id);
      }
    });
  }

  void scrollToSemua() {
    if (_semuaSectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        _semuaSectionKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onProductTapped() {
    if (!isBranchSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih cabang toko terlebih dahulu ya!', style: AppTextStyles.bodySmall.copyWith(color: AppColors.white)),
          backgroundColor: AppColors.dangerBg,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      GoRouter.of(context).push('/product-detail', extra: {'isPickUp': true}); 
    }
  }

  void _showOrderMethodBottomSheet(BuildContext context) {
    String selectedMethod = 'Pick Up'; 

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SpaceHeight(24),
                  Text(
                    'Pilih Metode Pemesanan',
                    style: AppTextStyles.h2.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const SpaceHeight(24),
                  _buildMethodOption(
                    title: 'Pick Up',
                    subtitle: 'Ambil di Store tanpa antri',
                    imagePath: 'assets/images/home_pickup.png',
                    value: 'Pick Up',
                    groupValue: selectedMethod,
                    onChanged: (val) {
                      setModalState(() => selectedMethod = val!);
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(bottomSheetContext); 
                      });
                    },
                  ),
                  const SpaceHeight(16),
                  _buildMethodOption(
                    title: 'Delivery',
                    subtitle: 'Garansi tepat waktu, dijamin!',
                    imagePath: 'assets/images/home_delivery.png',
                    value: 'Delivery',
                    groupValue: selectedMethod,
                    onChanged: (val) {
                      setModalState(() => selectedMethod = val!);
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(bottomSheetContext); 
                        GoRouter.of(context).pushReplacement('/delivery'); 
                      });
                    },
                  ),
                  const SpaceHeight(32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMethodOption({required String title, required String subtitle, required String imagePath, required String value, required String groupValue, required ValueChanged<String?> onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Image.asset(imagePath, width: 48, height: 60, fit: BoxFit.contain),
            const SpaceWidth(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                  const SpaceHeight(4),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              activeColor: AppColors.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  // BUILD UI
  // ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ────────────────────────────────────────────────────────
            // 1. HEADER (Cokelat Solid)
            // ────────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              color: AppColors.primary, 
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
                        onPressed: () {
                          if (GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          } else {
                            GoRouter.of(context).go('/home');
                          }
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.search, color: AppColors.white, size: 28),
                          onPressed: () {},
                        ),
                        const SpaceWidth(16),
                      ],
                    ),
                    SizedBox(
                      height: 140,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 0,
                            bottom: 0,
                            // 🔥 FIX: Nama gambar sudah disesuaikan!
                            child: Image.asset(
                              'assets/images/half_pickup.png',
                              height: 140,
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomLeft,
                            ),
                          ),
                          Positioned.fill(
                            left: 140,
                            right: 16,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Pick Up',
                                        style: AppTextStyles.h1.copyWith(
                                          color: AppColors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SpaceHeight(4),
                                      Text(
                                        'Ambil di Store tanpa antri',
                                        style: AppTextStyles.micro.copyWith(
                                          color: AppColors.white,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SpaceWidth(12),
                                GestureDetector(
                                  onTap: () => _showOrderMethodBottomSheet(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryXLight,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Text(
                                      'Ubah',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
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
                  ],
                ),
              ),
            ),

            // ────────────────────────────────────────────────────────
            // 2. ALAMAT CABANG
            // ────────────────────────────────────────────────────────
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final result = await GoRouter.of(context).push('/branch-list', extra: {'isPickUp': true});
                if (result != null && result is BranchItem) {
                  setState(() {
                    selectedBranch = result;
                    isBranchSelected = true;
                  });
                }
              },
              child: Container(
                color: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    // 🔥 FIX: Container dibuang, ColorFilter dibuang! Murni nampilin SVG bawaan Figma
                    SvgPicture.asset(
                      'assets/icons/branch2.svg', 
                      width: 44, 
                      height: 44,
                    ),
                    const SpaceWidth(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedBranch?.name ?? 'Alamat Cabang terdekat',
                            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SpaceHeight(4),
                          RichText(
                            text: TextSpan(
                              text: isBranchSelected ? '${selectedBranch?.distanceKm} km • ' : '19.48 km • ',
                              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                              children: [
                                TextSpan(
                                  text: 'Terdekat',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.secondary, 
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
                  ],
                ),
              ),
            ),
            
            const SpaceHeight(12),

            // ────────────────────────────────────────────────────────
            // 3. KONTEN PRODUK (Favorite, Chips, Must Try, Semua)
            // ────────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(color: AppColors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // My Favorite
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('My Favorite', style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w600, letterSpacing: -0.36)),
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push('/my-favorite'),
                          child: Text('Lihat Semua', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondary)),
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeight(12),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildHorizontalDashedLine()),
                  const SpaceHeight(16),

                  SizedBox(
                    height: 116,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      children: [
                        _buildFavoriteCard('fav_1', 'Croissant mentega', 'Croissant mentega premium ...', 'Rp15.000', 'assets/images/croissant_mentega.png'),
                        _buildFavoriteCard('fav_2', 'Donut Matcha cih', 'Donut Matcha premium ...', 'Rp15.000', 'assets/images/donut_matcha_cih.png'),
                      ],
                    ),
                  ),

                  const SpaceHeight(24),

                  // Category Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: scrollToSemua,
                          child: Container(
                            width: 48,
                            padding: const EdgeInsets.all(8),
                            decoration: ShapeDecoration(
                              color: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Center(
                              child: Text('⭐', style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                            ),
                          ),
                        ),
                        const SpaceWidth(12),
                        ..._categories.map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildChip(cat),
                        )),
                      ],
                    ),
                  ),

                  const SpaceHeight(24),

                  // Must Try
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('⭐ ', style: TextStyle(fontSize: 20)),
                            Text('Must Try!', style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w600, letterSpacing: -0.36)),
                          ],
                        ),
                        Text('6 item', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SpaceHeight(8),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildHorizontalDashedLine()),
                  const SpaceHeight(16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildGridCard('try_1', 'assets/icons/best_seller.svg', 'Pastri', 'Croissant Mentega', 'Rp15.000', 'assets/images/croissant_mentega.png'),
                        _buildGridCard('try_2', 'assets/icons/top_ordered.svg', 'Pastri', 'Donut Mactha cih', 'Rp15.000', 'assets/images/donut_matcha_cih.png'),
                        _buildGridCard('try_3', 'assets/icons/most_popular.svg', 'Kue', 'Red Velvet Parfait', 'Rp15.000', 'assets/images/red_velvet_parfait.png'),
                        _buildGridCard('try_4', 'assets/icons/most_popular.svg', 'Kue', 'Molen Bandung', 'Rp15.000', 'assets/images/molen_bandung.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SpaceHeight(12),

            // ────────────────────────────────────────────────────────
            // 4. SEMUA
            // ────────────────────────────────────────────────────────
            Container(
              key: _semuaSectionKey, 
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(color: AppColors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Semua', style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w600)),
                      Text('3 item', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SpaceHeight(12),
                  _buildHorizontalDashedLine(),
                  const SpaceHeight(16),
                  
                  _buildSemuaListCard('semua_1', 'assets/icons/most_popular.svg', 'Croissant mentega', 'Croissant mentega premium dengan lapisan...', 'Rp15.000', 'assets/images/croissant_mentega.png'),
                  const SpaceHeight(24),
                  _buildSemuaListCard('semua_2', 'assets/icons/most_popular.svg', 'Donut Matcha cih', 'Donut Matcha premium dengan lapisan...', 'Rp15.000', 'assets/images/donut_matcha_cih.png'),
                  const SpaceHeight(24),
                  _buildSemuaListCard('semua_3', 'assets/icons/most_popular.svg', 'Red Velvet Parfait', 'Red Velvet Parfait premium dengan lapisan...', 'Rp15.000', 'assets/images/red_velvet_parfait.png'),
                ],
              ),
            ),
            
            SpaceHeight(widget.isFromCart ? 100 : 32),
          ],
        ),
      ),

      // ────────────────────────────────────────────────────────
      // STICKY CART BOTTOM BAR
      // ────────────────────────────────────────────────────────
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.isFromCart ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () {
            GoRouter.of(context).push('/checkout', extra: {'isPickUp': true});
          },
          child: Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.primary, 
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cek Keranjang (2 Produk)', style: AppTextStyles.body.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text('Rp 30.000', style: AppTextStyles.body.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
                    const SpaceWidth(12),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: AppColors.primary, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ) : null,
    );
  }

  // ────────────────────────────────────────────────────────
  // HELPER WIDGETS
  // ────────────────────────────────────────────────────────

  Widget _buildChip(String label) {
    final isSelected = _selectedChip == label;
    final isRoti = label == 'Roti & Donat'; 

    return GestureDetector(
      onTap: () {
        setState(() => _selectedChip = label);
        if (label == 'Semua') scrollToSemua();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: ShapeDecoration(
          color: isRoti ? AppColors.secondaryXLight : (isSelected ? AppColors.primaryXLight : AppColors.white),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1, 
              color: isRoti ? AppColors.secondary : (isSelected ? AppColors.primary : AppColors.border),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label, 
          style: AppTextStyles.micro.copyWith(
            color: isRoti ? AppColors.secondary : (isSelected ? AppColors.primary : AppColors.textSecondary), 
            fontWeight: isRoti || isSelected ? FontWeight.bold : FontWeight.w500
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalDashedLine() {
    return Row(
      children: List.generate(
        45,
        (index) => Expanded(
          child: Container(
            height: 1,
            color: index % 2 == 0 ? AppColors.border : Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(String id, String name, String subtitle, String price, String imagePath) {
    final isFav = favoriteItems.contains(id);
    return GestureDetector(
      onTap: _onProductTapped, 
      child: Container(
        width: 358,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.surface),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Container(
              width: 88, height: 88,
              decoration: ShapeDecoration(
                color: AppColors.primaryMid,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.contain),
              ),
            ),
            const SpaceWidth(24),
            Expanded(
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
                            Text(name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600), maxLines: 1),
                            Text(subtitle, style: AppTextStyles.micro.copyWith(color: AppColors.textSecondary), maxLines: 1),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleFavorite(id),
                        child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : AppColors.border, size: 24),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(price, style: AppTextStyles.h3.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
                      Container(
                        width: 29, height: 28,
                        decoration: ShapeDecoration(
                          color: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        ),
                        child: const Icon(Icons.add, color: AppColors.white, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(String id, String badgeAsset, String category, String name, String price, String imagePath) {
    return GestureDetector(
      onTap: _onProductTapped,
      child: Container(
        width: 171, 
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.surface),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 171, height: 132,
                  decoration: ShapeDecoration(
                    color: AppColors.surface,
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover, 
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    ),
                  ),
                ),
                Positioned(top: 11, left: 8, child: SvgPicture.asset(badgeAsset, height: 24)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: AppTextStyles.micro.copyWith(color: AppColors.textSecondary)),
                  Text(name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SpaceHeight(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(price, style: AppTextStyles.body.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
                      Container(
                        width: 29, height: 28,
                        decoration: ShapeDecoration(
                          color: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        ),
                        child: const Icon(Icons.add, color: AppColors.white, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemuaListCard(String id, String badgeAsset, String name, String subtitle, String priceString, String imagePath) {
    final isFav = favoriteItems.contains(id);

    return GestureDetector(
      onTap: _onProductTapped, 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 100, height: 100,
                decoration: ShapeDecoration(
                  color: AppColors.primaryMid,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.contain),
                ),
              ),
              Positioned(top: 6, left: 6, child: SvgPicture.asset(badgeAsset, height: 20)),
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
                          Text(name, style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                          const SpaceHeight(4),
                          Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => toggleFavorite(id),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : AppColors.textSecondary, size: 24),
                      ),
                    ),
                  ],
                ),
                const SpaceHeight(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(priceString, style: AppTextStyles.h3.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.bold)),
                    Container(
                      width: 32, height: 32,
                      decoration: const ShapeDecoration(color: AppColors.primary, shape: OvalBorder()),
                      child: const Icon(Icons.add, color: AppColors.white, size: 20),
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
}