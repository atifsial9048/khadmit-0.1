import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/locale_provider.dart';
import '../../models/user_model.dart';
import '../../models/provider_model.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import 'provider_detail_screen.dart';

class CustomerDashboard extends StatefulWidget {
  final UserModel user;

  const CustomerDashboard({super.key, required this.user});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  late UserModel _currentUser;
  String _selectedCity = 'Karachi';
  String _searchQuery = '';
  String _selectedCategory = 'All';

  bool _isEditingProfile = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _jazzCtrl;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _selectedCity = _currentUser.city;
    _nameCtrl = TextEditingController(text: _currentUser.fullName);
    _phoneCtrl = TextEditingController(text: _currentUser.phone);
    _emailCtrl = TextEditingController(text: _currentUser.email ?? '');
    _jazzCtrl = TextEditingController(text: _currentUser.jazzCashNumber ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _jazzCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() {
      _currentUser = _currentUser.copyWith(
        fullName: _nameCtrl.text,
        phone: _phoneCtrl.text,
        email: _emailCtrl.text,
        jazzCashNumber: _jazzCtrl.text,
        city: _selectedCity,
      );
      _isEditingProfile = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('save')),
        backgroundColor: AppColors.success,
      ),
    );
  }

  static const List<Map<String, dynamic>> _categories = [
    {'icon': '🔧', 'key': 'plumber', 'en': 'Plumber', 'ur': 'پلمبر'},
    {'icon': '⚡', 'key': 'electrician', 'en': 'Electrician', 'ur': 'الیکٹریشن'},
    {'icon': '❄️', 'key': 'ac_repair', 'en': 'AC Repair', 'ur': 'اے سی مرمت'},
    {'icon': '🚗', 'key': 'car_repair', 'en': 'Car Repair', 'ur': 'گاڑی مرمت'},
    {'icon': '🧹', 'key': 'cleaner', 'en': 'Cleaner', 'ur': 'صفائی'},
    {'icon': '💧', 'key': 'water_tanker', 'en': 'Water Tanker', 'ur': 'واٹر ٹینکر'},
    {'icon': '🚖', 'key': 'driver', 'en': 'Driver', 'ur': 'ڈرائیور'},
    {'icon': '🚙', 'key': 'rent_car', 'en': 'Rent Car', 'ur': 'کرایے کی گاڑی'},
    {'icon': '📚', 'key': 'tutor', 'en': 'Tutor', 'ur': 'ٹیوٹر'},
  ];

  static const List<String> _cities = [
    'Karachi', 'Lahore', 'Islamabad', 'Rawalpindi',
    'Faisalabad', 'Peshawar', 'Quetta', 'Multan',
  ];

  List<ProviderModel> get _filteredProviders {
    return mockProviders
        .where((p) => p.city == _selectedCity)
        .where((p) => _selectedCategory == 'All' ||
            p.serviceType == _selectedCategory)
        .where((p) => _searchQuery.isEmpty ||
            p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.serviceType.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList()
      ..sort((a, b) {
        final scoreA = a.pricePerHour + (a.distanceKm * 150.0);
        final scoreB = b.pricePerHour + (b.distanceKm * 150.0);
        return scoreA.compareTo(scoreB);
      });
  }

  Widget _buildDrawer(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final isDark = themeProvider.isDark;
    final isUrdu = localeProvider.isUrdu;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.grey200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.gold,
                        child: Text(
                          _currentUser.fullName.isNotEmpty
                              ? _currentUser.fullName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreenDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentUser.fullName,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '📍 $_selectedCity',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Drawer Body / Fields
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('my_profile').toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey500,
                          letterSpacing: 0.8,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_isEditingProfile) {
                            _saveProfile();
                          } else {
                            setState(() => _isEditingProfile = true);
                          }
                        },
                        child: Text(
                          _isEditingProfile ? context.tr('save') : context.tr('edit_profile'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameCtrl,
                            enabled: _isEditingProfile,
                            decoration: InputDecoration(
                              labelText: context.tr('full_name'),
                              prefixIcon: const Icon(Icons.person_outline),
                              isDense: true,
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _phoneCtrl,
                            enabled: _isEditingProfile,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: context.tr('phone_number'),
                              prefixIcon: const Icon(Icons.phone_outlined),
                              isDense: true,
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _selectedCity,
                            decoration: InputDecoration(
                              labelText: context.tr('city'),
                              prefixIcon: const Icon(Icons.location_city),
                              isDense: true,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                            items: _cities
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: _isEditingProfile
                                ? (v) => setState(() => _selectedCity = v ?? 'Karachi')
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _emailCtrl,
                            enabled: _isEditingProfile,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: context.tr('email'),
                              prefixIcon: const Icon(Icons.email_outlined),
                              isDense: true,
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _jazzCtrl,
                            enabled: _isEditingProfile,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: context.tr('add_jazzcash'),
                              prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                              isDense: true,
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Preferences
                  Text(
                    context.tr('appearance').toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey500,
                      letterSpacing: 0.8,
                    ),
                  ),
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
                            isDark ? context.tr('dark_mode') : context.tr('light_mode'),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          activeColor: AppColors.primaryGreen,
                          dense: true,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.language, color: AppColors.primaryGreen),
                          title: Text(
                            isUrdu ? 'English' : 'اردو',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          trailing: const Icon(Icons.swap_horiz),
                          dense: true,
                          onTap: () => localeProvider.setLocale(isUrdu ? 'en' : 'ur'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Support
                  Text(
                    'SUPPORT & LEGAL',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey500,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.notifications_outlined, color: AppColors.primaryGreen),
                          title: Text(
                            context.tr('notifications'),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                          dense: true,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const NotificationScreen()),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primaryGreen),
                          title: Text(
                            context.tr('privacy_policy'),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                          dense: true,
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.contact_support_outlined, color: AppColors.primaryGreen),
                          title: Text(
                            'Contact Us',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                          dense: true,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Contact Details'),
                                content: const Text(
                                  'Name: M. Atif\n'
                                  'Phone: 03085228520\n'
                                  'Email: atifsial5510@gmail.com\n'
                                  'City: Islamabad\n'
                                  'Address: Islamabad',
                                  style: TextStyle(height: 1.5),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Logout
                  OutlinedButton.icon(
                    onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: AppColors.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = context.isUrdu;
    final locale = context.watch<LocaleProvider>().languageCode;

    return Scaffold(
      drawer: _buildDrawer(context),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryGreen,
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: AppColors.white, size: 24),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.white, size: 22),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                ),
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
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'KHADMAT',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.gold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_currentUser.fullName.split(' ').first}، آپ کو کونسی خدمت چاہیے؟',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Container(
                height: 56,
                color: AppColors.primaryGreen,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: context.tr('search'),
                    filled: true,
                    fillColor: AppColors.white,
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.grey400),
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // City selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.location_city,
                      color: AppColors.primaryGreen, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCity,
                        isExpanded: true,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        items: _cities
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedCity = v ?? 'Karachi';
                            _currentUser = _currentUser.copyWith(city: _selectedCity);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                context.tr('categories'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),

          // Categories horizontal scroll
          SliverToBoxAdapter(
            child: SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (ctx, i) {
                  final cat = _categories[i];
                  final isSelected = _selectedCategory == cat['en'];
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedCategory =
                          isSelected ? 'All' : cat['en'] as String;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 72,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen
                                .withOpacity(isSelected ? 0.3 : 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cat['icon'] as String,
                              style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          Text(
                            cat[locale] as String? ?? cat['en'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.white
                                  : Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Nearby Providers header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('nearby_providers'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${_filteredProviders.length} found',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.primaryGreen),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Providers list
          _filteredProviders.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          context.tr('no_providers'),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: _ProviderListCard(
                        provider: _filteredProviders[i],
                        locale: locale,
                        onBook: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProviderDetailScreen(
                              provider: _filteredProviders[i],
                              customer: widget.user,
                            ),
                          ),
                        ),
                        onChat: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProviderDetailScreen(
                              provider: _filteredProviders[i],
                              customer: widget.user,
                              openChat: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    childCount: _filteredProviders.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _ProviderListCard extends StatelessWidget {
  final ProviderModel provider;
  final String locale;
  final VoidCallback onBook;
  final VoidCallback onChat;

  const _ProviderListCard({
    required this.provider,
    required this.locale,
    required this.onBook,
    required this.onChat,
  });

  Color get _rankColor {
    switch (provider.rank) {
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
    final serviceName = locale == 'ur' && provider.serviceTypeUrdu != null
        ? provider.serviceTypeUrdu!
        : provider.serviceType;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.grey200,
                      backgroundImage: provider.profileImageUrl != null
                          ? NetworkImage(provider.profileImageUrl!)
                          : null,
                      child: provider.profileImageUrl == null
                          ? Text(provider.name[0],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))
                          : null,
                    ),
                    if (provider.isVerified)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check,
                              size: 10, color: Colors.white),
                        ),
                      ),
                  ],
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
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _rankColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              provider.rank,
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: _rankColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        serviceName,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.gold, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          provider.rating.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${provider.distanceKm.toStringAsFixed(1)} km',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.grey500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Rs. ${provider.pricePerHour.toStringAsFixed(0)}/hr',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                      fontSize: 14,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onChat,
                  icon: const Icon(Icons.chat_bubble_outline, size: 14),
                  label: Text(context.tr('chat'),
                      style: const TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onBook,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(context.tr('book'),
                      style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
