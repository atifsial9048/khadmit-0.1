import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/locale_provider.dart';
import '../../models/provider_model.dart';
import '../../models/user_model.dart';
import '../chat/chat_screen.dart';
import 'payment_screen.dart';
import 'tracking_screen.dart';

class ProviderDetailScreen extends StatefulWidget {
  final ProviderModel provider;
  final UserModel customer;
  final bool openChat;

  const ProviderDetailScreen({
    super.key,
    required this.provider,
    required this.customer,
    this.openChat = false,
  });

  @override
  State<ProviderDetailScreen> createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.openChat) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openChat());
    }
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          currentUserId: widget.customer.id,
          otherUserId: widget.provider.id,
          otherUserName: widget.provider.name,
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryGreen),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !mounted) return;

    setState(() {
      _selectedDate = date;
      _selectedTime = time;
    });
  }

  void _confirmBooking() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('select_date_time'))),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          provider: widget.provider,
          customer: widget.customer,
        ),
      ),
    );
  }

  void _cancelOrder() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('cancel_order')),
        content: Text(context.tr('cancel_confirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.tr('no')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(context.tr('yes')),
          ),
        ],
      ),
    );
  }

  Color get _rankColor {
    switch (widget.provider.rank) {
      case 'Gold':
        return AppColors.rankGold;
      case 'Silver':
        return AppColors.rankSilver;
      default:
        return AppColors.rankBronze;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().languageCode;
    final provider = widget.provider;
    final serviceName = locale == 'ur' && provider.serviceTypeUrdu != null
        ? provider.serviceTypeUrdu!
        : provider.serviceType;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (provider.profileImageUrl != null)
                    Image.network(
                      provider.profileImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.primaryGreen.withOpacity(0.2),
                      ),
                    )
                  else
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryGreenDark,
                            AppColors.primaryGreen
                          ],
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.white,
                          backgroundImage: provider.profileImageUrl != null
                              ? NetworkImage(provider.profileImageUrl!)
                              : null,
                          child: provider.profileImageUrl == null
                              ? Text(
                                  provider.name[0],
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGreen),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    provider.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  if (provider.isVerified) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified,
                                        color: AppColors.info, size: 18),
                                  ],
                                ],
                              ),
                              Text(
                                serviceName,
                                style: GoogleFonts.poppins(
                                    color: AppColors.gold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _rankColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            provider.rank,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreenDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.star,
                        color: AppColors.gold,
                        label: provider.rating.toStringAsFixed(1),
                        sub: context.tr('rating'),
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.location_on,
                        color: AppColors.info,
                        label: '${provider.distanceKm.toStringAsFixed(1)} km',
                        sub: context.tr('distance'),
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.attach_money,
                        color: AppColors.success,
                        label: 'Rs. ${provider.pricePerHour.toStringAsFixed(0)}',
                        sub: context.tr('price_per_hour'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Date/Time picker
                  Text(
                    context.tr('select_date_time'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDateTime,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedDate != null
                              ? AppColors.primaryGreen
                              : AppColors.grey300,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).cardTheme.color,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: AppColors.primaryGreen),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate == null
                                ? context.tr('select_date_time')
                                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}  ${_selectedTime?.format(context) ?? ''}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _selectedDate == null
                                  ? AppColors.grey400
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _openChat,
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: Text(context.tr('chat')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call_outlined),
                          label: Text(context.tr('call')),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _confirmBooking,
                      child: Text(context.tr('confirm_booking')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _cancelOrder,
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.error),
                      child: Text(context.tr('cancel_order')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String sub;

  const _StatChip({
    required this.icon,
    required this.color,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              sub,
              style: GoogleFonts.poppins(fontSize: 10, color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
