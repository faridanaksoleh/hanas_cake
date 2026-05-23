import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

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
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
                  const SpaceHeight(24),
                  Text('Pilih Metode Pemesanan', style: AppTextStyles.h2.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const SpaceHeight(24),
                  
                  _buildMethodOption(
                    title: 'Pick Up',
                    subtitle: 'Ambil di Store tanpa antri',
                    imagePath: 'assets/images/home_pickup.png',
                    isSelected: selectedMethod == 'Pick Up',
                    onTap: () {
                      setModalState(() => selectedMethod = 'Pick Up');
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
                    isSelected: selectedMethod == 'Delivery',
                    onTap: () {
                      setModalState(() => selectedMethod = 'Delivery');
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(bottomSheetContext); 
                      });
                    },
                  ),
                  const SpaceHeight(32),
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
            const SpaceWidth(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                  const SpaceHeight(4),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppColors.secondary : AppColors.border),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              GoRouter.of(context).go('/home');
            }
          },
        ),
        title: Text(
          'Checkout',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
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
              color: AppColors.primaryMid, 
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.asset('assets/images/home_delivery.png', width: 60, height: 60, fit: BoxFit.contain),
                  const SpaceWidth(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delivery', style: AppTextStyles.h2.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        const SpaceHeight(4),
                        Text('Garansi tepat waktu, dijamin!', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _showOrderMethodBottomSheet(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primary, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      elevation: 0,
                    ),
                    child: Text('Ubah', style: AppTextStyles.bodySmall.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
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
                  Text('Detail Pesanan', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                  const SpaceHeight(16),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Croissant Mentega', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600)),
                            const SpaceHeight(4),
                            Text('Large', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primaryMid, 
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/croissant.png'), 
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpaceHeight(16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rp 15.000', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {}, 
                            child: Text('Ubah', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ),
                          const SpaceWidth(16),
                          
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () { if(quantity > 1) setState(() => quantity--); },
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: const Icon(Icons.remove, size: 16, color: AppColors.textPrimary),
                                ),
                              ),
                              const SpaceWidth(12),
                              Text('$quantity', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                              const SpaceWidth(12),
                              GestureDetector(
                                onTap: () => setState(() => quantity++),
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add, size: 16, color: AppColors.white),
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
            
            const Divider(height: 1, thickness: 4, color: AppColors.surface),

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
                      children: [
                        Text('Ada tambahan lagi?', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        const SpaceHeight(4),
                        Text('Kamu masih bisa tambahin menu lain, ya.', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      GoRouter.of(context).push('/delivery', extra: {'isFromCart': true});
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text('Tambah', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 4, color: AppColors.surface),

            // ─────────────────────────────────────────────────────────
            // 4. TAS BELANJA
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/shop_bag.svg', 
                    width: 40, 
                    height: 40,
                  ),
                  const SpaceWidth(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tas belanja', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        const SpaceHeight(4),
                        Text('Ditambahkan otomatis untuk pembelian delivery', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 4, color: AppColors.surface),

            // ─────────────────────────────────────────────────────────
            // 5. METODE PEMBAYARAN
            // ─────────────────────────────────────────────────────────
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => GoRouter.of(context).push('/payment-method'),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Metode Pemabayaran', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                    const SpaceHeight(16),
                    Row(
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Center(
                            child: Image.asset('assets/icons/qris.png', width: 20, height: 20, fit: BoxFit.contain),
                          ),
                        ),
                        const SpaceWidth(12),
                        Expanded(
                          child: Text('QRIS', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, thickness: 4, color: AppColors.surface),

            // ─────────────────────────────────────────────────────────
            // 6. RINCIAN PEMBAYARAN & KEBIJAKAN
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rincian Pembayaran', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                  const SpaceHeight(16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Harga', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      Text('Rp 30.000', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SpaceHeight(12),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tas belanja', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      Text('Rp 3.000', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SpaceHeight(16),
                  const Divider(height: 1, thickness: 1, color: AppColors.border),
                  const SpaceHeight(16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Pembayaran', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                      Text('Rp 33.000', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),

                  const SpaceHeight(32),

                  Text('Kebijakan Pembatalan', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                  const SpaceHeight(8),
                  Text(
                    'Kamu tidak dapat melakukan pembatalan atau perubahan apapun pada pesanan setelah melakukan pembayaran',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, height: 1.5),
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
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/payment-success'); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Pesan Sekarang', style: AppTextStyles.h3.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}