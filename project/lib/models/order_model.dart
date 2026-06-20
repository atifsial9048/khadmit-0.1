enum OrderStatus { newOrder, accepted, completed, cancelled }

class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String providerId;
  final String providerName;
  final String serviceType;
  final double distanceKm;
  final double totalPrice;
  final OrderStatus status;
  final DateTime createdAt;
  final String? paymentMethod;
  final bool isPaid;

  const OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.providerId,
    required this.providerName,
    required this.serviceType,
    required this.distanceKm,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.paymentMethod,
    this.isPaid = false,
  });

  OrderModel copyWith({OrderStatus? status, bool? isPaid}) {
    return OrderModel(
      id: id,
      customerId: customerId,
      customerName: customerName,
      providerId: providerId,
      providerName: providerName,
      serviceType: serviceType,
      distanceKm: distanceKm,
      totalPrice: totalPrice,
      status: status ?? this.status,
      createdAt: createdAt,
      paymentMethod: paymentMethod,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}

// Mock orders for provider dashboard
final List<OrderModel> mockTodayOrders = [
  OrderModel(
    id: 'o1',
    customerId: 'c1',
    customerName: 'Sara Ahmed',
    providerId: 'p1',
    providerName: 'Muhammad Ali',
    serviceType: 'Plumber',
    distanceKm: 1.2,
    totalPrice: 1680,
    status: OrderStatus.newOrder,
    createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    paymentMethod: 'JazzCash',
    isPaid: true,
  ),
  OrderModel(
    id: 'o2',
    customerId: 'c2',
    customerName: 'Bilal Raza',
    providerId: 'p1',
    providerName: 'Muhammad Ali',
    serviceType: 'Plumber',
    distanceKm: 2.5,
    totalPrice: 2400,
    status: OrderStatus.accepted,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    paymentMethod: 'COD',
    isPaid: false,
  ),
  OrderModel(
    id: 'o3',
    customerId: 'c3',
    customerName: 'Nadia Malik',
    providerId: 'p1',
    providerName: 'Muhammad Ali',
    serviceType: 'Plumber',
    distanceKm: 0.9,
    totalPrice: 1200,
    status: OrderStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    paymentMethod: 'JazzCash',
    isPaid: true,
  ),
  OrderModel(
    id: 'o4',
    customerId: 'c4',
    customerName: 'Kamran Ali',
    providerId: 'p1',
    providerName: 'Muhammad Ali',
    serviceType: 'Plumber',
    distanceKm: 3.2,
    totalPrice: 960,
    status: OrderStatus.cancelled,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    paymentMethod: 'COD',
    isPaid: false,
  ),
];
