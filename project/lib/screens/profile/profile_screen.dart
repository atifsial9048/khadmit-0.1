import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/user_model.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _jazzCtrl;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.fullName);
    _phoneCtrl = TextEditingController(text: widget.user.phone);
    _emailCtrl = TextEditingController(text: widget.user.email ?? '');
    _jazzCtrl =
        TextEditingController(text: widget.user.jazzCashNumber ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _jazzCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _profileImagePath = picked.path);
  }

  void _save() {
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('save')),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('my_profile')),
        actions: [
          TextButton(
            onPressed: () =>
                setState(() => _isEditing = !_isEditing),
            child: Text(
              _isEditing ? context.tr('save') : context.tr('edit_profile'),
              style: GoogleFonts.poppins(
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryGreenDark, AppColors.primaryGreen],
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _isEditing ? _pickImage : null,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.gold,
                          backgroundImage: user.profileImageUrl != null
                              ? NetworkImage(user.profileImageUrl!)
                              : null,
                          child: user.profileImageUrl == null
                              ? Text(
                                  user.fullName.isNotEmpty
                                      ? user.fullName[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGreenDark,
                                  ),
                                )
                              : null,
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: AppColors.gold,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 16,
                                  color: AppColors.primaryGreenDark),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.fullName,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (user.isVerified)
                        const Icon(Icons.verified,
                            color: AppColors.gold, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        user.city,
                        style: GoogleFonts.poppins(
                          color: AppColors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _rankColor(user.rank),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          user.rank,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(context.tr('my_profile')),
                  const SizedBox(height: 12),
                  _Field(
                    label: context.tr('full_name'),
                    controller: _nameCtrl,
                    icon: Icons.person_outline,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: context.tr('phone_number'),
                    controller: _phoneCtrl,
                    icon: Icons.phone_outlined,
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: context.tr('email'),
                    controller: _emailCtrl,
                    icon: Icons.email_outlined,
                    enabled: _isEditing,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),

                  _SectionHeader(context.tr('payment_settings')),
                  const SizedBox(height: 12),
                  _Field(
                    label: context.tr('add_jazzcash'),
                    controller: _jazzCtrl,
                    icon: Icons.account_balance_wallet_outlined,
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),

                  if (_isEditing)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _save,
                        child: Text(context.tr('save')),
                      ),
                    ),

                  if (!_isEditing) ...[
                    const SizedBox(height: 8),
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      label: context.tr('settings'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsScreen()),
                      ),
                    ),
                    const Divider(),
                    _MenuItem(
                      icon: Icons.privacy_tip_outlined,
                      label: context.tr('privacy_policy'),
                      onTap: () {},
                    ),
                    const Divider(),
                    _MenuItem(
                      icon: Icons.logout,
                      label: context.tr('logout'),
                      color: AppColors.error,
                      onTap: () => Navigator.popUntil(
                          context, (r) => r.isFirst),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _rankColor(String rank) {
    switch (rank) {
      case 'Gold':
        return AppColors.rankGold;
      case 'Silver':
        return AppColors.rankSilver;
      default:
        return AppColors.rankBronze;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGreen,
          ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool enabled;
  final TextInputType? keyboardType;

  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    required this.enabled,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? AppColors.primaryGreen),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 14, color: color ?? AppColors.grey400),
      onTap: onTap,
    );
  }
}
