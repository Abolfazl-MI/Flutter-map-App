// main function
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/controllers/appBinding.dart';
import 'package:tracker/screens/home_screem.dart';

void main() {
  runApp(const MyApp());
}

// stateless widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
