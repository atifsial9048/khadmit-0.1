import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/provider_model.dart';
import '../../models/user_model.dart';

class TrackingScreen extends StatefulWidget {
  final ProviderModel provider;
  final UserModel customer;

  const TrackingScreen({super.key, required this.provider, required this.customer});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late LatLng _providerLocation;
  late LatLng _customerLocation;
  late MapController _mapController;
  Timer? _movementTimer;
  int _etaMinutes = 12;
  bool _orderCompleted = false;
  bool _orderCancelled = false;
  bool _showRateDialog = false;
  double _rating = 0;
  final _reviewCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _providerLocation =
        LatLng(widget.provider.lat, widget.provider.lng);
    _customerLocation =
        LatLng(widget.provider.lat + 0.02, widget.provider.lng + 0.01);

    _movementTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_orderCompleted || _orderCancelled) return;
      setState(() {
        _providerLocation = LatLng(
          _providerLocation.latitude +
              (_customerLocation.latitude - _providerLocation.latitude) * 0.05,
          _providerLocation.longitude +
              (_customerLocation.longitude - _providerLocation.longitude) * 0.05,
        );
        if (_etaMinutes > 0) _etaMinutes--;

        // Simulate completion when ETA reaches 0
        if (_etaMinutes == 0 && !_orderCompleted) {
          _orderCompleted = true;
          _showRateDialog = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    _reviewCtrl.dispose();
    super.dispose();
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
              setState(() => _orderCancelled = true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(context.tr('yes')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('tracking')),
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                (_providerLocation.latitude + _customerLocation.latitude) / 2,
                (_providerLocation.longitude + _customerLocation.longitude) / 2,
              ),
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.khadmat.pakistan',
              ),
              MarkerLayer(
                markers: [
                  // Customer - blue dot
                  Marker(
                    point: _customerLocation,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.info,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.info.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  // Provider - green dot (moving)
                  Marker(
                    point: _providerLocation,
                    width: 48,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.engineering,
                          color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Info Panel at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  if (_orderCancelled)
                    _CancelledPanel()
                  else if (_orderCompleted && _showRateDialog)
                    _RatePanel(
                      rating: _rating,
                      onRatingChanged: (r) => setState(() => _rating = r),
                      reviewCtrl: _reviewCtrl,
                      onSubmit: () {
                        setState(() => _showRateDialog = false);
                        Navigator.pop(context);
                      },
                    )
                  else ...[
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.engineering,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.provider.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                context.tr('provider_on_way'),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.grey500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$_etaMinutes ${context.tr('minutes')}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryGreen,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              context.tr('estimated_arrival'),
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: AppColors.grey500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.call_outlined, size: 16),
                            label: Text(widget.provider.phone,
                                style: const TextStyle(fontSize: 11)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _cancelOrder,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error),
                            child: Text(context.tr('cancel_order'),
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Map legend
          Positioned(
            top: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Legend(color: AppColors.info, label: context.tr('hello')),
                const SizedBox(height: 4),
                _Legend(
                    color: AppColors.primaryGreen,
                    label: widget.provider.name),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.poppins(fontSize: 11)),
        ],
      ),
    );
  }
}

class _CancelledPanel extends StatelessWidget {
  const _CancelledPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.cancel, color: AppColors.error, size: 48),
        const SizedBox(height: 8),
        Text(
          context.tr('order_cancelled_notif'),
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            context.tr('refund_processing'),
            style: GoogleFonts.poppins(
                color: AppColors.warning, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('go_to_dashboard')),
        ),
      ],
    );
  }
}

class _RatePanel extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final TextEditingController reviewCtrl;
  final VoidCallback onSubmit;

  const _RatePanel({
    required this.rating,
    required this.onRatingChanged,
    required this.reviewCtrl,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.tr('rate_provider'),
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            return GestureDetector(
              onTap: () => onRatingChanged((i + 1).toDouble()),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  i < rating ? Icons.star : Icons.star_border,
                  color: AppColors.gold,
                  size: 36,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: reviewCtrl,
          decoration: InputDecoration(
            hintText: context.tr('write_review'),
            filled: true,
            fillColor: Theme.of(context).cardTheme.color,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSubmit,
            child: Text(context.tr('submit_review')),
          ),
        ),
      ],
    );
  }
}
