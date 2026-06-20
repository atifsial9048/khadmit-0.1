import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final isDark = themeProvider.isDark;
    final isUrdu = localeProvider.isUrdu;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Appearance
          _GroupHeader(context.tr('appearance')),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: isDark,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  secondary: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: AppColors.primaryGreen,
                  ),
                  title: Text(
                    isDark
                        ? context.tr('dark_mode')
                        : context.tr('light_mode'),
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  activeColor: AppColors.primaryGreen,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Language
          _GroupHeader(context.tr('language')),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _LangOption(
                  label: 'English',
                  sublabel: 'English',
                  isSelected: !isUrdu,
                  onTap: () => localeProvider.setLocale('en'),
                ),
                const Divider(height: 1),
                _LangOption(
                  label: 'اردو',
                  sublabel: 'Urdu',
                  isSelected: isUrdu,
                  onTap: () => localeProvider.setLocale('ur'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // About
          _GroupHeader('About'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline,
                      color: AppColors.primaryGreen),
                  title: Text('Khadmat Pakistan',
                      style:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text('v1.0.0',
                      style:
                          GoogleFonts.poppins(color: AppColors.grey500)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined,
                      color: AppColors.primaryGreen),
                  title: Text(context.tr('privacy_policy'),
                      style:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.grey400),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Branding
          Center(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  '🏠 Khadmat Pakistan',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Har Shehar, Har Ghar',
                  style: GoogleFonts.poppins(
                    color: AppColors.grey500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String text;
  const _GroupHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.grey500,
        letterSpacing: 1,
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangOption({
    required this.label,
    required this.sublabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label[0],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.white : AppColors.grey600,
            ),
          ),
        ),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.primaryGreen : null,
        ),
      ),
      subtitle: Text(sublabel, style: GoogleFonts.poppins(fontSize: 12)),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
          : null,
    );
  }
}
