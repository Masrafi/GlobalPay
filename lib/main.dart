import 'package:flutter/material.dart';
import 'package:globalpay/utils/ui/home/home.dart';
import 'package:globalpay/utils/ui/login/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => Home(),
        // '/navbar': (context) => NavBar(),
        // '/navbarcategory': (context) => NavBarCategory(),
      },
    );
  }
}
