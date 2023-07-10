import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'BV(user).dart';
// import 'package:gap/ui/buyer/apr/settings_tile.dart';
import '/utils/device.dart';
import 'ST(user).dart';

class BuyerHomePage3 extends StatelessWidget {
  const BuyerHomePage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightFactor = DeviceUtils.getHeightFactor(context);

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
                height: 20 * heightFactor,
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
