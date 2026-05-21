import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

// Model Data Cabang
class BranchItem {
  final String name;
  final String address;
  final String distanceKm;
  final bool isTop;

  BranchItem({
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.isTop,
  });
}

class BranchListPage extends StatefulWidget {
  const BranchListPage({super.key});

  @override
  State<BranchListPage> createState() => _BranchListPageState();
}

class _BranchListPageState extends State<BranchListPage> {
  // Data Dummy Cabang sesuai Figma
  final List<BranchItem> branches = [
    BranchItem(
      name: 'Jonggol Dayeuh (store terdekat dari user)',
      address: "Hana's Bakery Jonggol (alamat lengkap store)",
      distanceKm: '19.4',
      isTop: true,
    ),
    BranchItem(
      name: 'Jonggol Dayeuh (store cabang tersedia lainnya)',
      address: "Hana's Bakery Jonggol (alamat lengkap store)",
      distanceKm: '20.7',
      isTop: false,
    ),
    BranchItem(
      name: 'Jonggol Dayeuh (store cabang tersedia lainnya)',
      address: "Hana's Bakery Jonggol (alamat lengkap store)",
      distanceKm: '20.7',
      isTop: false,
    ),
  ];

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

  // 🔥 FUNGSI POPUP WAKTU OPERASIONAL (SEKARANG INTERAKTIF)
  void _showOperatingHoursBottomSheet() {
    // Default aktif di tab Delivery
    bool isDeliveryActive = true; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bottomSheetContext) {
        // 🔥 Tambahkan StatefulBuilder agar bisa di-klik dan ganti state
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFF9CA3AF), borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 24),
                    const Text('Waktu Operasional', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5A3A31))),
                    const SizedBox(height: 24),
                    
                    // Toggle Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tab Pick Up
                        GestureDetector(
                          onTap: () => setModalState(() => isDeliveryActive = false),
                          child: _buildHourToggle('Pick Up', !isDeliveryActive),
                        ),
                        const SizedBox(width: 16),
                        // Tab Delivery
                        GestureDetector(
                          onTap: () => setModalState(() => isDeliveryActive = true),
                          child: _buildHourToggle('Delivery', isDeliveryActive),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // 🔥 Jadwal berubah otomatis tergantung tab yang diklik!
                    if (isDeliveryActive) ...[
                      _buildHourRow('Senin', '09:30 - 21:00'),
                      _buildHourRow('Selasa', '09:30 - 21:00'),
                      _buildHourRow('Rabu', '09:30 - 21:00'),
                      _buildHourRow('Kamis', '09:30 - 21:00'),
                      _buildHourRow('Jumat', '09:30 - 21:00'),
                      _buildHourRow('Sabtu', '08:00 - 21:00'),
                      _buildHourRow('Minggu', '08:00 - 21:00'),
                    ] else ...[
                      _buildHourRow('Senin', '09:30 - 22:00'),
                      _buildHourRow('Selasa', '09:30 - 22:00'),
                      _buildHourRow('Rabu', '09:30 - 22:00'),
                      _buildHourRow('Kamis', '09:30 - 22:00'),
                      _buildHourRow('Jumat', '09:30 - 22:00'),
                      _buildHourRow('Sabtu', '08:00 - 22:00'),
                      _buildHourRow('Minggu', '08:00 - 22:00'),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  // 🔥 Padding digedein biar tombolnya gemuk
  Widget _buildHourToggle(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEFE8E5) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: active ? const Color(0xFF5A3A31) : Colors.grey.shade300),
      ),
      child: Text(label, style: TextStyle(color: active ? const Color(0xFF5A3A31) : const Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHourRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(day, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13))),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    (constraints.constrainWidth() / 6).floor(),
                    (index) => Container(width: 3, height: 1, color: Colors.grey.shade300),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 100, child: Text(time, textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFF1F2937), fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildHorizontalDashedLine() {
    return Row(
      children: List.generate(
        60,
        (index) => Expanded(
          child: Container(
            height: 1,
            color: index % 2 == 0 ? const Color(0xFFD1D5DB) : Colors.transparent,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF5A3A31), size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text("Hana's Bakery", style: TextStyle(color: Color(0xFF5A3A31), fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Color(0xFF5A3A31)), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/delivery_rounded.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Delivery',
                  style: TextStyle(color: Color(0xFF5A3A31), fontSize: 24, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () => _showOrderMethodBottomSheet(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF5A3A31)),
                    backgroundColor: const Color(0xFFF4EDE9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0,
                  ),
                  child: const Text('Ubah ke Pick Up', style: TextStyle(color: Color(0xFF5A3A31), fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('${branches.length} Store', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13, fontWeight: FontWeight.w500)),
          ),
          
          Container(color: Colors.white, child: _buildHorizontalDashedLine()),

          Expanded(
            child: ListView.separated(
              itemCount: branches.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8), 
              itemBuilder: (context, index) {
                final item = branches[index];
                return InkWell(
                  onTap: () => context.pop(item),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.name, 
                                style: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.w600, fontSize: 16, height: 1.3),
                              ),
                            ),
                            if (item.isTop) 
                              const Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Icon(Icons.check_circle, color: Color(0xFF5A3A31), size: 22),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // 🔥 Teks Alamat Diperbesar
                        Text(
                          item.address, 
                          style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, height: 1.4)
                        ),
                        const SizedBox(height: 8),
                        
                        // 🔥 Teks Jarak Diperbesar
                        RichText(
                          text: TextSpan(
                            text: '${item.distanceKm} km dari lokasimu',
                            style: const TextStyle(color: Color(0xFF1F2937), fontSize: 13, fontWeight: FontWeight.w600),
                            children: [
                              if (item.isTop)
                                const TextSpan(
                                  text: ' • Terdekat',
                                  style: TextStyle(color: Color(0xFF166534)),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/tote_simple.svg', 
                              width: 16, 
                              colorFilter: const ColorFilter.mode(Color(0xFF5A3A31), BlendMode.srcIn),
                            ),
                            const SizedBox(width: 6),
                            const Text('Pick Up', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                            
                            const SizedBox(width: 16),

                            SvgPicture.asset(
                              'assets/icons/moped.svg', 
                              width: 18, 
                            ),
                            const SizedBox(width: 6),
                            const Text('Delivery', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        _buildHorizontalDashedLine(),
                        const SizedBox(height: 16),
                        
                        InkWell(
                          onTap: _showOperatingHoursBottomSheet,
                          child: Row(
                            children: const [
                              Text('Buka', style: TextStyle(color: Color(0xFF3454D1), fontSize: 13, fontWeight: FontWeight.w600)), 
                              SizedBox(width: 8),
                              Text('09:30 - 22:00', style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF6B7280)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}