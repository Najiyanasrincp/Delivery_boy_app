import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/order.dart';
import '../config/api_config.dart';
import 'auth_service.dart';

class OrderService {
  final AuthService _authService = AuthService();
  static const String _deliveredOrdersKey = 'delivered_orders';

  // Calculate distance from current location to order location
  Future<double> calculateDistance(
    double currentLat,
    double currentLon,
    double orderLat,
    double orderLon,
  ) async {
    return Geolocator.distanceBetween(
      currentLat,
      currentLon,
      orderLat,
      orderLon,
    ) / 1000; // Convert meters to kilometers
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  // Fetch orders from mockapi.io
  Future<List<Order>> getOrders() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    try {
      // Fetch orders from mockapi.io
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          // Add token if your API requires it
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final orders = data.map((json) => Order.fromJson(json)).toList();
        
        // Filter out delivered orders
        final deliveredOrders = await _getDeliveredOrders();
        final activeOrders = orders.where(
          (order) => order.status != OrderStatus.delivered && 
                     !deliveredOrders.contains(order.orderId),
        ).toList();
        
        // Calculate distances from current location
        final currentLocation = await getCurrentLocation();
        if (currentLocation != null) {
          final ordersWithDistance = await Future.wait(
            activeOrders.map((order) async {
              if (order.latitude != null && order.longitude != null) {
                final distance = await calculateDistance(
                  currentLocation.latitude,
                  currentLocation.longitude,
                  order.latitude!,
                  order.longitude!,
                );
                return order.copyWith(distance: distance);
              }
              return order;
            }),
          );
          return ordersWithDistance;
        }
        
        return activeOrders;
      }
      
      // If API fails, throw error
      throw Exception('Failed to fetch orders: ${response.statusCode}');
    } catch (e) {
      // Re-throw the error - no fallback to dummy data
      throw Exception('Error fetching orders from API: $e');
    }
  }

  // Fetch delivered orders from mockapi.io
  Future<List<Order>> getDeliveredOrders() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final orders = data.map((json) => Order.fromJson(json)).toList();

        final delivered = orders.where(
          (order) => order.status == OrderStatus.delivered,
        );

        final currentLocation = await getCurrentLocation();
        if (currentLocation != null) {
          final withDistance = await Future.wait(
            delivered.map((order) async {
              if (order.latitude != null && order.longitude != null) {
                final distance = await calculateDistance(
                  currentLocation.latitude,
                  currentLocation.longitude,
                  order.latitude!,
                  order.longitude!,
                );
                return order.copyWith(distance: distance);
              }
              return order;
            }),
          );
          return withDistance;
        }

        return delivered.toList();
      }

      throw Exception('Failed to fetch delivered orders: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching delivered orders from API: $e');
    }
  }

  // Get list of delivered order IDs from local storage
  Future<Set<String>> _getDeliveredOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deliveredJson = prefs.getString(_deliveredOrdersKey);
      if (deliveredJson != null) {
        final List<dynamic> deliveredList = json.decode(deliveredJson);
        return deliveredList.map((id) => id.toString()).toSet();
      }
    } catch (e) {
      // Ignore errors
    }
    return <String>{};
  }

  // Mark order as delivered via mockapi.io
  Future<bool> markAsDelivered(Order order) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    try {
      // Update order status via mockapi.io
      final pathId = order.apiId ?? order.orderId;
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.markDeliveredEndpoint(pathId)}'),
        headers: {
          'Content-Type': 'application/json',
          // Add token if your API requires it
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'status': 'delivered',
          'deliveredAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update local storage as backup
        await _saveDeliveredOrder(order.orderId);
        return true;
      }

      // Non‑success status: treat as failure
      throw Exception('Failed with status ${response.statusCode}');
    } catch (e) {
      // Bubble up error, do NOT mark locally
      throw Exception('Error updating order status: $e');
    }
  }

  // Save delivered order ID to local storage
  Future<void> _saveDeliveredOrder(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deliveredOrders = await _getDeliveredOrders();
      deliveredOrders.add(orderId);
      final deliveredJson = json.encode(deliveredOrders.toList());
      await prefs.setString(_deliveredOrdersKey, deliveredJson);
    } catch (e) {
      // Ignore errors
    }
  }

  // Get order by ID from mockapi.io using apiId/path id
  Future<Order?> getOrderById(String apiId) async {
    final token = await _authService.getToken();
    if (token == null) {
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orderByIdEndpoint(apiId)}'),
        headers: {
          'Content-Type': 'application/json',
          // Add token if your API requires it
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Order.fromJson(data);
      }
      
      // Order not found
      return null;
    } catch (e) {
      // Re-throw the error - no fallback
      throw Exception('Error fetching order from API: $e');
    }
  }
}

