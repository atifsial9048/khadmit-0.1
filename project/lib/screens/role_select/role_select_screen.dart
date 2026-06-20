import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/locale_provider.dart';
import '../../models/user_model.dart';
import '../customer/customer_dashboard.dart';
import '../provider/provider_dashboard.dart';
import '../../models/provider_model.dart';

class RoleSelectScreen extends StatelessWidget {
  final UserModel user;

  const RoleSelectScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isUrdu = context.isUrdu;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryGreenDark, AppColors.primaryGreen],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${context.tr('hello')}, ${user.fullName.split(' ').first}!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr('select_role'),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Spacer(),
                // Customer Card
                _RoleCard(
                  icon: '👤',
                  title: context.tr('i_am_customer'),
                  subtitle: context.tr('get_service'),
                  color: AppColors.info,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
                  ),
                  onTap: () {
                    final customer = user.copyWith();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomerDashboard(
                          user: UserModel(
                            id: user.id,
                            fullName: user.fullName,
                            phone: user.phone,
                            city: user.city,
                            email: user.email,
                            profileImageUrl: user.profileImageUrl,
                            role: UserRole.customer,
                            isVerified: user.isVerified,
                            rating: user.rating,
                            rank: user.rank,
                            totalEarnings: user.totalEarnings,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Provider Card
                _RoleCard(
                  icon: '🔧',
                  title: context.tr('i_am_provider'),
                  subtitle: context.tr('give_service'),
                  color: AppColors.gold,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF004D1A), Color(0xFF006633)],
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProviderDashboard(
                          user: UserModel(
                            id: user.id,
                            fullName: user.fullName,
                            phone: user.phone,
                            city: user.city,
                            email: user.email,
                            profileImageUrl: user.profileImageUrl,
                            role: UserRole.provider,
                            isVerified: true,
                            rating: 4.8,
                            rank: 'Gold',
                            totalEarnings: 145000,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                Text(
                  'Khadmat Pakistan',
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final Gradient gradient;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.white.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.white.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }
}
