class ApiConfig {
  // Replace 'your-project-id' with your actual mockapi.io project ID
  // Get your project ID from https://mockapi.io/projects
  static const String baseUrl = 'https://6944e4617dd335f4c36187ef.mockapi.io/api/v1';
  
  // Auth endpoints
  static const String sendOtpEndpoint = '/auth/send-otp';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  
  // Order endpoints
  static const String ordersEndpoint = '/orders';
  static String orderByIdEndpoint(String orderId) => '/orders/$orderId';
  static String markDeliveredEndpoint(String orderId) => '/orders/$orderId';
}

