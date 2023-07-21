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
        final RID = item['request_id'];
        final links = imageLink.split(',');

        if (links.isNotEmpty) {
          final modifiedLink =
              'https://my.partscart.lk/next/${links[0].replaceAll('./', '')}';

          // Replace the modified link with another image URL if it matches a specific value
          if (modifiedLink == 'https://my.partscart.lk/next/') {
            item['background'] =
                'https://static.vecteezy.com/system/resources/thumbnails/004/141/669/small/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg'; // Replace with your desired placeholder image URL
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

  String partName = "";
  String partNumber = "";
  String desc = "";
  String country = "";
  String model = "";
  String madeYear = "";
  String addition = "";
  String reqID = "";
  List<String> imgURLs = [];

  Future<void> fetchRequestData(paraID) async {
    try {
      final url = 'https://my.partscart.lk/fetchRequestData.php';

      final response = await http.post(Uri.parse(url), body: {
        'id': paraID,
      });

      if (response.statusCode == 200) {
        final jsonData = response.body;
        // Parse the JSON data
        final data = json.decode(jsonData);

        // Access the retrieved data
        partName = data['part_name'];
        partNumber = data['part_number'];
        desc = data['description'];
        country = data['country'];
        model = data['model'];
        madeYear = data['year_of_make'];
        addition = data['addition'];
        reqID = data['request_id'];
        var imgLINKS = data['image_link'];

        // Modify image paths to absolute URLs
        List<String> imgPaths = imgLINKS.split(',');
        imgURLs = imgPaths
            .map((path) =>
                'https://my.partscart.lk/next/${path.replaceAll('./', '')}')
            .where((url) => url != 'https://my.partscart.lk/next/')
            .toList();

        _showFullModal(context);
        // ... print or use other fields as needed
      } else {}
    } catch (error) {}
  }

  _showFullModal(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Modal",
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Product Details",
              style: TextStyle(
                  color: Colors.black87, fontFamily: 'Overpass', fontSize: 20),
            ),
            elevation: 0.0,
          ),
          backgroundColor: Colors.white.withOpacity(0.90),
          body: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xfff8f8f8),
                  width: 1,
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200, // Set the desired height
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                    ),
                    items: imgURLs.map((url) {
                      return GestureDetector(
                        onTap: () {
                          // Handle the tap event here, e.g., show a dialog with the original size image
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Image.network(
                                    url), // Display the original size image
                              );
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Set the desired border radius
                          child: Container(
                            width: 400, // Set the desired width
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  Text('Part Name:',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text(partName,
                      style: TextStyle(fontSize: 20, color: Color(0xFF877DAD))),
                  SizedBox(height: 30),
                  Text('Part Number:',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text(partNumber,
                      style: TextStyle(fontSize: 20, color: Color(0xFF877DAD))),
                  SizedBox(height: 30),
                  Text('Country:',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text(country,
                      style: TextStyle(fontSize: 20, color: Color(0xFF877DAD))),
                  SizedBox(height: 30),
                  Text('Model:',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text(model,
                      style: TextStyle(fontSize: 20, color: Color(0xFF877DAD))),
                  SizedBox(height: 30),
                  Text('Made Year:',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text(madeYear,
                      style: TextStyle(fontSize: 20, color: Color(0xFF877DAD))),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
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
                    fontSize: 15 * widthFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 300 * heightFactor,
                width: 400 * widthFactor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://images.pexels.com/photos/14240047/pexels-photo-14240047.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
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

                // Navigator.of(context).push(CupertinoPageRoute<void>(
                //     builder: (BuildContext context) => LoginPage2()));
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
                    fontSize: 15 * widthFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 30 * heightFactor,
            ),
            CarouselSlider(
              items: carouselItems.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        String requestId = item['request_id'];
                        fetchRequestData(requestId);
                        // Perform any additional actions here based on the index
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(item['background']),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                item['part_name'],
                                style: TextStyle(
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Price: ${item['part_number']}',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Model: ${item['model']}',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
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
                    fontSize: 15 * widthFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 300 * heightFactor,
                width: 400 * widthFactor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://images.pexels.com/photos/949587/pexels-photo-949587.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Container(
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
              ),
              onTap: () {
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
