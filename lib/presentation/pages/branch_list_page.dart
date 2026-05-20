import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

enum BranchStatus { open, closed }

enum OrderMethod { pickUp, delivery, both }

class BranchItem {
  final String id;
  final String name;
  final String address;
  final double distanceKm;
  final bool isNearest;
  final BranchStatus status;
  final String openHours; // e.g. "09:30 - 22:00"
  final OrderMethod orderMethod;

  const BranchItem({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceKm,
    this.isNearest = false,
    required this.status,
    required this.openHours,
    required this.orderMethod,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// DUMMY DATA  (ganti dengan data dari API / provider-mu nanti)
// ─────────────────────────────────────────────────────────────────────────────

final List<BranchItem> _dummyBranches = [
  BranchItem(
    id: 'branch_1',
    name: 'Jonggol Dayeuh (store terdekat dari user)',
    address: "Hana's Bakery Jonggol (alamat lengkap store)",
    distanceKm: 19.4,
    isNearest: true,
    status: BranchStatus.open,
    openHours: '09:30 - 22:00',
    orderMethod: OrderMethod.both,
  ),
  BranchItem(
    id: 'branch_2',
    name: 'Jonggol Dayeuh (store cabang tersedia lainnya)',
    address: "Hana's Bakery Jonggol (alamat lengkap store)",
    distanceKm: 20.7,
    status: BranchStatus.open,
    openHours: '09:30 - 22:00',
    orderMethod: OrderMethod.both,
  ),
  BranchItem(
    id: 'branch_3',
    name: 'Jonggol Dayeuh (store cabang tersedia lainnya)',
    address: "Hana's Bakery Jonggol (alamat lengkap store)",
    distanceKm: 20.7,
    status: BranchStatus.closed,
    openHours: '09:30 - 22:00',
    orderMethod: OrderMethod.both,
  ),
  BranchItem(
    id: 'branch_4',
    name: 'Jonggol Dayeuh (store cabang tersedia lainnya)',
    address: "Hana's Bakery Jonggol (alamat lengkap store)",
    distanceKm: 20.7,
    status: BranchStatus.closed,
    openHours: '09:30 - 22:00',
    orderMethod: OrderMethod.both,
  ),
  BranchItem(
    id: 'branch_5',
    name: 'Jonggol Dayeuh (store cabang tersedia lainnya)',
    address: "Hana's Bakery Jonggol (alamat lengkap store)",
    distanceKm: 20.7,
    status: BranchStatus.closed,
    openHours: '09:30 - 22:00',
    orderMethod: OrderMethod.both,
  ),
  BranchItem(
    id: 'branch_6',
    name: 'Jonggol Dayeuh (store cabang tersedia lainnya)',
    address: "Hana's Bakery Jonggol (alamat lengkap store)",
    distanceKm: 20.7,
    status: BranchStatus.closed,
    openHours: '09:30 - 22:00',
    orderMethod: OrderMethod.both,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class BranchListPage extends StatefulWidget {
  /// [isPickUpMode] → true  = dibuka dari tombol "Ubah ke Pick Up"
  ///                   false = dibuka dari tombol "Ganti Store" / alamat cabang
  final bool isPickUpMode;

  const BranchListPage({super.key, this.isPickUpMode = false});

  @override
  State<BranchListPage> createState() => _BranchListPageState();
}

class _BranchListPageState extends State<BranchListPage> {
  // ID cabang yang sedang aktif / dipilih (bisa dari state global nanti)
  String? _selectedBranchId = 'branch_1';

  void _selectBranch(BranchItem branch) {
    setState(() => _selectedBranchId = branch.id);

    // TODO: simpan ke provider / state management
    // Contoh: context.read<DeliveryProvider>().setSelectedBranch(branch);

    // Kembali ke halaman sebelumnya & kirim data branch yang dipilih
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop(branch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              itemCount: _dummyBranches.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE5E7EB),
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final branch = _dummyBranches[index];
                return _BranchTile(
                  branch: branch,
                  isSelected: _selectedBranchId == branch.id,
                  onTap: () => _selectBranch(branch),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Nav row
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
                  Expanded(
                    child: Text(
                      "Hana's Bakery",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Color(0xFF1F2937),
                      size: 24,
                    ),
                    onPressed: () {
                      // TODO: buka search
                    },
                  ),
                ],
              ),
            ),

            // Sub-header row  (ikon delivery + jumlah store + tombol switch mode)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  // Delivery icon kecil (gunakan icon bawaan jika tidak ada asset)
                  const Icon(
                    Icons.delivery_dining,
                    color: Color(0xFF7A5248),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Delivery',
                    style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // Tombol switch mode (Pick Up / Delivery)
                  GestureDetector(
                    onTap: () {
                      // TODO: navigasi / switch ke mode pick-up
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF4EDE9),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFF5A3A31),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        widget.isPickUpMode ? 'Ubah ke Delivery' : 'Ubah ke Pick Up',
                        style: const TextStyle(
                          color: Color(0xFF5A3A31),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Store count label
            Container(
              width: double.infinity,
              color: const Color(0xFFF9FAFB),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                '${_dummyBranches.length} Store',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TILE WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class _BranchTile extends StatelessWidget {
  final BranchItem branch;
  final bool isSelected;
  final VoidCallback onTap;

  const _BranchTile({
    required this.branch,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = branch.status == BranchStatus.open;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Nama cabang + checkmark ───────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    branch.name,
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF5A3A31),
                    size: 22,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 2),

            // ── Alamat ───────────────────────────────────────────
            Text(
              branch.address,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 4),

            // ── Jarak + label Terdekat ────────────────────────────
            Row(
              children: [
                Text(
                  '${branch.distanceKm.toStringAsFixed(1)}km dari lokasimu',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
                if (branch.isNearest) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      'Terdekat',
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 10),

            // ── Metode Order ──────────────────────────────────────
            Row(
              children: [
                if (branch.orderMethod == OrderMethod.pickUp ||
                    branch.orderMethod == OrderMethod.both)
                  _buildMethodChip(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Pick Up',
                    color: const Color(0xFF6B7280),
                  ),
                if (branch.orderMethod == OrderMethod.both)
                  const SizedBox(width: 10),
                if (branch.orderMethod == OrderMethod.delivery ||
                    branch.orderMethod == OrderMethod.both)
                  _buildMethodChip(
                    icon: Icons.delivery_dining,
                    label: 'Delivery',
                    color: const Color(0xFF3454D1),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Status buka/tutup + jam ───────────────────────────
            Row(
              children: [
                Text(
                  isOpen ? 'Buka' : 'Tutup',
                  style: TextStyle(
                    color: isOpen
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFDC2626),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  branch.openHours,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}