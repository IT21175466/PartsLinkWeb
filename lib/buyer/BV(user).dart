import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:ga/data/sharedpref/constants/preferences.dart';
// import 'package:gap/pallete.dart';
// import 'package:gap/ui/login_screen_Android_IOS.dart';
// import 'package:gap/ui/request_part_buyer.dart';
import '/utils/device.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'notification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
import 'N(user).dart';
import 'RP(user).dart';

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

    // Extract and set the modified image links as backgrounds
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final imageLink = item['image_link'];
      final links = imageLink.split(',');

      if (links.isNotEmpty) {
        final modifiedLink = 'https://my.partscart.lk/next/${links[0].replaceAll('./', '')}';
        print(modifiedLink);

        // Replace the modified link with another image URL if it matches a specific value
        if (modifiedLink == 'https://my.partscart.lk/next/') {
          item['background'] = 'https://static.vecteezy.com/system/resources/thumbnails/004/141/669/small/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg'; // Replace with your desired placeholder image URL
        } else {
          item['background'] = modifiedLink;
        }
      }
    }

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
    bool isLoggedIn = true;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30 * heightFactor,
            ),
            Container(
              padding: EdgeInsets.only(left: 30 * widthFactor),
              alignment: Alignment.bottomLeft,
              child: Text(
                "Actions 💫",
                style: TextStyle(
                    fontSize: 30 * widthFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Container(
                height: 220 * heightFactor,
                width: 440 * widthFactor,
                //color: Colors.black.withOpacity(0.6),
                child: Stack(
                  children: [
                    Image.asset("assets/background_2.png"),
                    Container(
                      alignment: Alignment.center,
                      height: 200 * heightFactor,
                      child: Text(
                        "Request Vehicle Parts",
                        style: TextStyle(
                            fontSize: 30 * widthFactor,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                //request a vehicle part
                // * added the route according to the logged in status

                if (isLoggedIn == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestPart()),
                  );
                } else {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => LoginPage2()),
                  // );
                }
                ;
              },
            ),
            SizedBox(
              height: 30 * heightFactor,
            ),
            Container(
              padding: EdgeInsets.only(left: 30 * widthFactor),
              alignment: Alignment.bottomLeft,
              child: Text(
                "Hot sellings 🔥",
                style: TextStyle(
                    fontSize: 30 * widthFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 30 * heightFactor,
            ),
            CarouselSlider(
              items: carouselItems.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(item['background']),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), // Adjust the opacity value as needed
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0), // Add padding as desired
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item['part_name'],
                              style: TextStyle(
                                fontSize: 24.0, // Increase the font size as desired
                                fontWeight: FontWeight.bold, // Add font weight as desired
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
          SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 30 * widthFactor),
              alignment: Alignment.bottomLeft,
              child: Text(
                "Reminders ✨",
                style: TextStyle(
                    fontSize: 30 * widthFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Container(
                height: 340 * heightFactor,
                width: 440 * widthFactor,
                child: Stack(
                  children: [
                    Image.asset("assets/background_1.png"),
                    Container(
                      alignment: Alignment.center,
                      height: 320 * heightFactor,
                      child: Text(
                        "Reminders by admin",
                        style: TextStyle(
                            fontSize: 30 * widthFactor,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                  // if (isLoggedIn == true) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => NotificationPage()),
                  //   );
                  // } else {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => LoginPage2()),
                  //   );
                  // }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationPage()),
                    );
              },
            ),

      const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


