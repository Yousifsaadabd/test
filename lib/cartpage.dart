import 'package:flutter/material.dart';
import 'cart_utils.dart';
import 'class.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    cartItems = await loadCartItems();
    setState(() {});
  }

  void removeItem(CartItem item) async {
    setState(() {
      cartItems.remove(item);
    });
    await saveCartItems(cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("السلة")),
      body: cartItems.isEmpty
          ? const Center(child: Text("السلة فارغة"))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: Text(item.title),
                  subtitle: Text("الكمية: ${item.quantity}"),
                  trailing: Text(
                    "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                  ),
                  onLongPress: () => removeItem(item),
                );
              },
            ),
    );
  }
}
