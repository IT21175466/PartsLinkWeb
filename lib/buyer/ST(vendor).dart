import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:gap/pallete.dart';
// import 'package:gap/ui/vender/profile.dart';
import '/utils/device.dart';
import 'package:path_provider/path_provider.dart';
import 'VS(vendor).dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:html' as html;
class ProfileTile extends StatelessWidget {
  // ...

  Future<String> fetchData() async {
    final storage = html.window.localStorage;
    String? storedData = storage['data2.json'];
    if (storedData != null) {
      List<dynamic> dataList = json.decode(storedData) as List<dynamic>;
      for (var item in dataList) {
        String id = item['id'] as String;
        String username = item['company_name'] as String;
        String email = item['email'] as String;
        String mobile = item['mobile'] as String;
        String password = item['password'] as String;
        print('$id, $username');
        return username;
        // Do something with the retrieved data
      }
    }
    return "";

  }

  @override
  Widget build(BuildContext context) {
    final widthFactor = DeviceUtils.getWidthFactor(context);
    final heightFactor = DeviceUtils.getHeightFactor(context);

    return FutureBuilder<String>(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Display a loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String username = snapshot.data ?? "";
          List<String> words = username.split(' ');
          String nameCompany = (words.length > 1) ? words.first : username;

          return SafeArea(
            minimum: EdgeInsets.only(top: 16, bottom: 8),
            child: Column(
              children: [
                ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VendorSetting()),
                      );
                    },
                    child: SizedBox(
                      width: 50 * widthFactor,
                      height: 50 * heightFactor,
                      child: Image.asset("assets/settings.png"),
                    ),
                  ),
                  trailing: SizedBox(
                    width: 300 * widthFactor,
                    height: 67 * widthFactor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              child: AutoSizeText(
                                'Hola, $nameCompany 👋',
                                style: TextStyle(fontSize: 20),
                                minFontSize: 18,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ],
            ),
          );
        }
      },
    );
  }
}
