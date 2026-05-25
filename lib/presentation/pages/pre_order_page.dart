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

  // 🔥 WARNA KHUSUS PRE-ORDER (Sesuai Izin Pak Ketua)
  // Cokelat sangat gelap (hampir hitam) seperti di Figma
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
      backgroundColor: darkChocolate, // Default bg gelap
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => _nextPage(), 
            onLongPressStart: (_) => _animController.stop(),
            onLongPressEnd: (_) {
              if (!_animController.isAnimating) _animController.forward();
            },
            child: PageView(
              controller: _pageController,
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
            backgroundColor: AppColors.white.withValues(alpha: 0.3),
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
        Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(color: AppColors.primaryXLight), 
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  // 🔥 FIX GRADASI: Dark chocolate dominan dari atas, lalu pudar ke primary di bawah
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      darkChocolate, // Cokelat gelap pekat     
                      AppColors.primary, // Cokelat standar (terang)       
                    ],
                    stops: const [0.5, 1.0], // 50% layar atas dipegang penuh oleh darkChocolate
                  ),
                ),
              ),
            ),
          ],
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
              Image.asset(
                'assets/images/pre-order.png',
                width: double.infinity,
                fit: BoxFit.cover,
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
        // 🔥 FIX GRADASI: Dark chocolate sangat dominan untuk slide 2
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkChocolate, 
            AppColors.primary, 
          ],
          stops: const [0.65, 1.0], // 65% layar ke atas dikuasai dark chocolate
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
          border: hideBorder ? null : Border(bottom: BorderSide(color: AppColors.white.withValues(alpha: 0.1), width: 1)),
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