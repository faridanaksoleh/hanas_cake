import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

class DeliveryLocation {
  final String id;
  final String label;        // e.g. "Lokasimu Saat Ini" / nama alamat tersimpan
  final String fullAddress;
  final double distanceKm;
  final bool isSaved;        // true = masuk tab "Tersimpan"

  const DeliveryLocation({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.distanceKm,
    this.isSaved = false,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// DUMMY DATA  (ganti dengan data dari API / GPS nanti)
// ─────────────────────────────────────────────────────────────────────────────

final List<DeliveryLocation> _recentLocations = [
  const DeliveryLocation(
    id: 'loc_1',
    label: 'Lokasimu Saat Ini',
    fullAddress:
        'Jl. Raya Jonggol-Dayeuh, Sukanegara, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830, Indonesia',
    distanceKm: 19.3,
  ),
  const DeliveryLocation(
    id: 'loc_2',
    label: 'Lokasimu Saat Ini',
    fullAddress:
        'Jl. Raya Jonggol-Dayeuh, Sukanegara, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830, Indonesia',
    distanceKm: 19.3,
  ),
];

final List<DeliveryLocation> _savedLocations = [
  const DeliveryLocation(
    id: 'loc_saved_1',
    label: 'Rumah',
    fullAddress: 'Jl. Merdeka No. 10, Jakarta Pusat, DKI Jakarta 10110',
    distanceKm: 5.2,
    isSaved: true,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<DeliveryLocation> get _filteredRecent => _searchQuery.isEmpty
      ? _recentLocations
      : _recentLocations
          .where((l) =>
              l.label.toLowerCase().contains(_searchQuery) ||
              l.fullAddress.toLowerCase().contains(_searchQuery))
          .toList();

  List<DeliveryLocation> get _filteredSaved => _searchQuery.isEmpty
      ? _savedLocations
      : _savedLocations
          .where((l) =>
              l.label.toLowerCase().contains(_searchQuery) ||
              l.fullAddress.toLowerCase().contains(_searchQuery))
          .toList();

  void _selectLocation(DeliveryLocation loc) {
    // TODO: simpan ke provider / state management
    // Contoh: context.read<DeliveryProvider>().setDeliveryLocation(loc);

    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop(loc);
    }
  }

  void _addNewAddress() {
    // TODO: navigasi ke halaman tambah alamat (maps picker, dsb.)
    // Contoh: context.push('/add-address');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          _buildTopSection(),

          // ── List area ──────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLocationList(_filteredRecent),
                _buildLocationList(_filteredSaved),
              ],
            ),
          ),

          // ── Tombol Tambah Alamat ───────────────────────────────
          _buildAddButton(),
        ],
      ),
    );
  }

  // ── Top section (AppBar + search + tab) ────────────────────────────────────

  Widget _buildTopSection() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF1F2937),
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
                  const Expanded(
                    child: Text(
                      'Pilih Lokasi Pengiriman',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // spacer supaya judul tetap center
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 44,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Cari Lokasi',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () => _searchController.clear(),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.close, color: Color(0xFF9CA3AF), size: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Tab bar  (Terakhir | Tersimpan)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 40,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF3F4F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFF5A3A31),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF6B7280),
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'Terakhir'),
                    Tab(text: 'Tersimpan'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 4),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          ],
        ),
      ),
    );
  }

  // ── List builder ─────────────────────────────────────────────────────────

  Widget _buildLocationList(List<DeliveryLocation> locations) {
    if (locations.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada lokasi ditemukan.',
          style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      itemCount: locations.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFE5E7EB),
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (context, index) {
        final loc = locations[index];
        return _LocationTile(
          location: loc,
          onTap: () => _selectLocation(loc),
          onSave: () {
            // TODO: simpan/hapus bookmark
          },
        );
      },
    );
  }

  // ── Tombol bawah ────────────────────────────────────────────────────────────

  Widget _buildAddButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _addNewAddress,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A3A31),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: const Text(
            'Tambah Alamat',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TILE WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class _LocationTile extends StatelessWidget {
  final DeliveryLocation location;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const _LocationTile({
    required this.location,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ikon lokasi ───────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.my_location_outlined,
                size: 20,
                color: Color(0xFF7A5248),
              ),
            ),

            const SizedBox(width: 12),

            // ── Teks ─────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.label,
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.fullAddress,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${location.distanceKm.toStringAsFixed(1)}km dari store',
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Bookmark icon ─────────────────────────────────────
            GestureDetector(
              onTap: onSave,
              child: const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.bookmark_border,
                  size: 22,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}