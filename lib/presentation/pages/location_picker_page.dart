import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  // State untuk mengontrol tab mana yang sedang aktif
  bool isTerakhirActive = true;

  // State List Alamat Dinamis agar bisa berinteraksi
  List<Map<String, dynamic>> addresses = [
    {
      'id': '1',
      'title': 'Lokasimu Saat Ini',
      'address': 'Jl. Raya Jonggol-Dayeuh, Sukanegara, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830, Indonesia',
      'distance': '19.3km dari store',
      'isSaved': false,
    },
    {
      'id': '2',
      'title': 'Rumah Jonggol',
      'address': 'Jl. Raya Jonggol-Dayeuh, Sukanegara, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830, Indonesia',
      'distance': '19.3km dari store',
      'isSaved': false,
    },
    {
      'id': '3',
      'title': 'Jonggol',
      'address': 'Jl. Raya Jonggol-Dayeuh, Sukanegara, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830, Indonesia',
      'distance': '19.3km dari store',
      'isSaved': true,
    }
  ];

  // 🔥 Fungsi Ajaib: Toggle Save & Otomatis Pindah Tab
  void toggleBookmark(String id) {
    setState(() {
      final index = addresses.indexWhere((addr) => addr['id'] == id);
      if (index != -1) {
        bool currentlySaved = addresses[index]['isSaved'];
        
        // Ubah status save
        addresses[index]['isSaved'] = !currentlySaved;

        // Jika baru saja di-save (dari false ke true), langsung lempar ke tab "Tersimpan"
        if (!currentlySaved) {
          isTerakhirActive = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter list berdasarkan tab yang aktif
    // Jika 'Terakhir', tampilkan semua (history). Jika 'Tersimpan', tampilkan yang isSaved == true
    final displayedAddresses = isTerakhirActive 
        ? addresses 
        : addresses.where((addr) => addr['isSaved'] == true).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 🔥 FIX: Headline dipastikan di tengah
        centerTitle: true, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              GoRouter.of(context).go('/delivery');
            }
          },
        ),
        title: Text(
          'Pilih Lokasi Pengiriman',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─────────────────────────────────────────────────────────
          // 1. SEARCH BAR
          // ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Lokasi',
                hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 24),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          const SpaceHeight(8),

          // ─────────────────────────────────────────────────────────
          // 2. TABS (Terakhir / Tersimpan)
          // ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildTabButton(
                  title: 'Terakhir',
                  isActive: isTerakhirActive,
                  onTap: () {
                    setState(() {
                      isTerakhirActive = true;
                    });
                  },
                ),
                const SpaceWidth(12),
                _buildTabButton(
                  title: 'Tersimpan',
                  isActive: !isTerakhirActive,
                  onTap: () {
                    setState(() {
                      isTerakhirActive = false;
                    });
                  },
                ),
              ],
            ),
          ),

          const SpaceHeight(16),
          const Divider(height: 1, thickness: 4, color: Color(0xFFF3F4F6)), 
          
          // ─────────────────────────────────────────────────────────
          // 3. LOCATION LIST (Dinamis & Interaktif)
          // ─────────────────────────────────────────────────────────
          Expanded(
            child: displayedAddresses.isEmpty 
              ? Center(
                  child: Text(
                    'Belum ada alamat tersimpan',
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  itemCount: displayedAddresses.length,
                  separatorBuilder: (context, index) => const Divider(height: 32, thickness: 1, color: Color(0xFFE5E7EB)),
                  itemBuilder: (context, index) {
                    final item = displayedAddresses[index];
                    return _buildLocationItem(
                      id: item['id'],
                      title: item['title'],
                      address: item['address'],
                      distance: item['distance'],
                      isSaved: item['isSaved'],
                    );
                  },
              ),
          ),
        ],
      ),
      
      // ─────────────────────────────────────────────────────────
      // 4. BOTTOM BUTTON (Tambah Alamat)
      // ─────────────────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Tambah Alamat',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // HELPER WIDGETS
  // ─────────────────────────────────────────────────────────

  Widget _buildTabButton({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEDD8D0).withOpacity(0.5) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: isActive ? AppColors.primary : Colors.grey.shade400,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationItem({
    required String id,
    required String title,
    required String address,
    required String distance,
    required bool isSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: SvgPicture.asset(
              'assets/icons/target_reticle.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
            ),
          ),
          const SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceHeight(4),
                Text(
                  address,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SpaceHeight(8),
                Text(
                  distance,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SpaceWidth(12),
          // 🔥 Ikon Bookmark Interaktif
          GestureDetector(
            onTap: () => toggleBookmark(id),
            child: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}