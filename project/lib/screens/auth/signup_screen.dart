import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/locale_provider.dart';
import '../../models/user_model.dart';
import '../role_select/role_select_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  String? _selectedCity;
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  static const List<Map<String, String>> _cities = [
    {'en': 'Karachi', 'ur': 'کراچی', 'val': 'Karachi'},
    {'en': 'Lahore', 'ur': 'لاہور', 'val': 'Lahore'},
    {'en': 'Islamabad', 'ur': 'اسلام آباد', 'val': 'Islamabad'},
    {'en': 'Rawalpindi', 'ur': 'راولپنڈی', 'val': 'Rawalpindi'},
    {'en': 'Faisalabad', 'ur': 'فیصل آباد', 'val': 'Faisalabad'},
    {'en': 'Peshawar', 'ur': 'پشاور', 'val': 'Peshawar'},
    {'en': 'Quetta', 'ur': 'کوئٹہ', 'val': 'Quetta'},
    {'en': 'Multan', 'ur': 'ملتان', 'val': 'Multan'},
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('select_city'))),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);

    final newUser = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      fullName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      city: _selectedCity!,
      role: UserRole.customer,
      isVerified: false,
      rating: 0.0,
      rank: 'Bronze',
      totalEarnings: 0.0,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RoleSelectScreen(user: newUser)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = context.isUrdu;
    final locale = context.watch<LocaleProvider>().languageCode;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back + Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        context.tr('sign_up'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Logo small
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    const Center(child: Text('🏠', style: TextStyle(fontSize: 30))),
              ),
              const SizedBox(height: 16),
              // Form card
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Directionality(
                        textDirection:
                            isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              context.tr('sign_up'),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.tr('app_name'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.primaryGreen),
                            ),
                            const SizedBox(height: 24),
                            // Full Name
                            TextFormField(
                              controller: _nameCtrl,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                labelText: context.tr('full_name'),
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                              validator: (v) =>
                                  v == null || v.trim().length < 3
                                      ? '!'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            // Phone
                            TextFormField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                labelText: context.tr('phone_number'),
                                prefixIcon: const Icon(Icons.phone_outlined),
                                hintText: '03XX-XXXXXXX',
                              ),
                              validator: (v) =>
                                  v == null || v.trim().length < 10
                                      ? '!'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            // City Dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedCity,
                              decoration: InputDecoration(
                                labelText: context.tr('city'),
                                prefixIcon:
                                    const Icon(Icons.location_city_outlined),
                              ),
                              hint: Text(context.tr('select_city')),
                              items: _cities
                                  .map((c) => DropdownMenuItem<String>(
                                        value: c['val'],
                                        child: Text(
                                          c[locale] ?? c['en']!,
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedCity = v),
                              validator: (v) => v == null ? '!' : null,
                            ),
                            const SizedBox(height: 16),
                            // Password
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscurePass,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                labelText: context.tr('password'),
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePass
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () => setState(
                                      () => _obscurePass = !_obscurePass),
                                ),
                              ),
                              validator: (v) =>
                                  v == null || v.length < 6 ? '!' : null,
                            ),
                            const SizedBox(height: 16),
                            // Confirm Password
                            TextFormField(
                              controller: _confirmPassCtrl,
                              obscureText: _obscureConfirm,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                labelText: context.tr('confirm_password'),
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirm
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm),
                                ),
                              ),
                              validator: (v) => v != _passCtrl.text
                                  ? '!'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signUp,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(context.tr('register')),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.tr('already_have_account'),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    context.tr('sign_in'),
                                    style: const TextStyle(
                                        color: AppColors.primaryGreen,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
