import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const _nameKey = 'profile_name';
  static const _emailKey = 'profile_email';
  static const _phoneKey = 'profile_phone';
  static const _vehicleKey = 'profile_vehicle';

  Future<Map<String, String>> loadProfile({String? fallbackPhone}) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey) ?? 'Delivery Partner',
      'email': prefs.getString(_emailKey) ?? 'partner@example.com',
      'phone': prefs.getString(_phoneKey) ?? (fallbackPhone ?? ''),
      'vehicle': prefs.getString(_vehicleKey) ?? 'Two-wheeler',
    };
  }

  Future<void> saveProfile({
    required String name,
    required String email,
    required String phone,
    required String vehicle,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name.trim());
    await prefs.setString(_emailKey, email.trim());
    await prefs.setString(_phoneKey, phone.trim());
    await prefs.setString(_vehicleKey, vehicle.trim());
  }
}

