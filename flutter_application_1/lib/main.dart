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
<<<<<<< HEAD
        '/upload_image': (context) => ImageUploadPage(), // Provide a default value or handle this dynamically
=======
        '/upload_image': (context) => ImageUploadPage(),
>>>>>>> 2a1e7452851452c7c11c56a0bf670ce861913937
      },
    );
  }
}
