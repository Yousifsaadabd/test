import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/class.dart';
import 'package:flutter_application_1/product_details_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      images: List<String>.from(json['images']),
      category: json['category']['name'],
    );
  }
}

final List<CartItem> cartItems =
    []; // This should ideally be managed by a state management solution
Future<void> addToCart(Product product) async {
  final existingItem = cartItems.firstWhere(
    (item) => item.id == product.id,
    orElse: () => CartItem(
        id: product.id.toString(), title: product.title, price: product.price),
  );

  if (existingItem.id == product.id) {
    existingItem.quantity++;
  } else {
    cartItems.add(CartItem(
      id: product.id.toString(),
      title: product.title,
      price: product.price,
    ));
  }
  await saveCartItems();
}

Future<void> saveCartItems() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> cartJsonList =
      cartItems.map((item) => jsonEncode(item.toJson())).toList();
  await prefs.setStringList('cart_items', cartJsonList);
}

Future<List<CartItem>> loadCartItems() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? cartJsonList = prefs.getStringList('cart_items');

  if (cartJsonList == null) return [];

  return cartJsonList
      .map((itemJson) => CartItem.fromJson(jsonDecode(itemJson)))
      .toList();
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;

  void _filterProducts(String query) {
    final filtered = _products.where((product) {
      final nameLower = product.title.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredProducts = filtered;
    });
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://api.escuelajs.co/api/v1/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      final List<Product> loadedProducts =
          jsonData.map((item) => Product.fromJson(item)).toList();

      if (mounted) {
        setState(() {
          _products = loadedProducts;
          _filteredProducts = loadedProducts;
          _loading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();

    // _searchController.addListener(() {
    //   _filterProducts(_searchController.text);
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.light
                  ? [Colors.blue, Colors.purple]
                  : Theme.of(context).brightness == Brightness.dark
                      ? [Colors.grey.shade800, Colors.grey.shade900]
                      : [Colors.black.withOpacity(0.7), Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(20)), // الزوايا المدورة
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter product name',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _filterProducts(_searchController.text);
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),

          // عرض القائمة
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsPage(product: product),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product.images.isNotEmpty
                                            ? product.images[0]
                                            : '',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.image_not_supported_outlined,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Price: \$${product.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.green),
                                          ),
                                          Text(
                                            'Category: ${product.category}',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
