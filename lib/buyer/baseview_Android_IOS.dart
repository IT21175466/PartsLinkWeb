import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/utils/device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class BuyerBaseView extends StatefulWidget {
  @override
  _BuyerBaseViewState createState() => _BuyerBaseViewState();
}
class _BuyerBaseViewState extends State<BuyerBaseView> {
  List<dynamic> carouselItems = [];
  int _currentSlide = 0;
  void initState() {
    super.initState();
    fetchCarouselData();
  }

  Future<void> fetchCarouselData() async {
    final Uri url = Uri.parse("https://my.partscart.lk/carousel.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        carouselItems = data;
      });
    } else {
      // Handle error
    }
  }
  @override
  Widget build(BuildContext context) {
    final heightFactor = DeviceUtils.getHeightFactor(context);
    final widthFactor = DeviceUtils.getWidthFactor(context);
    bool isLoggedIn = false;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30 * heightFactor,
            ),
            Container(
              padding: EdgeInsets.only(left: 30 * widthFactor),
              alignment: Alignment.center,
              child: Text(
                "Actions",
                style: TextStyle(
                    fontSize: 20 * widthFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 300 * heightFactor,
                width: 400 * widthFactor,
                color: Colors.blueGrey,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 290 * heightFactor,
                      width: 200 * widthFactor,
                      child: Text(
                        "Request Vehicle Parts",
                        style: TextStyle(
                            fontSize: 15 * widthFactor,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute<void>(
                        builder: (BuildContext context) => LoginPage2()));

              },
            ),
            SizedBox(
              height: 50 * heightFactor,
            ),
            Container(
              padding: EdgeInsets.only(left: 30 * widthFactor),
              alignment: Alignment.center,
              child: Text(
                "Reminders",
                style: TextStyle(
                    fontSize: 20 * widthFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 50 * heightFactor,
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 300 * heightFactor,
                width: 400 * widthFactor,
                color: Color.fromRGBO(0,0,0,1),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 290 * heightFactor,
                      width: 200 * widthFactor,
                      child: Text(
                        "Reminders by admin",
                        style: TextStyle(
                            fontSize: 15 * widthFactor,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                //reminders
              },
            ),
            SizedBox(
              height: 50 * heightFactor,
            ),
          CarouselSlider(
            items: carouselItems.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['part_name'],
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Part Number: ${item['part_number']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Model: ${item['model']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          // Text(
                          //   'Date: ${item['date_time']}',
                          //   style: TextStyle(
                          //     fontSize: 16.0,
                          //     color: Colors.white,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 200.0,
              initialPage: 0,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentSlide = index;
                });
              },
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: carouselItems.asMap().entries.map((entry) {
              int index = entry.key;
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentSlide == index ? Colors.blue : Colors.grey,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
