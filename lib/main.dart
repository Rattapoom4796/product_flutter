import 'package:flutter/material.dart';
import 'package:flutter_lab1_authen/RegisterPage.dart';
import 'login.dart';
import 'package:flutter_lab1_authen/page/admin_page.dart';
import 'package:flutter_lab1_authen/page/edit_page.dart';
import 'package:flutter_lab1_authen/page/post_page.dart';
import 'package:flutter_lab1_authen/page/user_page.dart';
import 'package:flutter_lab1_authen/provider/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => UserProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/admin_page': (context) => AdminPage(),
        '/user_page': (context) => UserPage(),
        '/edit_page': (context) => EditPage(),
        '/post_page': (context) => post_product(),
      },
    );
  }
}
