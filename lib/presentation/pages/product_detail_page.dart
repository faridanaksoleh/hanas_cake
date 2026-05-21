import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Wajib agar context.push/pop dikenali
// Pastikan import theme kamu benar, sesuaikan jika beda
// import 'package:hanas_cake/core/core.dart'; 

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
      builder: (bottomSheetContext) { // Context khusus untuk pop-up
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garis handle abu-abu
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFF9CA3AF), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text('Lengkapi Belanjamu', style: TextStyle(color: Color(0xFF5A3A31), fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
              
              // Kartu Berhasil Masuk Keranjang
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDD8D0), // Warna primaryXLight
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(image: AssetImage('assets/images/croissant.png'), fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Croissant Mentega', style: TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('Large', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                          SizedBox(height: 4),
                          Text('Berhasil masuk keranjang', style: TextStyle(color: Color(0xFF166534), fontSize: 12, fontWeight: FontWeight.bold)), // Hijau
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Center(
                child: Text('Ssst...tambah ini jadi lebih enak', style: TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),

              // Opsi Kategori (Roti, Pastri, Kue)
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
                    Navigator.pop(bottomSheetContext); // Tutup pop-up dengan aman
                    context.push('/checkout'); // Mengarah ke checkout dummy
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A3A31), // Cokelat utama
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
                    Navigator.pop(bottomSheetContext); // Tutup pop up dengan aman
                    // Buka Delivery Page dengan mode "Keranjang Aktif" menggunakan query parameter / extra
                    context.push('/delivery', extra: {'isFromCart': true});
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF5A3A31)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Lanjut Belanja', style: TextStyle(color: Color(0xFF5A3A31), fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // Chip Rekomendasi (Klik -> ke delivery page)
  Widget _buildSuggestionChip(String label, BuildContext bottomSheetContext) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(bottomSheetContext); 
        context.push('/delivery', extra: {'isFromCart': true});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDD8D0), // Sesuai figma background header
        elevation: 0,
        leading: IconButton(
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            Container(
              width: double.infinity,
              height: 250,
              color: const Color(0xFFEDD8D0),
              child: Image.asset('assets/images/croissant.png', fit: BoxFit.contain),
            ),
            
            // Detail Produk
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Croissant mentega', style: TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold, fontSize: 24)),
                  const SizedBox(height: 8),
                  const Text(
                    'Croissant mentega premium dengan lapisan super flaky dan aroma butter yang langsung menggoda sejak gigitan pertama.',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rp15.000', style: TextStyle(color: Color(0xFF5A3A31), fontWeight: FontWeight.bold, fontSize: 24)),
                      GestureDetector(
                        onTap: () => setState(() => isFavorite = !isFavorite),
                        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : const Color(0xFF6B7280), size: 28),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 24),

                  // Opsi Ukuran
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Ukuran', style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Wajib, Pilih 1', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildRadioOption('Small', '', selectedSize, (val) => setState(() => selectedSize = val!)),
                  _buildRadioOption('Large', '+ Rp 3.000', selectedSize, (val) => setState(() => selectedSize = val!)),

                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 24),

                  // Opsi Sweetness
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Swetness', style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Wajib, Pilih 1', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildRadioOption('Normal sweet', '', selectedSweetness, (val) => setState(() => selectedSweetness = val!)),
                  _buildRadioOption('Less Sweet', '', selectedSweetness, (val) => setState(() => selectedSweetness = val!)),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // BOTTOM BAR CHECKOUT
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              // Quantity Control
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20, color: Color(0xFF6B7280)),
                      onPressed: () { if(quantity > 1) setState(() => quantity--); },
                    ),
                    Text('$quantity', style: const TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFF5A3A31), shape: BoxShape.circle),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                      onPressed: () => setState(() => quantity++),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.grey.shade400),
      child: RadioListTile<String>(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Color(0xFF1F2937), fontSize: 14)),
            if (trailing.isNotEmpty) Text(trailing, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
          ],
        ),
        value: title,
        groupValue: groupValue,
        activeColor: const Color(0xFF3454D1), // Biru figma
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: onChanged,
      ),
    );
  }
}