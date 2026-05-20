import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/presentation/pages/branch_list_page.dart';
import 'package:hanas_cake/presentation/pages/location_picker_page.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  BranchItem? selectedBranch;
  DeliveryLocation? selectedLocation;

  // Key untuk target scroll fitur filter "Semua"
  final GlobalKey _semuaSectionKey = GlobalKey();

  // State untuk menyimpan item yang di-favorit-kan berdasarkan ID Unik
  Set<String> favoriteItems = {};

  void toggleFavorite(String id) {
    setState(() {
      if (favoriteItems.contains(id)) {
        favoriteItems.remove(id);
      } else {
        favoriteItems.add(id);
      }
    });
  }

  void scrollToSemua() {
    if (_semuaSectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        _semuaSectionKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // 🔥 FUNGSI SAKTI POP-UP BOTTOM SHEET
  void _showOrderMethodBottomSheet(BuildContext context) {
    String selectedMethod = 'Delivery'; // Default pilihan

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        // StatefulBuilder agar Radio Button bisa diklik dan update UI pop-up
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle atas (garis abu-abu)
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9CA3AF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Judul Pop Up
                  const Text(
                    'Pilih Metode Pemesanan',
                    style: TextStyle(
                      color: Color(0xFF5A3A31),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ──────── OPTION: PICK UP ────────
                  _buildMethodOption(
                    title: 'Pick Up',
                    subtitle: 'Ambil di Store tanpa antri',
                    imagePath: 'assets/images/home_pickup.png',
                    value: 'Pick Up',
                    groupValue: selectedMethod,
                    onChanged: (val) {
                      setModalState(() => selectedMethod = val!);
                    },
                  ),
                  
                  const SizedBox(height: 16),

                  // ──────── OPTION: DELIVERY ────────
                  _buildMethodOption(
                    title: 'Delivery',
                    subtitle: 'Garansi tepat waktu, dijamin!',
                    imagePath: 'assets/images/home_delivery.png',
                    value: 'Delivery',
                    groupValue: selectedMethod,
                    onChanged: (val) {
                      setModalState(() => selectedMethod = val!);
                    },
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // HELPER WIDGET UNTUK ISI POP UP
  Widget _buildMethodOption({
    required String title,
    required String subtitle,
    required String imagePath,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
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
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              activeColor: const Color(0xFF5A3A31),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADLINE AREA
            Container(
              width: double.infinity,
              color: const Color(0xFFEDD8D0),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF7A5248), size: 20),
                        onPressed: () {
                          if (GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          } else {
                            GoRouter.of(context).go('/home');
                          }
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.search, color: Color(0xFF7A5248), size: 28),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    
                    Container(
                      width: double.infinity,
                      height: 147,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(color: Color(0xFFEDD8D0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 126.47,
                            height: 147,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/half_deliv.png"),
                                fit: BoxFit.contain, 
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Delivery',
                                      style: TextStyle(
                                        color: Color(0xFF7A5248),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        height: 1.20,
                                        letterSpacing: -0.66,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 116.16,
                                      child: const Text(
                                        'Garansi tepat waktu, dijamin!',
                                        style: TextStyle(
                                          color: Color(0xFF7A5248),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          height: 1.30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => _showOrderMethodBottomSheet(context),
                                  child: Container(
                                    width: 82,
                                    height: 41,
                                    padding: const EdgeInsets.all(10),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF4EDE9),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(width: 1, color: Color(0xFF5A3A31)),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Ubah',
                                        style: TextStyle(
                                          color: Color(0xFF5A3A31),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Pesananmu dikirim dari',
                      style: TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 🔥 BRANCH SELECTION - SUDAH AKTIF
                  GestureDetector(
                    onTap: () async {
                      final selected = await context.push<BranchItem>('/branch-list');
                      if (selected != null) {
                        setState(() => selectedBranch = selected);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset('assets/icons/branch.svg', width: 42),
                            _buildVerticalDashedLine(),
                            SvgPicture.asset('assets/icons/address.svg', width: 42),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                selectedBranch?.name ?? 'Alamat Cabang terdekat',
                                style: const TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                selectedBranch != null ? selectedBranch!.address : '-dari lokasimu',
                                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 18),
                              const Divider(height: 1, thickness: 1, color: Color(0xFFD1D5DB)),
                              const SizedBox(height: 18),
                              
                              GestureDetector(
                                onTap: () async {
                                  final selected = await context.push<DeliveryLocation>('/location-picker');
                                  if (selected != null) {
                                    setState(() => selectedLocation = selected);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedLocation?.address ?? 'Pilih alamatmu terlebih dahulu',
                                        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13, fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF6B7280)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),

            // FAVORITE & MUST TRY
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Favorite',
                          style: TextStyle(color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.36),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/my-favorite'),
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(color: Color(0xFF3454D1), fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildHorizontalDashedLine()),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 116,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      children: [
                        _buildFavoriteCard('fav_1', 'Croissant mentega', 'Croissant mentega premium ...', 'Rp15.000', 'assets/images/croissant_mentega.png'),
                        _buildFavoriteCard('fav_2', 'Donut Matcha cih', 'Donut Matcha premium ...', 'Rp15.000', 'assets/images/donut_matcha_cih.png'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          padding: const EdgeInsets.all(8),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF5A3A31),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Center(
                            child: Text('⭐', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: scrollToSemua,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFF6B7280)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Semua', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEEF2FF),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Color(0xFF3454D1)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Roti', style: TextStyle(color: Color(0xFF3454D1), fontSize: 11, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(width: 12),
                        _buildInactiveFilter('Pastri'),
                        const SizedBox(width: 12),
                        _buildInactiveFilter('Kue'),
                        const SizedBox(width: 12),
                        _buildInactiveFilter('Minuman'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('⭐ ', style: TextStyle(fontSize: 20)),
                            Text(
                              'Must Try!',
                              style: TextStyle(color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.36),
                            ),
                          ],
                        ),
                        Text('6 item', style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildHorizontalDashedLine()),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildGridCard('try_1', 'assets/icons/best_seller.svg', 'Pastri', 'Croissant Mentega', 'Rp15.000', 'assets/images/croissant_mentega.png'),
                        _buildGridCard('try_2', 'assets/icons/top_ordered.svg', 'Pastri', 'Donut Mactha cih', 'Rp15.000', 'assets/images/donut_matcha_cih.png'),
                        _buildGridCard('try_3', 'assets/icons/most_popular.svg', 'Kue', 'Red Velvet Parfait', 'Rp15.000', 'assets/images/red_velvet_parfait.png'),
                        _buildGridCard('try_4', 'assets/icons/most_popular.svg', 'Kue', 'Molen Bandung', 'Rp15.000', 'assets/images/molen_bandung.png'),
                        _buildGridCard('try_5', 'assets/icons/most_popular.svg', 'Pastri', 'Butter Pastry', 'Rp15.000', 'assets/images/butter_pastry.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // SEMUA MENU
            Container(
              key: _semuaSectionKey, 
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Semua', style: TextStyle(color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.w600)),
                      Text('3 item', style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildHorizontalDashedLine(),
                  const SizedBox(height: 16),
                  
                  _buildSemuaListCard('semua_1', 'assets/icons/most_popular.svg', 'Croissant mentega', 'Croissant mentega premium dengan lapisan...', 'Rp15.000', 'assets/images/croissant_mentega.png'),
                  const SizedBox(height: 24),
                  _buildSemuaListCard('semua_2', 'assets/icons/most_popular.svg', 'Donut Matcha cih', 'Donut Matcha premium dengan lapisan...', 'Rp15.000', 'assets/images/donut_matcha_cih.png'),
                  const SizedBox(height: 24),
                  _buildSemuaListCard('semua_3', 'assets/icons/most_popular.svg', 'Red Velvet Parfait', 'Red Velvet Parfait premium dengan lapisan...', 'Rp15.000', 'assets/images/red_velvet_parfait.png'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // HELPER WIDGETS
  Widget _buildVerticalDashedLine() {
    return Column(
      children: List.generate(
        6,
        (index) => Container(
          width: 1.5,
          height: 3,
          margin: const EdgeInsets.symmetric(vertical: 2),
          color: const Color(0xFF9CA3AF),
        ),
      ),
    );
  }

  Widget _buildHorizontalDashedLine() {
    return Row(
      children: List.generate(
        45,
        (index) => Expanded(
          child: Container(
            height: 1,
            color: index % 2 == 0 ? const Color(0xFFD1D5DB) : Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildInactiveFilter(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: ShapeDecoration(
        color: const Color(0xFFD1D5DB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildFavoriteCard(String id, String name, String subtitle, String price, String imagePath) {
    final isFav = favoriteItems.contains(id);
    return Container(
      width: 358,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 88, height: 88,
            decoration: ShapeDecoration(
              color: const Color(0xFFEDD8D0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(color: Color(0xFF1F2937), fontSize: 15, fontWeight: FontWeight.w600), maxLines: 1),
                          Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11), maxLines: 1),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => toggleFavorite(id),
                      child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : const Color(0xFFD1D5DB), size: 24),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(color: Color(0xFF7A5248), fontSize: 18, fontWeight: FontWeight.w600)),
                    Container(
                      width: 29, height: 28,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF5A3A31),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(String id, String badgeAsset, String category, String name, String price, String imagePath) {
    return Container(
      width: 171, 
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 171, height: 132,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF3F4F6),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover, 
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                ),
              ),
              Positioned(top: 11, left: 8, child: SvgPicture.asset(badgeAsset, height: 24)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                Text(name, style: const TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(color: Color(0xFF7A5248), fontSize: 14, fontWeight: FontWeight.w600)),
                    Container(
                      width: 29, height: 28,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF5A3A31),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemuaListCard(String id, String badgeAsset, String name, String subtitle, String priceString, String imagePath) {
    final isFav = favoriteItems.contains(id);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: 100, height: 100,
              decoration: ShapeDecoration(
                color: const Color(0xFFEDD8D0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.contain),
              ),
            ),
            Positioned(top: 6, left: 6, child: SvgPicture.asset(badgeAsset, height: 20)),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => toggleFavorite(id),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : const Color(0xFF6B7280), size: 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(priceString, style: const TextStyle(color: Color(0xFF7A5248), fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    width: 32, height: 32,
                    decoration: const ShapeDecoration(color: Color(0xFF5A3A31), shape: OvalBorder()),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BranchItem {
  final String name;
  final String address;
  BranchItem({required this.name, required this.address});
}

class DeliveryLocation {
  final String address;
  DeliveryLocation({required this.address});
}