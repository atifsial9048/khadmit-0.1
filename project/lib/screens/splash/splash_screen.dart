import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/constants/app_strings.dart';
import '../auth/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SignInScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().languageCode;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryGreenDark,
              AppColors.primaryGreen,
              Color(0xFF005528),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Pakistan map watermark
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Image.network(
                  'https://images.pexels.com/photos/3826696/pexels-photo-3826696.jpeg?auto=compress&cs=tinysrgb&w=800',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
            // Gold circle accent top-right
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withOpacity(0.08),
                ),
              ),
            ),
            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '🏠',
                              style: TextStyle(fontSize: 48),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // App Name
                      Text(
                        AppStrings.get('app_name', locale),
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Tagline
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          AppStrings.get('tagline', locale),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreenDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Loading indicator
                      SizedBox(
                        width: 160,
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.gold),
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom tagline
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Text(
                  'Khadmat Pakistan – Har Shehar, Har Ghar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
