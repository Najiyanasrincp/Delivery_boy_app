import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _phoneKey = 'phone_number';
  
  // Mock OTP - hardcoded for testing (fallback if API fails)
  static const String mockOtp = '123456';
  
  // Store token in local session
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  
  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  // Store phone number
  Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, phoneNumber);
  }
  
  // Get stored phone number
  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }
  
  // Send OTP via mockapi.io
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.sendOtpEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'phoneNumber': phoneNumber,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      
      // If API fails, return true anyway (for development)
      return true;
    } catch (e) {
      // If API fails, return true anyway (for development)
      // In production, you might want to return false
      return true;
    }
  }
  
  // Verify OTP via mockapi.io
  Future<String?> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.verifyOtpEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'phoneNumber': phoneNumber,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final token = responseData['token'] ?? 
                     responseData['accessToken'] ?? 
                     'token_${DateTime.now().millisecondsSinceEpoch}';
        
        await saveToken(token);
        await savePhoneNumber(phoneNumber);
        return token;
      }
      
      // Fallback to mock OTP if API fails
      if (otp == mockOtp) {
        final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        await saveToken(token);
        await savePhoneNumber(phoneNumber);
        return token;
      }
      
      return null;
    } catch (e) {
      // Fallback to mock OTP if API fails
      if (otp == mockOtp) {
        final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        await saveToken(token);
        await savePhoneNumber(phoneNumber);
        return token;
      }
      return null;
    }
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_phoneKey);
  }
}

