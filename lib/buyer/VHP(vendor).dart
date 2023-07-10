import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'BV(vendor).dart';
import 'ST(vendor).dart';
import '/utils/device.dart';

class VendorHomePage extends StatelessWidget {
  const VendorHomePage({Key? key}) : super(key: key);

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
              VendorBaseView(),
            ],
          ),
        ),
      ),
    );
  }
}
