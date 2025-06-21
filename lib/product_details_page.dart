import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cartpage.dart';
import 'package:flutter_application_1/class.dart';
import 'package:flutter_application_1/cart_utils.dart' as cart_utils;
import 'package:flutter_application_1/dash.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  Future<void> addToCart(Product product, BuildContext context) async {
    List<CartItem> cartItems = await cart_utils.loadCartItems();

    final index =
        cartItems.indexWhere((item) => item.id == product.id.toString());
    if (index != -1) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(CartItem(
        id: product.id.toString(),
        title: product.title,
        price: product.price,
        quantity: 1,
      ));
    }

    await cart_utils.saveCartItems(cartItems);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تمت إضافة المنتج إلى السلة")),
    );
  }

  void openCartPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المنتج')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.images.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: product.images.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.red,
                              size: 100,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              )
            else
              const Center(
                child: Icon(Icons.image_not_supported,
                    size: 150, color: Colors.grey),
              ),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Category: ${product.category}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 20),
            const Text(
              'الوصف:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => addToCart(product, context),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("إضافة إلى السلة"),
                ),
                ElevatedButton.icon(
                  onPressed: () => openCartPage(context),
                  icon: const Icon(Icons.shopping_cart_checkout),
                  label: const Text("عرض السلة"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
