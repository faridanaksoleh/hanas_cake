import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart'; // 🔥 WAJIB HUKUMNYA DIPANGGIL!

import 'package:intl/intl.dart';

class OrderDetailPage extends StatefulWidget {
  // 🔥 BEST PRACTICE: Parameter dinamis untuk flow
  final Map<String, dynamic> order;

  const OrderDetailPage({super.key, this.order = const {}});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  // 🔥 BEST PRACTICE: State Management Sederhana untuk Tracker
  // 0 = Dibuat, 1 = Dimasak (Pot), 2 = Diantar/Siap Diambil, 3 = Selesai
  final int currentStatus = 0;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final isPickUp = order['delivery_type'] == 'pickup';

    // Parse harga
    double grandTotal = 0;
    if (order['total'] != null) {
      grandTotal = double.tryParse(order['total'].toString()) ?? 0;
    }
    
    double shippingCost = 0;
    if (order['shipping_price'] != null) {
      shippingCost = double.tryParse(order['shipping_price'].toString()) ?? 0;
    }
    
    final items = order['items'] as List<dynamic>? ?? [];
    
    final subtotalProduk = items.fold<num>(0, (sum, item) {
      final qtyRaw = item['jumlah'];
      final priceRaw = item['harga_satuan'];
      final qty = qtyRaw is int ? qtyRaw : (int.tryParse(qtyRaw?.toString() ?? '1') ?? 1);
      final price = priceRaw is num ? priceRaw : (double.tryParse(priceRaw?.toString() ?? '0') ?? 0);
      return sum + (price * qty);
    }).toDouble();
    
    final taxAndService = grandTotal - (subtotalProduk + shippingCost);

    // Alamat
    String addressName = '';
    String addressDetail = '';
    if (isPickUp) {
      final storeDetails = order['store_details'] ?? {};
      addressName = storeDetails['name'] ?? "Hana's Bakery";
      addressDetail = storeDetails['address'] ?? 'Alamat toko tidak tersedia';
    } else {
      addressName = order['shipping_name'] ?? 'Penerima';
      addressDetail = order['shipping_address'] ?? 'Alamat pengiriman tidak tersedia';
    }
    
    final orderNumber = order['merchant_order_id'] ?? '-';
    
    final createdAt = order['tanggal'] != null 
        ? DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(order['tanggal']).toLocal())
        : '-';
    final status = order['status'] ?? 'Sedang disiapkan';

    return Scaffold(
      backgroundColor: AppColors.surface, // 🔥 Pake Core
      appBar: AppBar(
        backgroundColor: AppColors.white, // 🔥 Pake Core
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primary,
            size: 20,
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        title: Text(
          'Rincian Pesanan',
          style: AppTextStyles.h1.copyWith(color: AppColors.primary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────────────────────
            // 1. HEADER STATUS & TRACKER
            // ─────────────────────────────────────────────────────────
            Text(
              'Pesanan Dibuat',
              style: AppTextStyles.h1.copyWith(fontSize: 22),
            ),
            const SpaceHeight(4),
            Text(
              "Mau coba menu lainnya? Pesan lagi di hana's cake!",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SpaceHeight(24),

            // 🔥 PROGRESS TRACKER DINAMIS (3 Step PickUp, 4 Step Delivery)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: isPickUp
                  ? [
                      _buildProgressIcon(
                        'assets/icons/receipt.svg',
                        currentStatus >= 0,
                      ),
                      _buildProgressLine(currentStatus >= 1),
                      _buildProgressIcon(
                        'assets/icons/cooking_pot.svg',
                        currentStatus >= 1,
                      ),
                      _buildProgressLine(currentStatus >= 2),
                      // Asumsi icon toko adalah store.svg (bisa ganti house.svg jika belum ada)
                      _buildProgressIcon(
                        'assets/icons/house.svg',
                        currentStatus >= 2,
                      ),
                    ]
                  : [
                      _buildProgressIcon(
                        'assets/icons/receipt.svg',
                        currentStatus >= 0,
                      ),
                      _buildProgressLine(currentStatus >= 1),
                      _buildProgressIcon(
                        'assets/icons/cooking_pot.svg',
                        currentStatus >= 1,
                      ),
                      _buildProgressLine(currentStatus >= 2),
                      _buildProgressIcon(
                        'assets/icons/motorcycle.svg',
                        currentStatus >= 2,
                      ),
                      _buildProgressLine(currentStatus >= 3),
                      _buildProgressIcon(
                        'assets/icons/house.svg',
                        currentStatus >= 3,
                      ),
                    ],
            ),
            const SpaceHeight(32),

            // ─────────────────────────────────────────────────────────
            // 2. KARTU LOKASI (Timeline Vertikal Dinamis)
            // ─────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Garis & Titik Indikator
                    Column(
                      children: [
                        const SpaceHeight(4),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        // 🔥 HANYA MUNCUL JIKA DELIVERY
                        if (!isPickUp) ...[
                          Expanded(
                            child: Container(width: 1, color: AppColors.border),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.successText,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SpaceHeight(24),
                        ],
                      ],
                    ),
                    const SpaceWidth(16),
                    // Detail Alamat
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isPickUp
                                ? 'Diambil di'
                                : 'Diambil dari', // 🔥 ADAPTIF
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SpaceHeight(4),
                          Text(
                            isPickUp ? addressName : 'Cabang Utama',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SpaceHeight(4),
                          Text(
                            isPickUp ? addressDetail : 'Jl. Makassar No. 1, Kota Makassar',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),

                          // 🔥 NODE KEDUA: HANYA MUNCUL JIKA DELIVERY
                          if (!isPickUp) ...[
                            const SpaceHeight(20),
                            Text(
                              'Diantar ke',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SpaceHeight(4),
                            Text(
                              addressDetail,
                              style: AppTextStyles.micro.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                            const SpaceHeight(8),
                            Text(
                              addressName,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SpaceHeight(24),

            // ─────────────────────────────────────────────────────────
            // 3. KARTU RINCIAN PESANAN
            // ─────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rincian Pesanan',
                    style: AppTextStyles.h1.copyWith(fontSize: 16),
                  ),
                  const SpaceHeight(16),

                  // Item Menu
                  ...items.map((item) {
                    final productId = item['product_id'];
                    
                    String getProductName(dynamic id) {
                      if (id == 1 || id == '1') return 'Croissant Mentega';
                      if (id == 2 || id == '2') return 'Donut Matcha Cih';
                      if (id == 3 || id == '3') return 'Red Velvet Parfait';
                      if (id == 4 || id == '4') return 'Butter Pastry';
                      return 'Menu Hanas Cake';
                    }
                    
                    final productName = getProductName(productId);
                    final qtyRaw = item['jumlah'];
                    final priceRaw = item['harga_satuan'];
                    final quantity = qtyRaw is int ? qtyRaw : (int.tryParse(qtyRaw?.toString() ?? '1') ?? 1);
                    final price = priceRaw is num ? priceRaw : (double.tryParse(priceRaw?.toString() ?? '0') ?? 0);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primaryMid,
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/croissant.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SpaceWidth(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('$quantity', style: AppTextStyles.body),
                                    const SpaceWidth(4),
                                    Text(
                                      'x',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SpaceWidth(4),
                                    Expanded(
                                      child: Text(
                                        productName,
                                        style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(price * quantity),
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SpaceHeight(16),
                  const Divider(height: 1, color: AppColors.border),
                  const SpaceHeight(16),

                  // Rincian Biaya
                  _buildPriceRow(
                    'Subtotal Pesanan (${items.length} menu)',
                    NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(subtotalProduk),
                    isBold: true,
                  ),
                  const SpaceHeight(8),

                  // 🔥 HILANGKAN BIAYA KIRIM JIKA PICK UP
                  if (!isPickUp) ...[
                    _buildPriceRow(
                      'Biaya Pengiriman',
                      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(shippingCost),
                      isSubtext: true,
                    ),
                    const SpaceHeight(8),
                  ],

                  _buildPriceRow(
                    'Biaya Layanan / Pajak',
                    NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(taxAndService > 0 ? taxAndService : 0),
                    isSubtext: true,
                  ),
                  const SpaceHeight(16),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            // 🔥 TOTAL HARGA ADAPTIF
                            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(grandTotal),
                            style: AppTextStyles.h1.copyWith(fontSize: 16),
                          ),
                          const SpaceHeight(2),
                          Text(
                            'Sudah termasuk pajak',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SpaceHeight(24),

            // ─────────────────────────────────────────────────────────
            // 4. KARTU INFORMASI PESANAN
            // ─────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Pesanan',
                    style: AppTextStyles.h1.copyWith(fontSize: 16),
                  ),
                  const SpaceHeight(16),

                  _buildInfoRow('Catatan Tambahan', order['notes'] ?? 'Tidak ada'),
                  const SpaceHeight(12),
                  _buildInfoRow('No. Pesanan', orderNumber),
                  const SpaceHeight(12),
                  _buildInfoRow('Status', status),
                  const SpaceHeight(12),
                  _buildInfoRow('Waktu Pemesanan', createdAt),
                  const SpaceHeight(12),
                  _buildInfoRow('Pembayaran', order['payment_method'] ?? 'Online Payment'),

                  const SpaceHeight(16),
                  const Divider(height: 1, color: AppColors.border),
                  const SpaceHeight(16),

                  Text(
                    'Kebijakan Pengembalian',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceHeight(8),
                  Text(
                    'Kamu tidak dapat melakukan pengembalian atau perubahan apapun pada pesanan setelah melakukan pembayaran.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(32),

            // ─────────────────────────────────────────────────────────
            // 5. TOMBOL PESAN LAGI
            // ─────────────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // 🔥 Membawa parameter isPickUp jika pesan lagi
                  GoRouter.of(
                    context,
                  ).push('/checkout', extra: {'isPickUp': isPickUp});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Pesan lagi',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SpaceHeight(80),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // HELPER WIDGETS
  // ─────────────────────────────────────────────────────────

  Widget _buildProgressIcon(String svgPath, bool isActive) {
    return SvgPicture.asset(
      svgPath,
      width: 24,
      colorFilter: ColorFilter.mode(
        isActive ? AppColors.primary : AppColors.border,
        BlendMode.srcIn,
      ),
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isActive ? AppColors.primary : AppColors.border,
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String price, {
    bool isBold = false,
    bool isSubtext = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isSubtext
              ? AppTextStyles.caption.copyWith(color: AppColors.textSecondary)
              : AppTextStyles.bodySmall.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
        ),
        Text(
          price,
          style: isSubtext
              ? AppTextStyles.caption.copyWith(color: AppColors.textSecondary)
              : AppTextStyles.bodySmall.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
