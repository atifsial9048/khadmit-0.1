import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/provider_model.dart';
import '../../models/user_model.dart';
import 'tracking_screen.dart';

class PaymentScreen extends StatefulWidget {
  final ProviderModel provider;
  final UserModel customer;

  const PaymentScreen({super.key, required this.provider, required this.customer});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0; // 0=JazzCash, 1=COD, 2=Card
  bool _isLoading = false;
  bool _showOtp = false;
  bool _paymentSuccess = false;
  bool _paymentFailed = false;

  final _mobileCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  double get _subtotal => widget.provider.pricePerHour * 2;
  double get _tax => _subtotal * 0.05;
  double get _total => _subtotal + _tax;

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _otpCtrl.dispose();
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (_selectedMethod == 0 && _mobileCtrl.text.length < 11) {
      setState(() {
        _isLoading = false;
        _showOtp = true;
      });
      return;
    }

    // Simulate 80% success rate
    final success = DateTime.now().second % 5 != 0;
    setState(() {
      _isLoading = false;
      _paymentSuccess = success;
      _paymentFailed = !success;
    });

    if (success) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TrackingScreen(
            provider: widget.provider,
            customer: widget.customer,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('payment')),
      ),
      body: _paymentSuccess
          ? _SuccessWidget(
              onDashboard: () => Navigator.popUntil(context, (r) => r.isFirst))
          : _paymentFailed
              ? _FailureWidget(
                  onRetry: () => setState(() {
                    _paymentFailed = false;
                    _paymentSuccess = false;
                  }),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary
                      _SectionTitle(context.tr('order_summary')),
                      const SizedBox(height: 12),
                      _SummaryCard(
                        provider: widget.provider,
                        subtotal: _subtotal,
                        tax: _tax,
                        total: _total,
                      ),
                      const SizedBox(height: 24),

                      _SectionTitle(context.tr('payment')),
                      const SizedBox(height: 12),

                      // Payment methods
                      _PaymentOption(
                        icon: '📱',
                        label: context.tr('jazzcash'),
                        color: const Color(0xFFD32F2F),
                        isSelected: _selectedMethod == 0,
                        onTap: () =>
                            setState(() => _selectedMethod = 0),
                      ),
                      const SizedBox(height: 8),
                      _PaymentOption(
                        icon: '💵',
                        label: context.tr('cod'),
                        color: AppColors.success,
                        isSelected: _selectedMethod == 1,
                        onTap: () =>
                            setState(() => _selectedMethod = 1),
                      ),
                      const SizedBox(height: 8),
                      _PaymentOption(
                        icon: '💳',
                        label: context.tr('card'),
                        color: AppColors.info,
                        isSelected: _selectedMethod == 2,
                        onTap: () =>
                            setState(() => _selectedMethod = 2),
                      ),
                      const SizedBox(height: 20),

                      // JazzCash fields
                      if (_selectedMethod == 0) ...[
                        TextFormField(
                          controller: _mobileCtrl,
                          keyboardType: TextInputType.phone,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            labelText: context.tr('enter_mobile'),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                        ),
                        if (_showOtp) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _otpCtrl,
                            keyboardType: TextInputType.number,
                            textDirection: TextDirection.ltr,
                            decoration: InputDecoration(
                              labelText: context.tr('enter_otp'),
                              prefixIcon: const Icon(Icons.security),
                              hintText: '123456',
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                      ],

                      // Card fields
                      if (_selectedMethod == 2) ...[
                        TextFormField(
                          controller: _cardCtrl,
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            labelText: context.tr('card_number'),
                            prefixIcon: const Icon(Icons.credit_card),
                            hintText: '1234 5678 9012 3456',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _expiryCtrl,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  labelText: context.tr('expiry'),
                                  hintText: 'MM/YY',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _cvvCtrl,
                                obscureText: true,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  labelText: context.tr('cvv'),
                                  hintText: '***',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _processPayment,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  '${context.tr('confirm_payment')}  –  Rs. ${_total.toStringAsFixed(0)}'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final ProviderModel provider;
  final double subtotal;
  final double tax;
  final double total;

  const _SummaryCard({
    required this.provider,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Row(provider.name, provider.serviceType),
            _Row('${provider.distanceKm.toStringAsFixed(1)} km', ''),
            const Divider(),
            _Row(context.tr('service'), 'Rs. ${subtotal.toStringAsFixed(0)}'),
            _Row(context.tr('tax'), 'Rs. ${tax.toStringAsFixed(0)}'),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.tr('total_amount'),
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                Text(
                  'Rs. ${total.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                      fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String left;
  final String right;
  const _Row(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: Theme.of(context).textTheme.bodyMedium),
          Text(right, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Theme.of(context).cardTheme.color,
          border: Border.all(
            color: isSelected ? color : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isSelected ? color : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  final VoidCallback onDashboard;
  const _SuccessWidget({required this.onDashboard});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 56),
            ),
            const SizedBox(height: 24),
            Text(
              context.tr('booking_confirmed'),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onDashboard,
              child: Text(context.tr('go_to_dashboard')),
            ),
          ],
        ),
      ),
    );
  }
}

class _FailureWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const _FailureWidget({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 56),
            ),
            const SizedBox(height: 24),
            Text(
              context.tr('payment_failed'),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(context.tr('retry')),
            ),
          ],
        ),
      ),
    );
  }
}
