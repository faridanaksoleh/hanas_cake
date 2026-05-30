import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';

class ProductDetailPage extends StatefulWidget {
  final bool isPickUp;
  final int? productId;
  final dynamic location;
  const ProductDetailPage({super.key, this.isPickUp = false, this.productId, this.location});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = 'Small';
  String selectedSweetness = 'Normal sweet';
  int quantity = 1;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      context.read<ProductBloc>().add(GetProductDetailEvent(widget.productId!));
    }
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(price);
  }

  void _showAddToCartBottomSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SpaceHeight(24),
                Center(
                  child: Text(
                    'Lengkapi Belanjamu',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SpaceHeight(24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadows: [
                      BoxShadow(
                        color: AppColors.textPrimary.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primaryMid,
                          borderRadius: BorderRadius.circular(8),
                          image: product.imageUrl.startsWith('http')
                              ? DecorationImage(
                                  image: NetworkImage(product.imageUrl),
                                  fit: BoxFit.contain,
                                )
                              : null,
                        ),
                        child: !product.imageUrl.startsWith('http')
                            ? const Center(child: Icon(Icons.image, color: Colors.grey, size: 28))
                            : null,
                      ),
                      const SpaceWidth(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SpaceHeight(2),
                            Text(
                              '$quantity x ${_formatPrice(product.price)}',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SpaceHeight(6),
                            Text(
                              'Berhasil masuk keranjang',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.successText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceHeight(24),
                Center(
                  child: Text(
                    'Ssst...tambah ini jadi lebih enak',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SpaceHeight(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSuggestionChip('Roti', bottomSheetContext),
                    const SpaceWidth(12),
                    _buildSuggestionChip('Pastri', bottomSheetContext),
                    const SpaceWidth(12),
                    _buildSuggestionChip('Kue', bottomSheetContext),
                  ],
                ),
                const SpaceHeight(32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext); // Tutup bottom sheet
                      GoRouter.of(context).push('/checkout', extra: {'isPickUp': widget.isPickUp, 'location': widget.location});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Cek Keranjang',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SpaceHeight(12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      GoRouter.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Lanjut Belanja',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SpaceHeight(16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestionChip(String label, BuildContext bottomSheetContext) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(bottomSheetContext);
        GoRouter.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        // Extract product data from state or use defaults
        String productName = 'Croissant mentega';
        String productDesc = 'Croissant mentega premium dengan lapisan super flaky dan aroma butter yang langsung menggoda sejak gigitan pertama.';
        String productPrice = 'Rp15.000';
        String productImage = 'assets/images/croissant_mentega_zoom.png';
        bool isNetworkImage = false;
        List<String> portions = ['Small', 'Large'];
        List<String> flavors = [];

        // Extract product object for cart
        Product? currentProduct;

        if (state is ProductDetailLoaded) {
          final p = state.product;
          productName = p.name;
          productDesc = p.description ?? productDesc;
          
          // Kalkulasi Harga (Large +5000)
          double basePrice = p.price;
          if (selectedSize == 'Large') {
            basePrice += 5000;
          }
          productPrice = _formatPrice(basePrice);
          
          productImage = p.imageUrl;
          isNetworkImage = productImage.startsWith('http');
          if (p.portions != null && p.portions!.isNotEmpty) {
            portions = p.portions!.map((s) => s[0].toUpperCase() + s.substring(1)).toList();
            if (!portions.contains(selectedSize)) {
              selectedSize = portions.first;
            }
          }
          if (p.flavors != null && p.flavors!.isNotEmpty) {
            flavors = p.flavors!.map((s) => s[0].toUpperCase() + s.substring(1)).toList();
          }

          // Buat object baru untuk keranjang
          currentProduct = Product(
            id: p.id,
            categoryId: p.categoryId,
            name: '${p.name} ($selectedSize)', // Tambah informasi variant ke nama
            description: p.description,
            price: basePrice, // Harga yang sudah ditambah 5000
            imageUrl: p.imageUrl,
            portions: p.portions,
            flavors: p.flavors,
            stock: p.stock,
            discount: p.discount,
            slug: p.slug,
            isPo: p.isPo,
          );
        }

        if (state is ProductLoading) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 340,
                    child: SafeArea(
                      bottom: false,
                      child: Stack(
                        children: [
                          Center(
                            child: Transform.scale(
                              scale: 1,
                              child: isNetworkImage && productImage.isNotEmpty
                                  ? Image.network(
                                      productImage,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      cacheHeight: 400,
                                      errorBuilder: (c, e, s) => Container(
                                        width: double.infinity,
                                        color: AppColors.surface,
                                        child: const Center(
                                          child: Icon(Icons.image, color: Colors.grey, size: 64),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      color: AppColors.surface,
                                      child: const Center(
                                        child: Icon(Icons.image, color: Colors.grey, size: 64),
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              onPressed: () {
                                if (GoRouter.of(context).canPop()) {
                                  GoRouter.of(context).pop();
                                } else {
                                  GoRouter.of(context).go('/delivery');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: AppTextStyles.h1.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SpaceHeight(8),
                        Text(
                          productDesc,
                          style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                        ),
                        const SpaceHeight(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              productPrice,
                              style: AppTextStyles.h1.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => isFavorite = !isFavorite),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? AppColors.dangerText
                                    : AppColors.textSecondary,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 4,
                    color: AppColors.surface,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ukuran',
                              style: AppTextStyles.h3.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Wajib, Pilih 1', style: AppTextStyles.micro),
                          ],
                        ),
                        const SpaceHeight(12),
                        ...portions.map((portion) => Column(
                          children: [
                            _buildRadioOption(
                              portion,
                              '',
                              selectedSize,
                              (val) => setState(() => selectedSize = val!),
                            ),
                            const SpaceHeight(8),
                          ],
                        )),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 4,
                    color: AppColors.surface,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Swetness',
                              style: AppTextStyles.h3.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Wajib, Pilih 1', style: AppTextStyles.micro),
                          ],
                        ),
                        const SpaceHeight(12),
                        _buildRadioOption(
                          'Normal sweet',
                          '',
                          selectedSweetness,
                          (val) => setState(() => selectedSweetness = val!),
                        ),
                        const SpaceHeight(8),
                        _buildRadioOption(
                          'Less Sweet',
                          '',
                          selectedSweetness,
                          (val) => setState(() => selectedSweetness = val!),
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeight(40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              // 🔥 Quantity Control - SAMA PERSIS DENGAN CHECKOUT PAGE
              Row(
                children: [
                  // Tombol MINUS (lingkaran dengan border)
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SpaceWidth(12),
                  Text(
                    '$quantity',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceWidth(12),
                  // Tombol PLUS (lingkaran dengan background primary)
                  GestureDetector(
                    onTap: () => setState(() => quantity++),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SpaceWidth(16),
              // Tombol Bayar Sekarang
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (currentProduct != null) {
                            // Dispatch AddToCartEvent ke CartBloc
                            context.read<CartBloc>().add(
                                  AddToCartEvent(currentProduct, quantity: quantity),
                                );
                            _showAddToCartBottomSheet(context, currentProduct);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Bayar Sekarang',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildRadioOption(
    String title,
    String trailing,
    String groupValue,
    ValueChanged<String?> onChanged,
  ) {
    bool isSelected = title == groupValue;
    return GestureDetector(
      onTap: () => onChanged(title),
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Row(
              children: [
                if (trailing.isNotEmpty) ...[
                  Text(
                    trailing,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SpaceWidth(16),
                ],
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected ? AppColors.secondary : AppColors.border,
                  size: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
