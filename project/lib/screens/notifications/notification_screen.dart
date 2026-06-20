import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static final List<Map<String, dynamic>> _notifications = [
    {
      'icon': Icons.check_circle_outline,
      'color': AppColors.success,
      'titleKey': 'booking_confirmed_notif',
      'time': '2 min ago',
      'isRead': false,
    },
    {
      'icon': Icons.directions_bike_outlined,
      'color': AppColors.info,
      'titleKey': 'provider_on_way_notif',
      'time': '15 min ago',
      'isRead': false,
    },
    {
      'icon': Icons.account_balance_wallet_outlined,
      'color': AppColors.primaryGreen,
      'titleKey': 'payment_received_notif',
      'time': '1 hour ago',
      'isRead': true,
    },
    {
      'icon': Icons.cancel_outlined,
      'color': AppColors.error,
      'titleKey': 'order_cancelled_notif',
      'time': '3 hours ago',
      'isRead': true,
    },
    {
      'icon': Icons.check_circle_outline,
      'color': AppColors.success,
      'titleKey': 'booking_confirmed_notif',
      'time': 'Yesterday',
      'isRead': true,
    },
    {
      'icon': Icons.account_balance_wallet_outlined,
      'color': AppColors.primaryGreen,
      'titleKey': 'payment_received_notif',
      'time': 'Yesterday',
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('notifications')),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Clear All',
              style: GoogleFonts.poppins(
                  color: AppColors.gold, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 72),
        itemBuilder: (ctx, i) {
          final notif = _notifications[i];
          return _NotificationTile(
            icon: notif['icon'] as IconData,
            color: notif['color'] as Color,
            title: context.tr(notif['titleKey'] as String),
            time: notif['time'] as String,
            isRead: notif['isRead'] as bool,
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String time;
  final bool isRead;

  const _NotificationTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.time,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRead ? null : color.withOpacity(0.04),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight:
                        isRead ? FontWeight.w400 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.grey500),
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
