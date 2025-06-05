import 'package:flutter/material.dart';
import 'package:flutter_application_1/class.dart';

class CartPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final void Function(CartItem) onRemove;

  const CartPage({super.key, required this.cartItems, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: Text(item.title),
                  subtitle: Text("Quantity: ${item.quantity}"),
                  trailing: Text(
                      "\$${(item.price * item.quantity).toStringAsFixed(2)}"),
                  onLongPress: () => onRemove(item),
                );
              },
            ),
    );
  }
}
