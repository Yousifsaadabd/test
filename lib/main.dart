import 'dart:convert';

// ignore: unused_import
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_application_1/dash.dart';
import 'package:flutter_application_1/widget_test.dart';
//import 'package:flutter_application_1/widget_test.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

const String baseUrl = "https://tickets.evisa.iq";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int? _errorMessage;

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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      if (token != null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const MyApp1()),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token not found in response')),
        );
      }
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
        title: const Text('Login'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        toolbarHeight: 100,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: null, // Indeterminate progress indicator
            backgroundColor: Colors.white,
            color: Colors.blue,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
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
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
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
