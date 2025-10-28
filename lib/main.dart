import 'package:flutter/material.dart';
import 'package:mobile_course_fp/views/home.dart';
import 'package:mobile_course_fp/views/inventory_page.dart';
import 'package:mobile_course_fp/views/profile_page.dart';
import 'package:mobile_course_fp/views/splash_screen.dart';
import 'package:mobile_course_fp/views/suppliers_page.dart';
import 'package:mobile_course_fp/views/user_management_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmaEase',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/inventory': (context) =>  InventoryPage(),
        '/supplier': (context) => SuppliersPage(),
        '/profile': (context) => ProfilePage(),
        '/users': (context) => UserManagementPage()
      },
    );
  }
}
