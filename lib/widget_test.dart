import 'dart:convert';
//import 'dart:math';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/dash.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/dashboardpage.dart';
import 'package:flutter_application_1/product_details_page.dart';
import 'package:flutter_application_1/setting.dart';
import 'package:flutter_application_1/theme_controller.dart';
//import 'package:flutter_application_1/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//import 'productDetailsPage.dart';
import 'package:flutter_application_1/decoder.dart';

void main() {
  runApp(const MyApp1());
}

Future<void> clearSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // يمسح كل البيانات
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

class TokenDataPage extends StatefulWidget {
  final String token;

  const TokenDataPage({required this.token, super.key});

  @override

  // ignore: library_private_types_in_public_api
  _TokenDataPageState createState() => _TokenDataPageState();
}

class _TokenDataPageState extends State<TokenDataPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  State<MyApp1> createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  bool _loading = true;
  List<Product> _products = [];

  // Future<String?> saveTokenInfoo() async {
  //   return await saveTokenInfoo(token);

  // }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://api.escuelajs.co/api/v1/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      final List<Product> loadedProducts =
          jsonData.map((item) => Product.fromJson(item)).toList();

      setState(() {
        _products = loadedProducts;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: Scaffold(
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: themeMode == ThemeMode.light
                            ? [Colors.blue, Colors.purple]
                            : themeMode == ThemeMode.dark
                                ? [Colors.grey.shade800, Colors.grey.shade900]
                                : [Colors.black.withOpacity(0.7), Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Menu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FutureBuilder<TokenInfo?>(
                          future: getToken().then((token) {
                            if (token == null) return null;
                            final tokenInfo = decodeToken(token);
                            return tokenInfo;
                          }),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return const Center(
                                  child: Text(
                                      'لم يتم العثور على بيانات المستخدم'));
                            } else {
                              final tokenInfo = snapshot.data!;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      // هنا الاسم
                                      ' ${tokenInfo.username}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      //هنا البوزشن
                                      ' ${tokenInfo.position}',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                      ),
                                    ),
                                    // Text(
                                    //     '🕒 تاريخ الانتهاء: ${DateTime.fromMillisecondsSinceEpoch(tokenInfo.exp * 1000)}'),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Toggle Theme'),
                    onTap: () {
                      themeController.toggleTheme();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboardpage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      await clearSharedPrefs();
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              title: const Text('Welcome '),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductsPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // Action when notifications icon is pressed
                  },
                ),
              ],
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(4.0),
                child: SizedBox.shrink(),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: themeMode == ThemeMode.light
                        ? [Colors.blue, Colors.purple]
                        : themeMode == ThemeMode.dark
                            ? [Colors.grey.shade800, Colors.grey.shade900]
                            : [Colors.black.withOpacity(0.7), Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              toolbarHeight: 100,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              shadowColor: Colors.black,
              elevation: 10,
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              actionsIconTheme: const IconThemeData(
                color: Colors.white,
                size: 30,
              ),
              leadingWidth: 50,
              iconTheme: const IconThemeData(
                color: Colors.white,
                size: 30,
              ),
              systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
              ),
              bottomOpacity: 1.0,
              toolbarOpacity: 1.0,
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          itemCount: _products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // عدد الأعمدة
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio:
                                0.5, // تناسب العرض/الارتفاع لكل عنصر
                          ),
                          itemBuilder: (context, index) {
                            final product = _products[index];
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
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (themeMode == ThemeMode.light
                                      ? Colors.white
                                      : themeMode == ThemeMode.dark
                                          ? Colors.grey[800]
                                          : Colors.black.withOpacity(0.7)),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(12)),
                                        child: Image.network(
                                          product.images.isNotEmpty
                                              ? product.images[0]
                                              : '',
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            width: double.infinity,
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              color: Colors.red,
                                              size: 100,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        product.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: themeMode == ThemeMode.light
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        'Price: \$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4),
                                      child: Text(
                                        'Category: ${product.category}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        );
      },
    );
  }
}
