import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hanas_cake/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

class PreOrderPage extends StatefulWidget {
  const PreOrderPage({super.key});

  @override
  State<PreOrderPage> createState() => _PreOrderPageState();
}

class _PreOrderPageState extends State<PreOrderPage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  int _currentIndex = 0;
  final int _storyCount = 2; 

  // 🔥 WARNA KHUSUS PRE-ORDER
  final Color darkChocolate = const Color(0xFF241511);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextPage();
      }
    });
    
    _animController.forward(); 
  }

  @override
  void dispose() {
    _animController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Animasi ke halaman berikutnya
  void _nextPage() {
    if (_currentIndex < _storyCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _animController.stop();
      if (GoRouter.of(context).canPop()) {
        GoRouter.of(context).pop();
      } else {
        GoRouter.of(context).go('/home');
      }
    }
  }

  // 🔥 FIX 2: Fungsi baru untuk mundur ke halaman sebelumnya (ala IG Story)
  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Jika sudah di slide pertama, cukup reset waktunya dari awal
      _animController.reset();
      _animController.forward();
    }
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    final Uri url = Uri.parse('https://wa.me/6285798203978');
    
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch WhatsApp');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal membuka WhatsApp. Pastikan aplikasi terinstal.'),
            backgroundColor: AppColors.dangerBg,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkChocolate, 
      body: Stack(
        children: [
          GestureDetector(
            // 🔥 FIX 2: Menggunakan onTapUp untuk mendeteksi posisi tap (Kiri / Kanan)
            onTapUp: (TapUpDetails details) {
              final double screenWidth = MediaQuery.of(context).size.width;
              final double tapPosition = details.globalPosition.dx;
              
              // Jika di-tap di area 30% layar sebelah kiri, mundur. Sisanya maju.
              if (tapPosition < screenWidth * 0.3) {
                _previousPage();
              } else {
                _nextPage();
              }
            }, 
            onLongPressStart: (_) => _animController.stop(),
            onLongPressEnd: (_) {
              if (!_animController.isAnimating) _animController.forward();
            },
            child: PageView(
              controller: _pageController,
              // Matikan swipe manual biar user wajib tap (opsional, biar mirip IG story beneran)
              physics: const NeverScrollableScrollPhysics(), 
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _animController.reset();
                  _animController.forward();
                });
              },
              children: [
                _buildStoryPage1(),
                _buildStoryPage2(),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildProgressBar(0)),
                      const SpaceWidth(8),
                      Expanded(child: _buildProgressBar(1)),
                    ],
                  ),
                  const SpaceHeight(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          _animController.isAnimating ? Icons.pause : Icons.play_arrow,
                          color: AppColors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_animController.isAnimating) {
                              _animController.stop();
                            } else {
                              _animController.forward();
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.white, size: 28),
                        onPressed: () {
                          if (GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          } else {
                            GoRouter.of(context).go('/home');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int pageIndex) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        double value = 0.0;
        if (pageIndex < _currentIndex) {
          value = 1.0; 
        } else if (pageIndex == _currentIndex) {
          value = _animController.value; 
        } else {
          value = 0.0; 
        }
        
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: AppColors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
            minHeight: 4,
          ),
        );
      },
    );
  }

  Widget _buildWhatsAppButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => _launchWhatsApp(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white, 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/whatsapp_logo.svg',
                width: 24,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
              const SpaceWidth(12),
              Text(
                'Pesan Sekarang',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Plus Jakarta Sans', 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryPage1() {
    return Stack(
      children: [
        // 🔥 FIX 1: Background menggunakan Sharp Gradient agar warna tidak bocor ke gambar
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryXLight, // Cream atas
                AppColors.primaryXLight, // Cream batas
                darkChocolate,           // Cokelat gelap pekat
                AppColors.primary,       // Cokelat standar bawah
              ],
              // Pemotongan warna tajam persis di 48% layar
              stops: const [0.0, 0.48, 0.48, 1.0], 
            ),
          ),
        ),
        
        SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                'Siap Temani\nAcara Kamu!',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.primary, 
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  fontFamily: 'Plus Jakarta Sans', 
                ),
              ),
              const Spacer(),
              // Memastikan gambar menutupi area potong background dengan aman
              Image.asset(
                'assets/images/pre-order.png',
                width: double.infinity,
                fit: BoxFit.fitWidth, 
              ),
              const Spacer(),
              Text(
                'Pesan Banyak,\nHemat Bangget!',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  fontFamily: 'Plus Jakarta Sans', 
                ),
              ),
              const Spacer(flex: 2),
              _buildWhatsAppButton(), 
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoryPage2() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkChocolate, 
            AppColors.primary, 
          ],
          stops: const [0.65, 1.0], 
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SpaceHeight(80), 
            Expanded(
              child: Column(
                children: [
                  _buildPriceRow('Basic', 'Rp350.000', isLeft: false),
                  _buildPriceRow('Regular', 'Rp500.000', isLeft: true),
                  _buildPriceRow('Premium', 'Rp1.000.000', isLeft: false, hideBorder: true),
                ],
              ),
            ),
            _buildWhatsAppButton(), 
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String price, {required bool isLeft, bool hideBorder = false}) {
    Widget textContent = Column(
      crossAxisAlignment: isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: AppColors.white, 
            fontSize: 16,
            fontFamily: 'Plus Jakarta Sans', 
          ),
        ),
        Text(
          price,
          style: AppTextStyles.h1.copyWith(
            color: AppColors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 28,
            fontFamily: 'Plus Jakarta Sans', 
          ),
        ),
      ],
    );

    Widget imageContent = Image.asset('assets/images/croissant_tr.png', width: 160);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: hideBorder ? null : Border(bottom: BorderSide(color: AppColors.white.withOpacity(0.1), width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: isLeft ? [imageContent, textContent] : [textContent, imageContent],
        ),
      ),
    );
  }
}