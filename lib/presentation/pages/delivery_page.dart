import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import 'package:hanas_cake/presentation/pages/branch_list_page.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/address/address_bloc.dart';
import '../blocs/address/address_state.dart';

class DeliveryPage extends StatefulWidget {
  final bool isFromCart;
  const DeliveryPage({super.key, this.isFromCart = false});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  BranchItem? selectedBranch;
  DeliveryLocation? selectedLocation;
  final GlobalKey _semuaSectionKey = GlobalKey();
  Set<String> favoriteItems = {};
  bool isAddressSelected = false;
  String _selectedChip = 'Semua';
  List<Product> _cachedProducts = [];

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProductsEvent());
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

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

  void _onProductTapped({int? productId}) {
    if (!isAddressSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih alamatmu terlebih dahulu ya!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // 🔥 FIX: Pakai GoRouter.of(context) biar IDE-nya nggak bingung
      GoRouter.of(context)
          .push(
            '/product-detail',
            extra: {'isPickUp': false, 'productId': productId, 'location': null},
          )
          .then((_) {
            if (mounted) {
              context.read<ProductBloc>().add(GetProductsEvent());
            }
          });
    }
  }

  void _showOrderMethodBottomSheet(BuildContext context) {
    String selectedMethod = 'Delivery';

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
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SpaceHeight(24),
                  Text(
                    'Pilih Metode Pemesanan',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
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
                        GoRouter.of(context).pushReplacement('/pickup');
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

  Widget _buildMethodOption({
    required String title,
    required String subtitle,
    required String imagePath,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
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
                  Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceHeight(4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState.isEmpty) return const SizedBox.shrink();
          return GestureDetector(
            onTap: () {
              if (!isAddressSelected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pilih alamat pengiriman terlebih dahulu!'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                GoRouter.of(context).push('/checkout', extra: {'isPickUp': false});
              }
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${cartState.totalItems}',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Keranjang',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatPrice(cartState.grandTotal),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.primaryMid,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.primaryLight,
                          size: 20,
                        ),
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
                          icon: const Icon(
                            Icons.search,
                            color: AppColors.primaryLight,
                            size: 28,
                          ),
                          onPressed: () {},
                        ),
                        const SpaceWidth(16),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 147,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryMid,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 126.47,
                            height: 147,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/half_deliv.png",
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivery',
                                      style: AppTextStyles.h1.copyWith(
                                        color: AppColors.primaryLight,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        height: 1.20,
                                        letterSpacing: -0.66,
                                      ),
                                    ),
                                    const SpaceHeight(4),
                                    SizedBox(
                                      width: 116.16,
                                      child: Text(
                                        'Garansi tepat waktu, dijamin!',
                                        style: AppTextStyles.micro.copyWith(
                                          color: AppColors.primaryLight,
                                          height: 1.30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      _showOrderMethodBottomSheet(context),
                                  child: Container(
                                    width: 82,
                                    height: 41,
                                    padding: const EdgeInsets.all(10),
                                    decoration: ShapeDecoration(
                                      color: AppColors.primaryXLight,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          width: 1,
                                          color: AppColors.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Ubah',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
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

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Pesananmu dikirim dari',
                      style: AppTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.36,
                      ),
                    ),
                  ),
                  const SpaceHeight(24),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/branch.svg',
                            width: 42,
                          ),
                          _buildVerticalDashedLine(
                            height: isAddressSelected ? 6 : 3,
                          ),
                          SvgPicture.asset(
                            'assets/icons/address.svg',
                            width: 42,
                          ),
                        ],
                      ),
                      const SpaceWidth(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                final result = await GoRouter.of(context).push(
                                  '/branch-list',
                                  extra: {'isPickUp': false},
                                );
                                if (result != null && result is BranchItem) {
                                  setState(() {
                                    selectedBranch = result;
                                  });
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedBranch?.name ??
                                        'Alamat Cabang terdekat',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    isAddressSelected
                                        ? '0.59km dari lokasimu'
                                        : '-dari lokasimu',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isAddressSelected
                                          ? AppColors.successText
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SpaceHeight(18),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.border,
                            ),
                            const SpaceHeight(18),

                            BlocBuilder<AddressBloc, AddressState>(
                              builder: (context, state) {
                                bool hasAddress = false;
                                String addressText = 'Pilih alamat pengirimanmu terlebih dahulu';
                                
                                if (state is AddressLoaded && state.addresses.isNotEmpty) {
                                  hasAddress = true;
                                  try {
                                    final primary = state.addresses.firstWhere((a) => a.isPrimary);
                                    addressText = primary.fullAddress;
                                  } catch (e) {
                                    addressText = state.addresses.first.fullAddress;
                                  }

                                  // Update global isAddressSelected state safely
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (mounted && isAddressSelected != hasAddress) {
                                      setState(() {
                                        isAddressSelected = hasAddress;
                                      });
                                    }
                                  });
                                } else {
                                  // Update global isAddressSelected state safely
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (mounted && isAddressSelected != hasAddress) {
                                      setState(() {
                                        isAddressSelected = hasAddress;
                                      });
                                    }
                                  });
                                }

                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    GoRouter.of(context).push('/saved-address');
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          addressText,
                                          style: AppTextStyles.body.copyWith(
                                            color: hasAddress ? AppColors.textPrimary : AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SpaceWidth(8),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (isAddressSelected) ...[
                    const SpaceHeight(24),
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const ShapeDecoration(
                            color: AppColors.surface,
                            shape: OvalBorder(),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/note.svg',
                              width: 20,
                            ),
                          ),
                        ),
                        const SpaceWidth(16),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Tambahkan detail lokasi',
                              hintStyle: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SpaceHeight(24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.dangerBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Pastikan alamat pengiriman sudah benar',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.dangerText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SpaceHeight(8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/jam_otw.svg',
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              AppColors.successText,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SpaceWidth(8),
                          Text(
                            'Sampai dalam 23 menit',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.successText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SpaceHeight(12),

            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading && _cachedProducts.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                if (state is ProductFailure && _cachedProducts.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            state.message,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SpaceHeight(12),
                          ElevatedButton(
                            onPressed: () => context.read<ProductBloc>().add(
                              GetProductsEvent(),
                            ),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Cache products to survive state collisions
                if (state is ProductsLoaded) {
                  _cachedProducts = state.products;
                }
                final allProducts = _cachedProducts;
                final isFiltering = _selectedChip != 'Semua';
                final filteredProducts = isFiltering
                    ? allProducts
                          .where(
                            (p) =>
                                p.category?.name?.toLowerCase() ==
                                _selectedChip.toLowerCase(),
                          )
                          .toList()
                    : allProducts;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── My Favorite (hidden when filtering) ──
                      if (!isFiltering) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Favorite',
                                style: AppTextStyles.h2.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.36,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    GoRouter.of(context).push('/my-favorite'),
                                child: Text(
                                  'Lihat Semua',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SpaceHeight(12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildHorizontalDashedLine(),
                        ),
                        const SpaceHeight(16),
                        SizedBox(
                          height: 116,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 16),
                            itemCount: allProducts.length > 2
                                ? 2
                                : allProducts.length,
                            itemBuilder: (context, index) {
                              final p = allProducts[index];
                              return _buildFavoriteCard(
                                p.id.toString(),
                                p.name,
                                p.category?.name ?? 'Pastry',
                                _formatPrice(p.price),
                                p.imageUrl,
                                product: p,
                              );
                            },
                          ),
                        ),
                        const SpaceHeight(24),
                      ],

                      // ── Category Chips (always visible) ──
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              padding: const EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '⭐',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SpaceWidth(12),
                            _buildChip('Semua'),
                            const SpaceWidth(12),
                            ...(state is ProductsLoaded &&
                                    state.categories.isNotEmpty
                                ? state.categories.map(
                                    (cat) => Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: _buildChip(cat.name),
                                    ),
                                  )
                                : [
                                    _buildChip('Cake'),
                                    const SpaceWidth(12),
                                    _buildChip('Bread'),
                                    const SpaceWidth(12),
                                    _buildChip('Cookies'),
                                  ]),
                          ],
                        ),
                      ),

                      const SpaceHeight(24),

                      // ── Must Try (hidden when filtering) ──
                      if (!isFiltering) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    '⭐ ',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Must Try!',
                                    style: AppTextStyles.h2.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.36,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${allProducts.length} item',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SpaceHeight(8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildHorizontalDashedLine(),
                        ),
                        const SpaceHeight(16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: allProducts.length,
                            itemBuilder: (context, index) {
                              final p = allProducts[index];
                              return _buildGridCard(
                                p.id.toString(),
                                null,
                                p.category?.name ?? 'Pastry',
                                p.name,
                                _formatPrice(p.price),
                                p.imageUrl,
                                product: p,
                              );
                            },
                          ),
                        ),
                        const SpaceHeight(12),
                      ],

                      // ── Semua / Filtered Results ──
                      if (filteredProducts.isEmpty) ...[
                        Container(
                          key: _semuaSectionKey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: Center(
                            child: Text(
                              'Tidak ada produk untuk kategori ini.',
                              style: AppTextStyles.body,
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          key: _semuaSectionKey,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isFiltering ? _selectedChip : 'Semua',
                                    style: AppTextStyles.h2.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${filteredProducts.length} item',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SpaceHeight(12),
                              _buildHorizontalDashedLine(),
                              const SpaceHeight(16),
                              ...filteredProducts.map((p) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildSemuaListCard(
                                    p.id.toString(),
                                    null,
                                    p.name,
                                    p.description ?? 'Produk premium...',
                                    _formatPrice(p.price),
                                    p.imageUrl,
                                    product: p,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            SpaceHeight(widget.isFromCart ? 100 : 32),
          ],
        ),
      ),

      // 🔥 FIX: Tombol Keranjang yang tadinya glitch hancur
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.isFromCart
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  GoRouter.of(
                    context,
                  ).push('/checkout', extra: {'isPickUp': false});
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cek Keranjang (2 Produk)',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Rp 30.000',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SpaceWidth(12),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  // HELPER WIDGETS
  Widget _buildVerticalDashedLine({int height = 6}) {
    return Column(
      children: List.generate(
        height,
        (index) => Container(
          width: 1.5,
          height: 3,
          margin: const EdgeInsets.symmetric(vertical: 2),
          color: AppColors.textSecondary,
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

  Widget _buildChip(String label) {
    final isSelected = _selectedChip == label;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedChip = label);
        if (label == 'Semua') scrollToSemua();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? AppColors.primaryXLight : AppColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
    String id,
    String name,
    String subtitle,
    String price,
    String imagePath, {
    Product? product,
  }) {
    final isFav = favoriteItems.contains(id);
    final isNetworkImage = imagePath.startsWith('http');
    return GestureDetector(
      onTap: () => _onProductTapped(productId: product?.id),
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
          shadows: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 88,
              height: 88,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: AppColors.primaryMid,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isNetworkImage && imagePath.isNotEmpty
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.contain,
                      cacheHeight: 400,
                      errorBuilder: (c, e, s) => Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.surface,
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.grey),
                      ),
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
                            Text(
                              name,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              subtitle,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleFavorite(id),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : AppColors.border,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (product != null) {
                            context.read<CartBloc>().add(
                              AddToCartEvent(product),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.name} dimasukkan ke keranjang',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 29,
                          height: 28,
                          decoration: ShapeDecoration(
                            color: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
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

  Widget _buildGridCard(
    String id,
    String? badgeAsset,
    String category,
    String name,
    String price,
    String imagePath, {
    Product? product,
  }) {
    final isNetworkImage = imagePath.startsWith('http');
    return GestureDetector(
      onTap: () => _onProductTapped(productId: product?.id),
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
                  width: 171,
                  height: 132,
                  clipBehavior: Clip.antiAlias,
                  decoration: const ShapeDecoration(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                  child: isNetworkImage && imagePath.isNotEmpty
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          cacheHeight: 400,
                          errorBuilder: (c, e, s) => const Center(
                            child: Icon(Icons.image, color: Colors.grey),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                ),
                if (badgeAsset != null)
                  Positioned(
                    top: 11,
                    left: 8,
                    child: SvgPicture.asset(badgeAsset, height: 24),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpaceHeight(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (product != null) {
                            context.read<CartBloc>().add(
                              AddToCartEvent(product),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.name} dimasukkan ke keranjang',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 29,
                          height: 28,
                          decoration: ShapeDecoration(
                            color: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
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

  Widget _buildSemuaListCard(
    String id,
    String? badgeAsset,
    String name,
    String subtitle,
    String priceString,
    String imagePath, {
    Product? product,
  }) {
    final isFav = favoriteItems.contains(id);
    final isNetworkImage = imagePath.startsWith('http');

    return GestureDetector(
      onTap: () => _onProductTapped(productId: product?.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.primaryMid,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isNetworkImage && imagePath.isNotEmpty
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.contain,
                        cacheHeight: 400,
                        errorBuilder: (c, e, s) => Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
              ),
              if (badgeAsset != null)
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
                            style: AppTextStyles.h3.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SpaceHeight(4),
                          Text(
                            subtitle,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
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
                        padding: const EdgeInsets.only(left: 8.0),
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
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (product != null) {
                          context.read<CartBloc>().add(AddToCartEvent(product));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} dimasukkan ke keranjang',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const ShapeDecoration(
                          color: AppColors.primary,
                          shape: OvalBorder(),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: 20,
                        ),
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
}

class DeliveryLocation {
  final String address;
  DeliveryLocation({required this.address});
}
