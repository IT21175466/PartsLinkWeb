import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'QR(vendor).dart';
import 'package:path_provider/path_provider.dart';
import '/utils/device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:html' as html;
import 'login.dart';

class ListData {
  final int index;
  final String name;
  final String icon;
  final String type; // Add the 'requestId' property

  ListData({
    required this.index,
    required this.name,
    required this.icon,
    required this.type, // Initialize the 'requestId' property
  });
}

List<ListData> showListData = [];

class HotSellingsPage extends StatefulWidget {
  const HotSellingsPage({Key? key}) : super(key: key);

  @override
  _HotSellingsPageState createState() => _HotSellingsPageState();
}

class _HotSellingsPageState extends State<HotSellingsPage> {
  @override
  void initState() {
    super.initState();
    fetchCarouselData();
  }

  List<dynamic> carouselItems = [];
  int _currentSlide = 0;
  List<ListData> carouselData = [];

  Future<void> fetchCarouselData() async {
    final Uri url = Uri.parse("https://my.partscart.lk/carousel.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      for (var i = 0; i < data.length; i++) {
        final item = data[i];
        final imageLink = item['image_link'];
        final links = imageLink?.split(',');

        if (links != null && links.isNotEmpty) {
          final modifiedLink =
              'https://my.partscart.lk/next/${links[0]?.replaceAll('./', '')}';
          print(modifiedLink);

          carouselData.add(
            ListData(
              index: i,
              name: item['part_name'] ?? '',
              icon: modifiedLink,
              type: item['request_id'] ?? '',
            ),
          );
        }
      }

      setState(() {
        showListData = carouselData;
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

        print(imgURLs);
        _showFullModal(context);
        // ... print or use other fields as needed
      } else {
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
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
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: _appBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Hot Selling Products",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(34, 40, 110, 1),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16), // Add desired padding value
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(222, 238, 252, 1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 700,
                                height: 150,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 150,
                                          //image
                                          child: Image.network(
                                            showListData[index].icon,
                                            fit: BoxFit.cover,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          //child: //image
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              // name
                                              child: Text(
                                                showListData[index].name,
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        47, 90, 163, 1)),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            SafeArea(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  fetchRequestData(
                                                      showListData[index].type);
                                                },
                                                child: Text("Show More"),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blue),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30), // Set the button's border radius
                                                    ),
                                                  ),
                                                  minimumSize:
                                                      MaterialStateProperty.all<
                                                          Size>(Size(100, 50)),
                                                  // Set the button's minimum size
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Add desired height between notifications
                  ],
                );
              },
              itemCount: 5,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute<void>(
              builder: (BuildContext context) => LoginPage2()));
        },
        label: const Text('Add Request'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text('Hot Sellings'),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.25),
        ),
      ),
      elevation: 4,
      leadingWidth: 66,
      leading: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12.0,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 17,
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: HotSellingsPage(),
//   ));
// }
