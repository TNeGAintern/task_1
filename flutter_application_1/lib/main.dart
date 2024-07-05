import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dashboard_page.dart';  
import 'upload_image_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/dashboard_page': (context) => DashboardPage(),
        '/upload_image': (context) => ImageUploadPage(),
      },
    );
  }
}
