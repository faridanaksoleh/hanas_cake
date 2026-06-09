import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Untuk CupertinoSwitch
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:hanas_cake/core/core.dart';
import '../blocs/checkout/checkout_bloc.dart';
import '../blocs/checkout/checkout_event.dart';
import '../blocs/checkout/checkout_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/address/address_bloc.dart';
import '../blocs/address/address_event.dart';
import '../blocs/address/address_state.dart';
import '../../domain/entities/address.dart';
import '../pages/branch_list_page.dart';

class CheckoutPage extends StatefulWidget {
  final bool isPickUp;
  final BranchItem? location;
  const CheckoutPage({super.key, this.isPickUp = false, this.location});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int quantity = 2;
  bool isBagChecked = false; // State khusus toggle tas belanja Pick Up

  // 🔥 BEST PRACTICE: State Lokal untuk nahan user tetap di halaman
  late bool _isPickUpLocal;
  BranchItem? currentBranch;

  @override
  void initState() {
    super.initState();
    // Set awal dari halaman sebelumnya
    _isPickUpLocal = widget.isPickUp;
    currentBranch = widget.location;
    // Panggil address event
    context.read<AddressBloc>().add(GetAddressesEvent());
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  // 🔥 FUNGSI POPUP GANTI METODE PEMESANAN (STATE LOKAL)
  void _showOrderMethodBottomSheet(BuildContext context) {
    String selectedMethod = _isPickUpLocal ? 'Pick Up' : 'Delivery';

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
                    isSelected: selectedMethod == 'Pick Up',
                    onTap: () {
                      setModalState(() => selectedMethod = 'Pick Up');
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(bottomSheetContext);
                        // 🔥 FIX: Cukup SetState, tanpa pindah halaman!
                        if (!_isPickUpLocal) {
                          setState(() {
                            _isPickUpLocal = true;
                          });
                        }
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
                        // 🔥 FIX: Cukup SetState, tanpa pindah halaman!
                        if (_isPickUpLocal) {
                          setState(() {
                            _isPickUpLocal = false;
                          });
                        }
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
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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
                  Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceHeight(4),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.secondary : AppColors.border,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) async {
        if (state is CheckoutLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        } else if (state is CheckoutError) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is CheckoutSuccess) {
          Navigator.pop(context); // Close loading dialog
          final midtrans = await MidtransSDK.init(
            config: MidtransConfig(
              clientKey: 'SB-Mid-client-tgtMCpKtxtZT3ePk',
              merchantBaseUrl: 'https://hanascake.syauqiebill.my.id/api/',
            ),
          );
          
          midtrans.setTransactionFinishedCallback((result) {
            context.read<CartBloc>().add(ClearCartEvent());
            GoRouter.of(context).go('/payment-success', extra: {'isPickUp': widget.isPickUp});
          });

          midtrans.startPaymentUiFlow(token: state.snapToken);
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
        return Scaffold(
          backgroundColor: AppColors.white,
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
                  GoRouter.of(context).go(_isPickUpLocal ? '/pickup' : '/home');
                }
              },
            ),
            title: Text(
              'Checkout',
              style: AppTextStyles.h1.copyWith(color: AppColors.primary),
            ),
          ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────────────────────
            // 1. BANNER METODE (ADAPTIF)
            // ─────────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              // 🔥 FIX: Sesuai Request Pakai primaryLight
              color: _isPickUpLocal
                  ? AppColors.primaryLight
                  : AppColors.primaryMid,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.asset(
                    // 🔥 FIX: Sesuai Request Pakai home_pickup.png
                    _isPickUpLocal
                        ? 'assets/images/home_pickup.png'
                        : 'assets/images/home_delivery.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  const SpaceWidth(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isPickUpLocal ? 'Pick Up' : 'Delivery',
                          style: AppTextStyles.h2.copyWith(
                            color: _isPickUpLocal
                                ? AppColors.white
                                : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SpaceHeight(4),
                        Text(
                          _isPickUpLocal
                              ? 'Ambil di Store tanpa antri'
                              : 'Garansi tepat waktu, dijamin!',
                          style: AppTextStyles.caption.copyWith(
                            color: _isPickUpLocal
                                ? AppColors.white.withOpacity(0.8)
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _showOrderMethodBottomSheet(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _isPickUpLocal
                          ? AppColors.white
                          : AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Ubah',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _isPickUpLocal
                            ? AppColors.primary
                            : AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─────────────────────────────────────────────────────────
            // 2. LOKASI AMBIL PESANAN (KHUSUS PICK UP)
            // ─────────────────────────────────────────────────────────
            if (_isPickUpLocal) ...[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ambil pesananmu di',
                          style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await GoRouter.of(context).push('/branch-list', extra: {'isPickUp': true});
                            if (result != null && result is BranchItem) {
                              setState(() {
                                currentBranch = result;
                              });
                            }
                          },
                          child: Text(
                            currentBranch != null ? 'Ubah' : 'Pilih Lokasi',
                            style: AppTextStyles.caption.copyWith(
                              color: currentBranch != null ? AppColors.primary : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SpaceHeight(16),
                    Row(
                      children: [
                        // 🔥 FIX: SVG murni tanpa border/background
                        SvgPicture.asset(
                          'assets/icons/branch2.svg',
                          width: 44,
                          height: 44,
                        ),
                        const SpaceWidth(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentBranch?.name ?? 'Silakan pilih cabang toko terlebih dahulu',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: currentBranch == null ? Colors.red : AppColors.textPrimary,
                                ),
                              ),
                              const SpaceHeight(4),
                              if (currentBranch != null)
                                Text(
                                  '${currentBranch!.distanceKm} km dari lokasimu',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SpaceHeight(16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_filled,
                            color: AppColors.successText,
                            size: 18,
                          ),
                          const SpaceWidth(8),
                          Text(
                            'Estimasi siap diambil dalam 10 menit',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.successText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 4, color: AppColors.surface),
            ] else ...[
              // WIRING ALAMAT PENGIRIMAN
              BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state) {
                  Address? primaryAddress;
                  if (state is AddressLoaded) {
                    try {
                      primaryAddress = state.addresses.firstWhere((a) => a.isPrimary);
                    } catch (e) {
                      if (state.addresses.isNotEmpty) {
                        primaryAddress = state.addresses.first;
                      }
                    }
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Alamat Pengiriman',
                              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => GoRouter.of(context).push('/saved-address'),
                              child: Text(
                                primaryAddress != null ? 'Ubah' : 'Tambah',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(16),
                        if (primaryAddress != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppColors.primary, size: 24),
                              const SpaceWidth(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${primaryAddress.receiverName} | ${primaryAddress.phoneNumber}',
                                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SpaceHeight(4),
                                    Text(
                                      primaryAddress.fullAddress,
                                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Text(
                            'Silakan pilih/tambah alamat pengiriman',
                            style: AppTextStyles.body.copyWith(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const Divider(height: 1, thickness: 4, color: AppColors.surface),
            ],

            // ─────────────────────────────────────────────────────────
            // 3. DETAIL PESANAN
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Pesanan',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceHeight(16),

                  ...cartState.items.map((item) {
                    final product = item.product;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: AppTextStyles.h3.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SpaceHeight(4),
                                  if (item.notes != null && item.notes!.isNotEmpty)
                                    Text(
                                      item.notes!,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.primaryMid,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(product.imageUrl),
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
                            Text(
                              _formatPrice(product.price * item.quantity),
                              style: AppTextStyles.h3.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (item.quantity > 1) {
                                      context.read<CartBloc>().add(UpdateCartItemQuantityEvent(product.id, item.quantity - 1));
                                    } else {
                                      context.read<CartBloc>().add(RemoveFromCartEvent(product.id));
                                    }
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
                                  '${item.quantity}',
                                  style: AppTextStyles.h3.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SpaceWidth(12),
                                GestureDetector(
                                  onTap: () {
                                    context.read<CartBloc>().add(UpdateCartItemQuantityEvent(product.id, item.quantity + 1));
                                  },
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
                          ],
                        ),
                        const SpaceHeight(24),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 4, color: AppColors.surface),

            // ─────────────────────────────────────────────────────────
            // 4. TAMBAH MENU LAIN
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ada tambahan lagi?',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SpaceHeight(4),
                        Text(
                          'Kamu masih bisa tambahin menu lain, ya.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      'Tambah',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 4, color: AppColors.surface),

            // ─────────────────────────────────────────────────────────
            // 5. TAS BELANJA (ADAPTIF TOGGLE/TEKS)
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // 🔥 FIX: SVG murni tanpa border/background
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
                        Text(
                          _isPickUpLocal ? 'Perlu tas belanja' : 'Tas belanja',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SpaceHeight(4),
                        Text(
                          _isPickUpLocal
                              ? 'Rp 3.000'
                              : 'Ditambahkan otomatis untuk pembelian delivery',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isPickUpLocal)
                    CupertinoSwitch(
                      value: isBagChecked,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => isBagChecked = val),
                    ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 4, color: AppColors.surface),

            // ─────────────────────────────────────────────────────────
            // 6. METODE PEMBAYARAN
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metode Pembayaran',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceHeight(16),
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: Icon(Icons.credit_card, size: 16, color: AppColors.primary),
                        ),
                      ),
                      const SpaceWidth(12),
                      Expanded(
                        child: Text(
                          'Midtrans Payment Gateway',
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

            const Divider(height: 1, thickness: 4, color: AppColors.surface),

            // ─────────────────────────────────────────────────────────
            // 7. RINCIAN PEMBAYARAN
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rincian Pembayaran',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceHeight(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Harga',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        _formatPrice(cartState.grandTotal),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SpaceHeight(12),
                  // 🔥 LOGIC: Tas Belanja terhitung jika Pick Up Toggle Aktif ATAU jika Delivery
                  if (!_isPickUpLocal || isBagChecked) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tas belanja',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'Rp 3.000',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SpaceHeight(16),
                  ],
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.border,
                  ),
                  const SpaceHeight(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatPrice(cartState.grandTotal + (!_isPickUpLocal || isBagChecked ? 3000 : 0)),
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SpaceHeight(32),
                  Text(
                    'Kebijakan Pembatalan',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceHeight(8),
                  Text(
                    'Kamu tidak dapat melakukan pembatalan atau perubahan apapun pada pesanan setelah melakukan pembayaran',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

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
                final state = context.read<CartBloc>().state;
                final addressState = context.read<AddressBloc>().state;
                int? addressId;
                if (!_isPickUpLocal && addressState is AddressLoaded) {
                  try {
                    addressId = addressState.addresses.firstWhere((a) => a.isPrimary).id;
                  } catch (e) {
                    if (addressState.addresses.isNotEmpty) {
                      addressId = addressState.addresses.first.id;
                    }
                  }
                }

                final payload = {
                  'delivery_type': _isPickUpLocal ? 'pickup' : 'delivery',
                  'store_id': 1, // Sesuai instruksi hardcode 1
                  if (!_isPickUpLocal && addressId != null) 'address_id': addressId,
                  'total_belanja': state.grandTotal + (!_isPickUpLocal || isBagChecked ? 3000 : 0),
                  'items': state.items.map((item) => {
                    'product_id': item.product.id,
                    'quantity': item.quantity,
                    'price': item.product.price,
                  }).toList(),
                };

                debugPrint('PAYLOAD CHECKOUT: $payload');
                context.read<CheckoutBloc>().add(SubmitCheckoutEvent(payload));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Pesan Sekarang',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
        },
      ),
    );
  }
}
