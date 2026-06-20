enum UserRole { customer, provider }

class UserModel {
  final String id;
  final String fullName;
  final String phone;
  final String city;
  final String? email;
  final String? profileImageUrl;
  final UserRole role;
  final bool isVerified;
  final double rating;
  final String rank; // Gold, Silver, Bronze
  final double totalEarnings;
  final String? jazzCashNumber;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.city,
    this.email,
    this.profileImageUrl,
    required this.role,
    this.isVerified = false,
    this.rating = 0.0,
    this.rank = 'Bronze',
    this.totalEarnings = 0.0,
    this.jazzCashNumber,
  });

  UserModel copyWith({
    String? fullName,
    String? phone,
    String? city,
    String? email,
    String? profileImageUrl,
    bool? isVerified,
    double? rating,
    String? rank,
    double? totalEarnings,
    String? jazzCashNumber,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      rank: rank ?? this.rank,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      jazzCashNumber: jazzCashNumber ?? this.jazzCashNumber,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'fullName': fullName,
    'phone': phone,
    'city': city,
    'email': email,
    'profileImageUrl': profileImageUrl,
    'role': role.name,
    'isVerified': isVerified,
    'rating': rating,
    'rank': rank,
    'totalEarnings': totalEarnings,
    'jazzCashNumber': jazzCashNumber,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] ?? '',
    fullName: map['fullName'] ?? '',
    phone: map['phone'] ?? '',
    city: map['city'] ?? '',
    email: map['email'],
    profileImageUrl: map['profileImageUrl'],
    role: UserRole.values.firstWhere(
      (r) => r.name == map['role'],
      orElse: () => UserRole.customer,
    ),
    isVerified: map['isVerified'] ?? false,
    rating: (map['rating'] ?? 0.0).toDouble(),
    rank: map['rank'] ?? 'Bronze',
    totalEarnings: (map['totalEarnings'] ?? 0.0).toDouble(),
    jazzCashNumber: map['jazzCashNumber'],
  );
}
