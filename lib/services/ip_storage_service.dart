import 'package:shared_preferences/shared_preferences.dart';

class IPStorageService {
  static const String _ipKey = 'stored_ip_address';

  /// Save the IP address to shared preferences
  static Future<void> saveIPAddress(String ipAddress) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ipKey, ipAddress);
  }

  /// Retrieve the IP address from shared preferences
  static Future<String?> getIPAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ipKey);
  }

  /// Remove the stored IP address
  static Future<void> removeIPAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ipKey);
  }
}
