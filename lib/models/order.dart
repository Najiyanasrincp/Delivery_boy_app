import 'product.dart';

enum OrderStatus {
  pending,
  assigned,
  inTransit,
  delivered,
  cancelled,
}

class Order {
  /// mockapi.io record id (not the business orderId)
  final String? apiId;
  final String orderId;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final DateTime deliveryTime;
  final double distance; // in kilometers
  final double? latitude;
  final double? longitude;
  final List<Product> products;
  final OrderStatus status;
  final double totalAmount;
  final String? specialInstructions;

  Order({
    this.apiId,
    required this.orderId,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.deliveryTime,
    required this.distance,
    this.latitude,
    this.longitude,
    required this.products,
    this.status = OrderStatus.assigned,
    required this.totalAmount,
    this.specialInstructions,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] ?? json['items'] ?? [];
    final products = (productsJson as List)
        .map((item) => Product.fromJson(item))
        .toList();

    OrderStatus status = OrderStatus.assigned;
    if (json['status'] != null) {
      final statusStr = json['status'].toString().toLowerCase();
      status = OrderStatus.values.firstWhere(
        (s) => s.toString().split('.').last == statusStr,
        orElse: () => OrderStatus.assigned,
      );
    }

    return Order(
      apiId: json['id']?.toString(),
      orderId: json['orderId'] ?? json['order_id'] ?? '',
      customerName: json['customerName'] ?? json['customer_name'] ?? '',
      customerAddress: json['customerAddress'] ?? json['customer_address'] ?? '',
      customerPhone: json['customerPhone'] ?? json['customer_phone'] ?? '',
      deliveryTime: json['deliveryTime'] != null
          ? DateTime.parse(json['deliveryTime'])
          : json['delivery_time'] != null
              ? DateTime.parse(json['delivery_time'])
              : DateTime.now(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      products: products,
      status: status,
      totalAmount: (json['totalAmount'] ?? json['total_amount'] ?? 0.0).toDouble(),
      specialInstructions: json['specialInstructions'] ?? json['special_instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': apiId,
      'orderId': orderId,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerPhone': customerPhone,
      'deliveryTime': deliveryTime.toIso8601String(),
      'distance': distance,
      'latitude': latitude,
      'longitude': longitude,
      'products': products.map((p) => p.toJson()).toList(),
      'status': status.toString().split('.').last,
      'totalAmount': totalAmount,
      'specialInstructions': specialInstructions,
    };
  }

  Order copyWith({
    String? apiId,
    String? orderId,
    String? customerName,
    String? customerAddress,
    String? customerPhone,
    DateTime? deliveryTime,
    double? distance,
    double? latitude,
    double? longitude,
    List<Product>? products,
    OrderStatus? status,
    double? totalAmount,
    String? specialInstructions,
  }) {
    return Order(
      apiId: apiId ?? this.apiId,
      orderId: orderId ?? this.orderId,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      distance: distance ?? this.distance,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      products: products ?? this.products,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

