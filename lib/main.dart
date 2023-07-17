import 'package:flutter/material.dart';
import 'buyer/buyer_home_page_Android_IOS.dart';
import 'buyer/payment(user).dart';
import 'buyer/RP(user).dart';
import 'buyer/HS(home).dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HotSellingsPage(),
    );
  }
}
