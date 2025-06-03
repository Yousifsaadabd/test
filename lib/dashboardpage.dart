import 'package:flutter/material.dart';
// This widget represents the dashboard page of the application.
// It can include various widgets such as charts, statistics, and other relevant information.

class Dashboardpage extends StatelessWidget {
  // This widget can be customized to include various dashboard elements.
  @override
  Widget build(BuildContext context) {
    return DashboardPage();
  }
}

DashboardPage() {
  return Scaffold(
    appBar: AppBar(
      title: Text('Dashboard'),
    ),
    body: Center(
      child: Text('Welcome to the Dashboard!'),
    ),
  );
}
