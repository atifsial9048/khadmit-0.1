import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../models/user_model.dart';
import 'signup_screen.dart';
import '../role_select/role_select_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController(text: '03085228520');
  final _passCtrl = TextEditingController(text: '123456');
  bool _obscurePass = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Mock user
    final mockUser = UserModel(
      id: 'u_demo',
      fullName: 'M. Atif',
      phone: _phoneCtrl.text.isEmpty ? '03085228520' : _phoneCtrl.text,
      email: 'atifsial5510@gmail.com',
      city: 'Islamabad',
      role: UserRole.customer,
      isVerified: true,
      rating: 4.5,
      rank: 'Silver',
      totalEarnings: 0,
      jazzCashNumber: '03085228520',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RoleSelectScreen(user: mockUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = context.isUrdu;
    final themeProvider = context.read<ThemeProvider>();
    final localeProvider = context.read<LocaleProvider>();

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
              // Top bar with language/theme toggles
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => themeProvider.toggleTheme(),
                      icon: Icon(
                        themeProvider.isDark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: AppColors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => localeProvider.toggleLocale(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isUrdu ? 'English' : 'اردو',
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Logo area
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text('🏠', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.tr('app_name'),
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr('tagline'),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Form card
              Expanded(
                flex: 3,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            context.tr('sign_in'),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                            textAlign: isUrdu ? TextAlign.right : TextAlign.left,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            textDirection:
                                TextDirection.ltr, // phone always LTR
                            decoration: InputDecoration(
                              labelText: context.tr('phone_number'),
                              prefixIcon: const Icon(Icons.phone_outlined),
                              hintText: '03XX-XXXXXXX',
                            ),
                            validator: (v) =>
                                v == null || v.length < 10 ? '!' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscurePass,
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
                          const SizedBox(height: 8),
                          Align(
                            alignment: isUrdu
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                context.tr('forgot_password'),
                                style: const TextStyle(
                                    color: AppColors.primaryGreen),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _signIn,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(context.tr('login')),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.tr('dont_have_account'),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SignUpScreen()),
                                ),
                                child: Text(
                                  context.tr('sign_up'),
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
            ],
          ),
        ),
      ),
    );
  }
}
