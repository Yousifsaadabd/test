import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';

//import 'package:flutter_application_1/webview.dart';

// ignore: non_constant_identifier_names
class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome '),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
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
        backgroundColor: Colors.white,
        body: const Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}

void main() {
  // WebViewPlatform.instance = WebViewController() as WebViewPlatform?;
  runApp(const MyApp1());
}
