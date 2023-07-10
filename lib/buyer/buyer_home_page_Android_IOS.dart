import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'baseview_Android_IOS.dart';
import 'settings_tile.dart';
import 'baseview_Android_IOS.dart';

class BuyerHomePage2 extends StatelessWidget {
  const BuyerHomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      // ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ProfileTile(),
              BuyerBaseView(),
            ],
          ),
        ),
      ),
    );
  }
}

