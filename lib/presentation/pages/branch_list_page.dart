import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';

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

  // 🔥 FUNGSI POPUP WAKTU OPERASIONAL
  void _showOperatingHoursBottomSheet() {
    bool isDeliveryActive = true; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
                    const SpaceHeight(24),
                    Text('Waktu Operasional', style: AppTextStyles.h2.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    const SpaceHeight(24),
                    
                    // Toggle Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => setModalState(() => isDeliveryActive = false),
                          child: _buildHourToggle('Pick Up', !isDeliveryActive),
                        ),
                        const SpaceWidth(16),
                        GestureDetector(
                          onTap: () => setModalState(() => isDeliveryActive = true),
                          child: _buildHourToggle('Delivery', isDeliveryActive),
                        ),
                      ],
                    ),
                    const SpaceHeight(32),
                    
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
                    const SpaceHeight(16),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildHourToggle(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: active ? AppColors.primaryXLight : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
      ),
      child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: active ? AppColors.primary : AppColors.textSecondary, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHourRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(day, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    (constraints.constrainWidth() / 6).floor(),
                    (index) => Container(width: 3, height: 1, color: AppColors.border),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 100, child: Text(time, textAlign: TextAlign.right, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500))),
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
            color: index % 2 == 0 ? AppColors.border : Colors.transparent,
          ),
        ),
      ),
    );
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
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text("Hana's Bakery", style: AppTextStyles.h3.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: AppColors.primary), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/delivery_rounded.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SpaceWidth(16),
                Text(
                  'Delivery',
                  style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () => _showOrderMethodBottomSheet(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    backgroundColor: AppColors.primaryXLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0,
                  ),
                  child: Text('Ubah ke Pick Up', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('${branches.length} Store', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          ),
          
          Container(color: AppColors.white, child: _buildHorizontalDashedLine()),

          Expanded(
            child: ListView.separated(
              itemCount: branches.length,
              separatorBuilder: (context, index) => const SpaceHeight(8), 
              itemBuilder: (context, index) {
                final item = branches[index];
                return InkWell(
                  onTap: () => GoRouter.of(context).pop(item),
                  child: Container(
                    color: AppColors.white,
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
                                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600, height: 1.3),
                              ),
                            ),
                            if (item.isTop) 
                              const Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                              ),
                          ],
                        ),
                        const SpaceHeight(4),
                        Text(
                          item.address, 
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
                        ),
                        const SpaceHeight(8),
                        
                        RichText(
                          text: TextSpan(
                            text: '${item.distanceKm} km dari lokasimu',
                            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                            children: [
                              if (item.isTop)
                                TextSpan(
                                  text: ' • Terdekat',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.successText),
                                ),
                            ],
                          ),
                        ),
                        const SpaceHeight(16),
                        
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/tote_simple.svg', 
                              width: 16, 
                              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                            ),
                            const SpaceWidth(6),
                            Text('Pick Up', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                            
                            const SpaceWidth(16),

                            SvgPicture.asset(
                              'assets/icons/moped.svg', 
                              width: 18, 
                            ),
                            const SpaceWidth(6),
                            Text('Delivery', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                        
                        const SpaceHeight(16),
                        _buildHorizontalDashedLine(),
                        const SpaceHeight(16),
                        
                        InkWell(
                          onTap: _showOperatingHoursBottomSheet,
                          child: Row(
                            children: [
                              Text('Buka', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600)), 
                              const SpaceWidth(8),
                              Text('09:30 - 22:00', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
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