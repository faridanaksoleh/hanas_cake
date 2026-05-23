import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = 'Large';
  String selectedSweetness = 'Less Sweet';
  int quantity = 2;
  bool isFavorite = false;

  void _showAddToCartBottomSheet(BuildContext context) {
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
                // Drag Handle
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
                
                // Title
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
                
                // Kartu Berhasil Masuk Keranjang
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadows: [
                      BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primaryMid,
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/croissant_mentega_zoom.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SpaceWidth(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Croissant Mentega', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                            const SpaceHeight(2),
                            Text('Large', style: AppTextStyles.micro.copyWith(color: AppColors.textSecondary)),
                            const SpaceHeight(6),
                            Text('Berhasil masuk keranjang', style: AppTextStyles.caption.copyWith(color: AppColors.successText, fontWeight: FontWeight.w600)),
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
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SpaceHeight(16),

                // Opsi Kategori Rekomendasi
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

                // Tombol Cek Keranjang
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      GoRouter.of(context).push('/checkout');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text('Cek Keranjang', style: AppTextStyles.body.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SpaceHeight(12),
                
                // Tombol Lanjut Belanja
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      GoRouter.of(context).push('/delivery', extra: {'isFromCart': true});
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Lanjut Belanja', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
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
        GoRouter.of(context).push('/delivery', extra: {'isFromCart': true});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // ─────────────────────────────────────────────────────────
          // KONTEN UTAMA
          // ─────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER IMAGE & BACK BUTTON
                  Container(
                    width: double.infinity,
                    height: 340,
                    color: AppColors.primaryMid,
                    child: SafeArea(
                      bottom: false,
                      child: Stack(
                        children: [
                          // Gambar Produk
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Transform.scale(
                                scale: 1,
                                child: Image.asset(
                                  'assets/images/croissant_mentega_zoom.png', 
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          // Tombol Back
                          Positioned(
                            top: 10,
                            left: 8,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
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
                  
                  // DESKRIPSI & HARGA
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Croissant mentega', 
                          style: AppTextStyles.h1.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SpaceHeight(8),
                        Text(
                          'Croissant mentega premium dengan lapisan super flaky dan aroma butter yang langsung menggoda sejak gigitan pertama.',
                          style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                        ),
                        const SpaceHeight(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rp15.000', 
                              style: AppTextStyles.h1.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => isFavorite = !isFavorite),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border, 
                                color: isFavorite ? AppColors.dangerText : AppColors.textSecondary, 
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1, thickness: 4, color: AppColors.surface),
                  
                  // OPSI UKURAN
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ukuran', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                            Text('Wajib, Pilih 1', style: AppTextStyles.micro),
                          ],
                        ),
                        const SpaceHeight(12),
                        _buildRadioOption('Small', '', selectedSize, (val) => setState(() => selectedSize = val!)),
                        const SpaceHeight(8),
                        _buildRadioOption('Large', '+ Rp 3.000', selectedSize, (val) => setState(() => selectedSize = val!)),
                      ],
                    ),
                  ),

                  const Divider(height: 1, thickness: 4, color: AppColors.surface),

                  // OPSI SWEETNESS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Swetness', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                            Text('Wajib, Pilih 1', style: AppTextStyles.micro),
                          ],
                        ),
                        const SpaceHeight(12),
                        _buildRadioOption('Normal sweet', '', selectedSweetness, (val) => setState(() => selectedSweetness = val!)),
                        const SpaceHeight(8),
                        _buildRadioOption('Less Sweet', '', selectedSweetness, (val) => setState(() => selectedSweetness = val!)),
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
      
      // ─────────────────────────────────────────────────────────
      // BOTTOM BAR CHECKOUT
      // ─────────────────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              // Quantity Control
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.white,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, size: 20, color: quantity > 1 ? AppColors.textPrimary : AppColors.textSecondary),
                      onPressed: () { if(quantity > 1) setState(() => quantity--); },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SpaceWidth(12),
                    Text('$quantity', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600)),
                    const SpaceWidth(12),
                    GestureDetector(
                      onTap: () => setState(() => quantity++),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.add, size: 16, color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceWidth(16),
              // Bayar Sekarang Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _showAddToCartBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text('Bayar Sekarang', style: AppTextStyles.body.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Komponen Radio Button
  Widget _buildRadioOption(String title, String trailing, String groupValue, ValueChanged<String?> onChanged) {
    bool isSelected = title == groupValue;
    return GestureDetector(
      onTap: () => onChanged(title),
      child: Container(
        color: Colors.transparent, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
            Row(
              children: [
                if (trailing.isNotEmpty) ...[
                  Text(trailing, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  const SpaceWidth(16),
                ],
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
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