import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      backgroundColor: Colors.white,
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
                      color: const Color(0xFF9CA3AF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title
                const Center(
                  child: Text(
                    'Lengkapi Belanjamu',
                    style: TextStyle(color: Color(0xFF5A3A31), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Kartu Berhasil Masuk Keranjang
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadows: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDD8D0), // Background krem kotak
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/croissant_mentega_zoom.png'), // Tetap gambar asli
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Croissant Mentega', style: TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text('Large', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
                            SizedBox(height: 6),
                            Text('Berhasil masuk keranjang', style: TextStyle(color: Color(0xFF166534), fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Ssst...tambah ini jadi lebih enak',
                    style: TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),

                // Opsi Kategori Rekomendasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSuggestionChip('Roti', bottomSheetContext),
                    const SizedBox(width: 12),
                    _buildSuggestionChip('Pastri', bottomSheetContext),
                    const SizedBox(width: 12),
                    _buildSuggestionChip('Kue', bottomSheetContext),
                  ],
                ),

                const SizedBox(height: 32),

                // Tombol Cek Keranjang
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      context.push('/checkout');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A3A31),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Cek Keranjang', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Tombol Lanjut Belanja
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      context.push('/delivery', extra: {'isFromCart': true});
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF5A3A31)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Lanjut Belanja', style: TextStyle(color: Color(0xFF5A3A31), fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
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
        context.push('/delivery', extra: {'isFromCart': true});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ─────────────────────────────────────────────────────────
          // KONTEN UTAMA (Di dalam SingleChildScrollView agar scrollable bersamaan)
          // ─────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER IMAGE & BACK BUTTON
                  Container(
                    width: double.infinity,
                    height: 340, // Ditinggikan agar gambarnya leluasa
                    color: const Color(0xFFEDD8D0), // Background krem
                    child: SafeArea(
                      bottom: false,
                      child: Stack(
                        children: [
                          // Gambar Produk (DIPERBESAR)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Transform.scale(
                                scale: 1, // Biar di tengah dan ga terlalu besar atau kecil
                                child: Image.asset(
                                  'assets/images/croissant_mentega_zoom.png', 
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          // Hanya Tombol Back (Search dihapus)
                          Positioned(
                            top: 10,
                            left: 8,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF5A3A31), size: 20),
                              onPressed: () {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/delivery');
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
                        const Text(
                          'Croissant mentega', 
                          style: TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Croissant mentega premium dengan lapisan super flaky dan aroma butter yang langsung menggoda sejak gigitan pertama.',
                          style: TextStyle(color: Color(0xFF6B7280), fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rp15.000', 
                              style: TextStyle(color: Color(0xFF5A3A31), fontWeight: FontWeight.w700, fontSize: 22),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => isFavorite = !isFavorite),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border, 
                                color: isFavorite ? Colors.red : const Color(0xFF6B7280), 
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1, thickness: 4, color: Color(0xFFF3F4F6)),
                  
                  // OPSI UKURAN
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Ukuran', style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Wajib, Pilih 1', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildRadioOption('Small', '', selectedSize, (val) => setState(() => selectedSize = val!)),
                        const SizedBox(height: 8),
                        _buildRadioOption('Large', '+ Rp 3.000', selectedSize, (val) => setState(() => selectedSize = val!)),
                      ],
                    ),
                  ),

                  const Divider(height: 1, thickness: 4, color: Color(0xFFF3F4F6)),

                  // OPSI SWEETNESS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Swetness', style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Wajib, Pilih 1', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildRadioOption('Normal sweet', '', selectedSweetness, (val) => setState(() => selectedSweetness = val!)),
                        const SizedBox(height: 8),
                        _buildRadioOption('Less Sweet', '', selectedSweetness, (val) => setState(() => selectedSweetness = val!)),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40), 
                ],
              ),
            ),
          ),
        ],
      ),
      
      // ─────────────────────────────────────────────────────────
      // BOTTOM BAR CHECKOUT (FIXED DI BAWAH LAYAR)
      // ─────────────────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              // Quantity Control
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, size: 20, color: quantity > 1 ? const Color(0xFF1F2937) : const Color(0xFF9CA3AF)),
                      onPressed: () { if(quantity > 1) setState(() => quantity--); },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Text('$quantity', style: const TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => setState(() => quantity++),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFF5A3A31), shape: BoxShape.circle),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Bayar Sekarang Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _showAddToCartBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A3A31),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Bayar Sekarang', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
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
            Text(title, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 14)),
            Row(
              children: [
                if (trailing.isNotEmpty) ...[
                  Text(trailing, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                  const SizedBox(width: 16),
                ],
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? const Color(0xFF3454D1) : const Color(0xFFD1D5DB),
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