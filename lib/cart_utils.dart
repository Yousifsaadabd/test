import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'class.dart';

Future<List<CartItem>> loadCartItems() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? cartJsonList = prefs.getStringList('cart_items');

  if (cartJsonList == null) return [];

  return cartJsonList
      .map((item) => CartItem.fromJson(jsonDecode(item)))
      .toList();
}

Future<void> saveCartItems(List<CartItem> items) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> cartJsonList =
      items.map((item) => jsonEncode(item.toJson())).toList();
  await prefs.setStringList('cart_items', cartJsonList);
}
