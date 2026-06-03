import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanas_cake/core/core.dart';
import 'package:intl/intl.dart';
import '../blocs/order_history/order_history_bloc.dart';
import '../blocs/order_history/order_history_event.dart';
import '../blocs/order_history/order_history_state.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // 🔥 Ubah jadi true untuk tes tampilan "Belum Ada Riwayat Pesanan"
  bool isEmpty = false;

  String filterTipe = 'Semua';
  String filterUrutan = 'Terbaru';

  @override
  void initState() {
    super.initState();
    context.read<OrderHistoryBloc>().add(FetchOrderHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primary,
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
        title: Text(
          'Riwayat Pesanan',
          style: AppTextStyles.h1.copyWith(color: AppColors.primary),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await GoRouter.of(context).push('/order/filter');
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  filterTipe = result['tipe'] as String? ?? 'Semua';
                  filterUrutan = result['urutan'] as String? ?? 'Terbaru';
                });
              }
            },
            icon: SvgPicture.asset(
              'assets/icons/sliders_outline.svg',
              width: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SpaceWidth(8),
        ],
      ),
      body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
        builder: (context, state) {
          if (state is OrderHistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is OrderHistoryLoaded) {
            var filteredOrders = state.orders.where((order) {
              if (filterTipe == 'Semua') return true;
              
              final deliveryType = order['delivery_type']?.toString().toLowerCase() ?? '';
              
              if (filterTipe == 'Pick Up') return deliveryType == 'pickup' || deliveryType == 'pick up';
              if (filterTipe == 'Delivery') return deliveryType == 'delivery';
              if (filterTipe == 'Pemesanan di store') return deliveryType == 'store' || deliveryType == 'dine-in' || deliveryType == 'dine_in';
              if (filterTipe == 'Pemesanan via Aplikasi') return deliveryType != 'store' && deliveryType != 'dine-in' && deliveryType != 'dine_in';
              
              return true;
            }).toList();

            filteredOrders.sort((a, b) {
              final dateA = a['tanggal'] != null ? DateTime.tryParse(a['tanggal'].toString()) ?? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.fromMillisecondsSinceEpoch(0);
              final dateB = b['tanggal'] != null ? DateTime.tryParse(b['tanggal'].toString()) ?? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.fromMillisecondsSinceEpoch(0);
              if (filterUrutan == 'Terlama') {
                return dateA.compareTo(dateB);
              } else {
                return dateB.compareTo(dateA);
              }
            });

            if (filteredOrders.isEmpty) {
              return _buildEmptyState();
            }
            return _buildOrderList(filteredOrders);
          } else if (state is OrderHistoryError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Belum Ada Riwayat Pesanan',
        style: AppTextStyles.body.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOrderList(List<dynamic> orders) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SpaceHeight(16),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order: order);
      },
    );
  }

  // 🔥 FUNGSI BUILDER KARTU DINAMIS
  Widget _buildOrderCard({required dynamic order}) {
    final status = order['status'] ?? 'Sedang disiapkan';
    final isPickUp = order['delivery_type'] == 'pickup';
    
    // Parse total from String to double
    double grandTotal = 0;
    if (order['total'] != null) {
      grandTotal = double.tryParse(order['total'].toString()) ?? 0;
    }

    final items = order['items'] as List<dynamic>? ?? [];
    final title = order['merchant_order_id'] ?? 'Pesanan';
    
    final totalItems = items.fold<int>(0, (sum, item) {
      final jumlah = item['jumlah'];
      if (jumlah is int) return sum + jumlah;
      if (jumlah is String) return sum + (int.tryParse(jumlah) ?? 1);
      return sum + 1;
    });

    final createdAt = order['tanggal'] != null 
        ? DateFormat('dd MMM yyyy').format(DateTime.parse(order['tanggal']).toLocal())
        : 'Hari ini';

    return GestureDetector(
      // 🔥 FIX: Mengirim seluruh data order melalui extra
      onTap: () {
        // Karena route di main.dart adalah /order/detail, maka:
        GoRouter.of(context).push('/order/detail', extra: order);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
            bottom: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SpaceWidth(8),
                    Text(
                      createdAt,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SpaceHeight(12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/croissant.png',
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormat.currency(
                        locale: 'id',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(grandTotal),
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SpaceHeight(2),
                    Text(
                      '$totalItems menu',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SpaceHeight(12),
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            const SpaceHeight(12),

            // 🔥 BOTTOM ROW (STATUS, METODE, TOMBOL)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Pesanan (Sedang disiapkan / Selesai)
                Text(
                  status,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                // Indikator Metode & Tombol
                Row(
                  children: [
                    // 🔥 ICON & TEKS ADAPTIF (Moped vs Tote)
                    SvgPicture.asset(
                      isPickUp
                          ? 'assets/icons/tote_simple.svg'
                          : 'assets/icons/moped.svg',
                      width: 16,
                      // Hapus colorFilter agar ikon moped.svg kembali ke warna aslinya (biru)
                      colorFilter: isPickUp ? const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ) : null,
                    ),
                    const SpaceWidth(4),
                    Text(
                      isPickUp ? 'Pick Up' : 'Delivery',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceWidth(12),

                    // Tombol Pesan Lagi
                    ElevatedButton(
                      onPressed: () {
                        // Arahkan ke Checkout dengan metode yang sama
                        GoRouter.of(
                          context,
                        ).push('/checkout', extra: {'isPickUp': isPickUp});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 36),
                        elevation: 0,
                      ),
                      child: Text(
                        'Pesan lagi',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
