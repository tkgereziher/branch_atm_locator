class ApiConstants {
  // On Android emulator, 10.0.2.2 maps to the host machine's localhost.
  // Change to your machine's LAN IP (e.g. 192.168.x.x:3000) for a physical device.
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const String loginEndpoint = '/auth/login';
  static const String profileEndpoint = '/user/profile';
  static const String locationsEndpoint = '/locations';
  static const String reportsEndpoint = '/reports';
  static const String banksEndpoint = '/banks';
}
