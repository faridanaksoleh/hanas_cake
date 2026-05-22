import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int quantity = 2;

  // 🔥 FUNGSI POPUP GANTI METODE PEMESANAN
  void _showOrderMethodBottomSheet(BuildContext context) {
    String selectedMethod = 'Delivery'; 

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFF9CA3AF), borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 24),
                  const Text('Pilih Metode Pemesanan', style: TextStyle(color: Color(0xFF5A3A31), fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  _buildMethodOption(
                    title: 'Pick Up',
                    subtitle: 'Ambil di Store tanpa antri',
                    imagePath: 'assets/images/home_pickup.png',
                    isSelected: selectedMethod == 'Pick Up',
                    onTap: () {
                      setModalState(() => selectedMethod = 'Pick Up');
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(bottomSheetContext);
                        context.pushReplacement('/pickup'); 
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildMethodOption(
                    title: 'Delivery',
                    subtitle: 'Garansi tepat waktu, dijamin!',
                    imagePath: 'assets/images/home_delivery.png',
                    isSelected: selectedMethod == 'Delivery',
                    onTap: () {
                      setModalState(() => selectedMethod = 'Delivery');
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(bottomSheetContext); 
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildMethodOption({required String title, required String subtitle, required String imagePath, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Image.asset(imagePath, width: 48, height: 60, fit: BoxFit.contain),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                ],
              ),
            ),
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? const Color(0xFF3454D1) : Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF5A3A31), size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text(
          'Checkout',
          // 🔥 REVISI: Balik ke standar H1 (Semi-bold, ukuran 18) biar konsisten!
          style: TextStyle(color: Color(0xFF5A3A31), fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────────────────────
            // 1. BANNER METODE (Delivery)
            // ─────────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              color: const Color(0xFFEDD8D0), 
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.asset('assets/images/home_delivery.png', width: 60, height: 60, fit: BoxFit.contain),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Delivery', style: TextStyle(color: Color(0xFF5A3A31), fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Garansi tepat waktu, dijamin!', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _showOrderMethodBottomSheet(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A3A31), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text('Ubah', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            
            // ─────────────────────────────────────────────────────────
            // 2. DETAIL PESANAN
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detail Pesanan', style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Croissant Mentega', style: TextStyle(color: Color(0xFF1F2937), fontSize: 15, fontWeight: FontWeight.w600)),
                            SizedBox(height: 4),
                            Text('Large', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDD8D0), 
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/croissant.png'), 
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rp 15.000', style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {}, 
                            child: const Text('Ubah', style: TextStyle(color: Color(0xFF5A3A31), fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 16),
                          
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () { if(quantity > 1) setState(() => quantity--); },
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFD1D5DB)),
                                  ),
                                  child: const Icon(Icons.remove, size: 16, color: Color(0xFF1F2937)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('$quantity', style: const TextStyle(color: Color(0xFF1F2937), fontSize: 15, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => setState(() => quantity++),
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF5A3A31),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1, thickness: 4, color: Color(0xFFF3F4F6)),

            // ─────────────────────────────────────────────────────────
            // 3. TAMBAH MENU LAIN
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Ada tambahan lagi?', style: TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Kamu masih bisa tambahin menu lain, ya.', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push('/delivery', extra: {'isFromCart': true});
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF5A3A31)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Tambah', style: TextStyle(color: Color(0xFF5A3A31), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 4, color: Color(0xFFF3F4F6)),

            // ─────────────────────────────────────────────────────────
            // 4. TAS BELANJA
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // 🔥 REVISI: Container dihapus! Langsung panggil SVG-nya biar nggak kekecilan.
                  SvgPicture.asset(
                    'assets/icons/shop_bag.svg', 
                    width: 40, 
                    height: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Tas belanja', style: TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Ditambahkan otomatis untuk pembelian delivery', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 4, color: Color(0xFFF3F4F6)),

            // ─────────────────────────────────────────────────────────
            // 5. METODE PEMBAYARAN
            // ─────────────────────────────────────────────────────────
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.push('/payment-method'),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Metode Pemabayaran', style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD1D5DB)),
                          ),
                          child: Center(
                            child: Image.asset('assets/icons/qris.png', width: 20, height: 20, fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('QRIS', style: TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF6B7280)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, thickness: 4, color: Color(0xFFF3F4F6)),

            // ─────────────────────────────────────────────────────────
            // 6. RINCIAN PEMBAYARAN & KEBIJAKAN
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rincian Pembayaran', style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Harga', style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                      Text('Rp 30.000', style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Tas belanja', style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                      Text('Rp 3.000', style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Total Pembayaran', style: TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('Rp 33.000', style: TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  const SizedBox(height: 32),

                  const Text('Kebijakan Pembatalan', style: TextStyle(color: Color(0xFF1F2937), fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Kamu tidak dapat melakukan pembatalan atau perubahan apapun pada pesanan setelah melakukan pembayaran',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // ─────────────────────────────────────────────────────────
      // 7. BOTTOM ACTION BUTTON
      // ─────────────────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                context.push('/payment-success'); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A3A31),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Pesan Sekarang', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}