import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart'; // 🔥 WAJIB HUKUMNYA DIPANGGIL!

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  // 🔥 BEST PRACTICE: State Management Sederhana untuk Tracker
  // 0 = Dibuat, 1 = Dimasak (Pot), 2 = Diantar (Motor), 3 = Tiba (Rumah)
  final int currentStatus = 0;

  @override
  Widget build(BuildContext context) {
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
            // Kembali ke Home bawa state banner aktif
            GoRouter.of(context).go('/home', extra: {'hasActiveOrder': true});
          },
        ),
        title: Text(
          'Rincian Pesanan',
          style: AppTextStyles.h1.copyWith(
            color: AppColors
                .primary, // 🔥 Pake Core: Font otomatis ngikutin Plus Jakarta Sans yang tebal
          ),
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
            const SpaceHeight(4), // 🔥 Pake Core
            Text(
              "Mau coba menu lainnya? Pesan lagi di hana's cake!",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ), // Asumsi core kamu punya textSecondary/abu-abu
            ),
            const SpaceHeight(24),

            // 🔥 PROGRESS TRACKER DINAMIS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                // 🔥 Best Practice UI Timeline
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
                    ),
                    const SpaceWidth(16),
                    // Detail Alamat
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Diambil dari',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SpaceHeight(4),
                          Text(
                            'Jonggol dayeuh',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SpaceHeight(4),
                          Text(
                            'Jl.Sukanegara, No. 99 Dukuh, Kec. seukanegara, Kabupaten Bogor, Jawa Barat, Jonggol , KOTA BOGOR, JAWA BARAT',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SpaceHeight(20),
                          Text(
                            'Diantar ke',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SpaceHeight(4),
                          Text(
                            'Jl.Nakula Sadewa Raya, No. 99 Dukuh, Kec. sidomukti, Kota Salatiga, Jawa Tengah, SIDOMUKTI, KOTA SALATIGA, JAWA TENGAH',
                            style: AppTextStyles.micro.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          const SpaceHeight(8),
                          Text(
                            'Rina - (+62) 888-8888-8888',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
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
                  Row(
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
                                Text('2', style: AppTextStyles.body),
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
                                    'Croissant Mentega',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SpaceHeight(2),
                            Text(
                              'Large',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Rp 15.000',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SpaceHeight(16),
                  const Divider(height: 1, color: AppColors.border),
                  const SpaceHeight(16),

                  // Rincian Biaya
                  _buildPriceRow(
                    'Subtotal Pesanan (2 menu)',
                    'Rp 30.000',
                    isBold: true,
                  ),
                  const SpaceHeight(8),
                  _buildPriceRow(
                    'Biaya Pengiriman',
                    'Rp 7.500',
                    isSubtext: true,
                  ),
                  const SpaceHeight(8),
                  _buildPriceRow('Biaya Layanan', 'Rp 500', isSubtext: true),
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
                            'Rp 38.000',
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

                  _buildInfoRow('Catatan Tambahan', 'Tidak ada'),
                  const SpaceHeight(12),
                  _buildInfoRow('No. Pesanan', '182347827485234987'),
                  const SpaceHeight(12),
                  _buildInfoRow('Waktu Pemesanan', '20 Mei 2026 11:54'),
                  const SpaceHeight(12),
                  _buildInfoRow('Waktu Pembayaran', '20 Mei 2026 12:26'),
                  const SpaceHeight(12),
                  _buildInfoRow('Pembayaran', 'Qris'),

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
                  GoRouter.of(context).push('/checkout');
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

            const SpaceHeight(80), // Jarak aman navbar
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // HELPER WIDGETS DENGAN CORE
  // ─────────────────────────────────────────────────────────

  // 🔥 Tracker Icon Dinamis (Hanya SVG)
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

  // 🔥 Tracker Line Dinamis
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
