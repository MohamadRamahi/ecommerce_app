import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/saved_address.dart';

class AddressStorage {
  static const String key = 'saved_addresses';

  static Future<void> saveAddresses(List<SavedAddress> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(addresses.map((a) => a.toJson()).toList());
    await prefs.setString(key, encoded);
  }

  static Future<List<SavedAddress>> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => SavedAddress.fromJson(e)).toList();
  }
}
