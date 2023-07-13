import 'package:flutter/material.dart';
import 'package:gap/buyer/HS(home).dart';
import 'package:gap/buyer/HS(user).dart';
import 'package:gap/buyer/HS(vendor).dart';

import 'buyer/buyer_home_page_Android_IOS.dart';
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
      // home:usSellingsPage(),
      // home:venSellingsPage(),
      home: HotSellingsPage(),
      
    );
  }
}
 