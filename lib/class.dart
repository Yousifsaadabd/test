// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Product {
//   final int id;
//   final String title;
//   final String description;
//   final double price;
//   final List<String> images;
//   final String category;

//   Product({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.price,
//     required this.images,
//     required this.category,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       price: (json['price'] as num).toDouble(),
//       images: List<String>.from(json['images']),
//       category: json['category']['name'],
//     );
//   }
// }

// class ProductsPage extends StatefulWidget {
//   const ProductsPage({super.key});

//   @override
//   State<ProductsPage> createState() => _ProductsPageState();
// }

// class _ProductsPageState extends State<ProductsPage> {
//   // ignore: unused_field
//   List<Product> _products = [];
//   List<Product> _filteredProducts = [];
//   bool _loading = true;

//   Future<void> fetchProducts() async {
//     final url = Uri.parse('https://api.escuelajs.co/api/v1/products');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final List jsonData = jsonDecode(response.body);
//       final List<Product> loadedProducts =
//           jsonData.map((item) => Product.fromJson(item)).toList();

//       setState(() {
//         _products = loadedProducts;
//         _filteredProducts = loadedProducts; 
//       });
//     } else {
//       setState(() {
//         _loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Prod33ucts')),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _filteredProducts.length,
//               itemBuilder: (context, index) {
//                 final product = _filteredProducts[index];
//                 return ListTile(
//                   title: Text(product.title),
//                   subtitle: Text(product.description),
//                 );
//               },
//             ),
//     );
//   }
// }
//  _loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _filteredProducts.isEmpty
//                     ? const Center(
//                         child: Text(
//                           'No products found',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                           textAlign: TextAlign.center,
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: _filteredProducts.length,
//                         itemBuilder: (context, index) {
//                           final product = _filteredProducts[index];
//                           return Card(
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 6),
//                             elevation: 3,
//                             child: ListTile(
//                               leading: Image.network(
//                                 product.images.isNotEmpty
//                                     ? product.images[0]
//                                     : '',
//                                 width: 60,
//                                 height: 60,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     Container(
//                                   width: 60,
//                                   height: 60,
//                                   color: Colors.grey[30],
//                                   child: const Icon(
//                                       Icons.image_not_supported_outlined,
//                                       color: Colors.red,
//                                       size: 30),
//                                 ),
//                               ),
//                               title: Text(product.title.toUpperCase(),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold)),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                       'Price:\$${product.price.toStringAsFixed(2)}'),
//                                   Text('Category: ${product.category}'),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),