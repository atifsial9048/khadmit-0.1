import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/locale_provider.dart';
import '../../models/user_model.dart';
import '../../models/order_model.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';

class ProviderDashboard extends StatefulWidget {
  final UserModel user;

  const ProviderDashboard({super.key, required this.user});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  late List<OrderModel> _orders;
  int _selectedTab = 0;
  static const _tabs = [
    OrderStatus.newOrder,
    OrderStatus.accepted,
    OrderStatus.completed,
    OrderStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    _orders = List.from(mockTodayOrders);
  }

  List<OrderModel> get _filteredOrders =>
      _orders.where((o) => o.status == _tabs[_selectedTab]).toList();

  int get _monthTotal => _orders.length;
  int get _cancelledCount =>
      _orders.where((o) => o.status == OrderStatus.cancelled).length;
  double get _totalEarned => widget.user.totalEarnings;
  double get _avgRating => widget.user.rating;

  void _updateOrderStatus(String id, OrderStatus status) {
    setState(() {
      final idx = _orders.indexWhere((o) => o.id == id);
      if (idx != -1) {
        _orders[idx] = _orders[idx].copyWith(status: status);
      }
    });
  }

  Color get _rankColor {
    switch (widget.user.rank) {
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
    final isUrdu = context.isUrdu;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primaryGreenDark,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationScreen()),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.white),
                onSelected: (v) {
                  if (v == 'profile') {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: widget.user)));
                  } else if (v == 'settings') {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => const SettingsScreen()));
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline),
                        const SizedBox(width: 8),
                        Text(context.tr('profile')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        const Icon(Icons.settings_outlined),
                        const SizedBox(width: 8),
                        Text(context.tr('settings')),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryGreenDark, AppColors.primaryGreen],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.gold,
                          child: Text(
                            widget.user.fullName.isNotEmpty
                                ? widget.user.fullName[0].toUpperCase()
                                : 'P',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreenDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.user.fullName,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                    ),
                                  ),
                                  if (widget.user.isVerified) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified,
                                        color: AppColors.gold, size: 18),
                                  ],
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _rankColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      widget.user.rank,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryGreenDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: AppColors.gold, size: 13),
                                      Text(
                                        ' ${widget.user.rating.toStringAsFixed(1)}',
                                        style: GoogleFonts.poppins(
                                          color: AppColors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              context.tr('total_earnings'),
                              style: GoogleFonts.poppins(
                                color: AppColors.white.withOpacity(0.7),
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              'Rs. ${widget.user.totalEarnings.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tab filter
          SliverToBoxAdapter(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('todays_orders'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(4, (i) {
                        final labels = [
                          context.tr('new_order'),
                          context.tr('accepted'),
                          context.tr('completed'),
                          context.tr('cancelled'),
                        ];
                        final colors = [
                          AppColors.orderNew,
                          AppColors.orderAccepted,
                          AppColors.orderCompleted,
                          AppColors.orderCancelled,
                        ];
                        final count = _orders
                            .where((o) => o.status == _tabs[i])
                            .length;
                        final isSelected = _selectedTab == i;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTab = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors[i]
                                  : colors[i].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  labels[i],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : colors[i],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.3)
                                        : colors[i].withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$count',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Colors.white
                                            : colors[i],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Orders list
          _filteredOrders.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Text('📋', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          context.tr('no_orders'),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final order = _filteredOrders[i];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: _OrderCard(
                          order: order,
                          onAccept: order.status == OrderStatus.newOrder
                              ? () => _updateOrderStatus(
                                  order.id, OrderStatus.accepted)
                              : null,
                          onReject: order.status == OrderStatus.newOrder ||
                                  order.status == OrderStatus.accepted
                              ? () => _updateOrderStatus(
                                  order.id, OrderStatus.cancelled)
                              : null,
                          onComplete: order.status == OrderStatus.accepted
                              ? () => _updateOrderStatus(
                                  order.id, OrderStatus.completed)
                              : null,
                        ),
                      );
                    },
                    childCount: _filteredOrders.length,
                  ),
                ),

          // Analytics
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    context.tr('analytics'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _AnalyticsCard(
                        icon: Icons.receipt_long_outlined,
                        color: AppColors.info,
                        value: '$_monthTotal',
                        label: context.tr('total_orders_month'),
                      ),
                      _AnalyticsCard(
                        icon: Icons.cancel_outlined,
                        color: AppColors.error,
                        value: '$_cancelledCount',
                        label: context.tr('total_cancelled'),
                      ),
                      _AnalyticsCard(
                        icon: Icons.account_balance_wallet_outlined,
                        color: AppColors.success,
                        value: 'Rs. ${_totalEarned.toStringAsFixed(0)}',
                        label: context.tr('total_earned'),
                      ),
                      _AnalyticsCard(
                        icon: Icons.star_outline,
                        color: AppColors.gold,
                        value: _avgRating.toStringAsFixed(1),
                        label: context.tr('avg_rating'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;

  const _OrderCard({
    required this.order,
    this.onAccept,
    this.onReject,
    this.onComplete,
  });

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.newOrder:
        return AppColors.orderNew;
      case OrderStatus.accepted:
        return AppColors.orderAccepted;
      case OrderStatus.completed:
        return AppColors.orderCompleted;
      case OrderStatus.cancelled:
        return AppColors.orderCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      Text(
                        order.serviceType,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.primaryGreen),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    order.status.name,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.grey500),
                Text(
                  ' ${order.distanceKm.toStringAsFixed(1)} km',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.grey500),
                ),
                const Spacer(),
                Text(
                  'Rs. ${order.totalPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            if (onAccept != null || onReject != null || onComplete != null) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onReject != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onReject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(context.tr('reject'),
                            style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                  if (onReject != null &&
                      (onAccept != null || onComplete != null))
                    const SizedBox(width: 8),
                  if (onAccept != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orderAccepted,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(context.tr('accept'),
                            style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                  if (onComplete != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onComplete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orderCompleted,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(context.tr('mark_completed'),
                            style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _AnalyticsCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: color,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.grey500,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
