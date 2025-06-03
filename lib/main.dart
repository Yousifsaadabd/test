import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/theme_controller.dart';

import 'decoder.dart';
// ignore: unused_import
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_application_1/dash.dart';
import 'package:flutter_application_1/widget_test.dart';

// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "https://172.16.91.13";

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Simple Login',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: const LoginPage(),
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class Loggginemail extends StatefulWidget {
  const Loggginemail({super.key, String? loggedInEmail});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);

  if (kDebugMode) {
    print('Token 0000saved: $token');
  }
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int? _errorMessage;
  String? loggedInEmail;

  String? token;

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('$baseUrl/api/account/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': email,
        'password': password,
      }),
    );

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
    }
    setState(() {
      _errorMessage = response.statusCode;
    });
    if (kDebugMode) {
      print('Response body: ${response.body}');
    }
    if (kDebugMode) {
      decodeToken(response.body);
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await saveToken(token);

      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const MyApp1()),
      );

// ignore: unused_element

      // decodeToken(token);
      // if (kDebugMode) {
      //   print('name saved: ${decodeToken(token)?.nameId}'
      //       '\nusername saved: ${decodeToken(token)?.username}'
      //       '\nposition saved: ${decodeToken(token)?.position}'
      //       // '\nexp saved: ${saveToken(token)}'
      //       );
      // }
    }
  }

  @override
  void initState() {
    //هاي تحدث الصفحه اثناء الادخال
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });
  }

  void initState1() {
    //هاي تحدث الصفحه اثناء الادخال
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.brightness_6),
        //     onPressed: () {
        //       themeController.toggleTheme();
        //     },
        //   ),
        // ],
        title: const Text('Login'),
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
        toolbarHeight: 100,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {});
              },
              style: const TextStyle(fontSize: 18),
              controller: _emailController,
              decoration: InputDecoration(
                icon: const Icon(Icons.email),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_emailController.text.isEmpty) ...const [
                      // Show warning icon and text if password is empty
                      Icon(Icons.warning, color: Colors.red, size: 16),
                      Text('Username'),
                      Text(
                        ' (required)',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ] else ...const [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      Text('Username'),
                    ]
                  ],
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: _emailController.text.isEmpty
                      ? const BorderSide(color: Colors.red, width: 2.0)
                      : const BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              cursorRadius: const Radius.circular(8.0),
            ),
            const SizedBox(height: 12),
            TextFormField(
              onChanged: (value) {
                setState(() {});
              },
              style: const TextStyle(fontSize: 18),
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password cannot be empty'; // Validation for empty password
                }
                return null;
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.lock),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_passwordController.text.isEmpty) ...[
                      // Show warning icon and text if password is empty
                      const Icon(Icons.warning, color: Colors.red, size: 16),
                      const Text('Password'),
                      const Text(
                        ' (required)',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ] else ...[
                      const Icon(Icons.lock_open,
                          color: Colors.green, size: 16),
                      const Text('Password'),
                    ]
                  ],
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: _passwordController.text.isEmpty
                      ? const BorderSide(color: Colors.red, width: 2.0)
                      : const BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            const SizedBox(width: 100.0, height: 24),
            Stack(
              children: [
                if (_errorMessage == 400)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Invalid request, please check your input', // Error message for 400
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (_errorMessage == 401)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Invalid User or Password', // Error message for 401
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (_errorMessage == 403)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Access denied, please check your permissions', // Error message for 403
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (_errorMessage == 500)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Server error, please try again later', // Error message for 500
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (_errorMessage == 521)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Web server is down, please try again later', // Error message for 521
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 100.0, height: 24),
            ElevatedButton(
              onPressed: (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty)
                  ? null
                  : _login, // Disable button if fields are empty

              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
    return scaffold;
  }
}
