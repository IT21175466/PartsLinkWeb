
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'QR(vendor).dart';
import 'package:path_provider/path_provider.dart';
import '/utils/device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:html' as html;

class NotificationsListData {
  final String name;
  final String createdAt;
  final String type;

  final String requestId; // Add the 'requestId' property

  NotificationsListData({
    required this.name,
    required this.createdAt,
    required this.type,
    required this.requestId, // Initialize the 'requestId' property
  });
}

class NotificationsListData2 {
  final String name;
  final String type;

  NotificationsListData2({
    required this.name,
    required this.type,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationsListData> notificationsListData = [];

  List<NotificationsListData2> notificationsListData2 = [];

  @override
  void initState() {
    super.initState();
    getTheVendorID();
    fetchNotifications();
  }

  String partName = "";
  String partNumber = "";
  String desc = "";
  String country = "";
  String model = "";
  String madeYear = "";
  String addition = "";
  String reqID = "";

  String vendorID = "";
  Future<void> getTheVendorID() async {
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
        setState(() {
          vendorID = id; // Update the class-level vendorID variable
        });
        // Do something with the retrieved data
      }
      fetchNotifications();
    }
  }

  Future<String> fetchDataNotifications(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = response.body;
        // Print the echoing response of the PHP file
        print('PHP Response: $jsonData');

        return jsonData;
      } else {
        return 'API request failed with status code ${response.statusCode}';
      }
    } catch (error) {
      return 'Error: $error';
    }
  }

  Future<void> fetchNotifications() async {
    try {
      final url = 'https://my.partscart.lk/notification.php';
      final response = await fetchDataNotifications(url);

      if (response.startsWith('Error')) {
        print('Failed to fetch notifications. Error: $response');
        return;
      }

      final data = json.decode(response);

      setState(() {
        notificationsListData = List<NotificationsListData>.from(
          data.map((notification) => NotificationsListData(
                name: notification['text'],
                createdAt: notification['curDate'],
                type: 'notification',
                requestId: notification[
                    'request_id'], // Assign the value of 'request_id'
              )),
        );
      });
    } catch (error) {
      print('Failed to fetch notifications. Error: $error');
    }
  }

  void saveRequestId(String requestId) async {
    final Map<String, String> jsonMap = {'request_id': requestId};
    final jsonString = json.encode(jsonMap);
    final storage = html.window.localStorage;
    storage['requestID.json'] = jsonString;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuotationRequest()),
    );
  }

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
              "Order Details",
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
                  Text('Description:',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text(desc,
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
                  Text('Addition:',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text(addition,
                      style: TextStyle(fontSize: 20, color: Color(0xFF877DAD))),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      saveRequestId(reqID);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(370, 65)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(189, 166, 247, 1)),
                    ),
                    child: Text(
                      'Accept this order',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> fetchDataNotificationz(
      String url, Map<String, dynamic> data) async {
    try {
      final response = await http.post(Uri.parse(url), body: data);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        // Print the echoing response of the PHP file
        print('PHP Response: $jsonData');

        return jsonData;
      } else {
        return 'API request failed with status code ${response.statusCode}';
      }
    } catch (error) {
      return 'Error: $error';
    }
  }

  Future<void> fetchSuccessMessagetoVendor() async {
    print("text: $vendorID");
    try {
      final url = 'https://my.partscart.lk/successMSGtoVendor.php';
      final dataSend = {
        'vID': vendorID,
        // Add more key-value pairs as needed
      };
      final response = await fetchDataNotificationz(url, dataSend);

      if (response.startsWith('Error')) {
        print('Failed to fetch notifications. Error: $response');
        return;
      }

      final data = json.decode(response);

      setState(() {
        notificationsListData2 = List<NotificationsListData2>.from(
          data.map((notification) => NotificationsListData2(
                name: '${notification['text']}',
                type: 'notification',
              )),
        );
      });
      _showFullModal2(context);
    } catch (error) {
      print('Failed to fetch notifications. Error: $error');
    }
  }

  _showFullModal2(context) {
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
              "Accepted Orders",
              style: TextStyle(
                color: Colors.black87,
                fontFamily: 'Overpass',
                fontSize: 20,
              ),
            ),
            elevation: 0.0,
          ),
          backgroundColor: Colors.white.withOpacity(0.90),
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10), // Adjust padding values as needed
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xfff8f8f8),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          title: Text(
                            notificationsListData2[index].name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(60, 61, 61, 1),
                              fontWeight: FontWeight
                                  .bold, // Add font weight for emphasis
                            ),
                          ),
                          trailing: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.black, // Set the icon color
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 2,
                        ),
                        child: Divider(
                          color: Colors.grey, // Set the divider color
                        ),
                      );
                    },
                    itemCount: notificationsListData2.length,
                  ),
                ),
              ],
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
      appBar: _appBar(),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              fetchSuccessMessagetoVendor();
            },
            icon: Icon(
              Icons.store,
              size: 24.0,
              color: Color.fromRGBO(
                  199, 206, 255, 1), // Change the icon color to red
            ),
            label: Text(
              'See accepted Orders',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Change the text color to white
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(left: 25 * widthFactor),
            alignment: Alignment.bottomLeft,
            child: Text(
              "Recent Quotation Requests 💵",
              style: TextStyle(
                fontSize: 26 * widthFactor,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        print(
                            'Notification data: ${notificationsListData[index].name}, ${notificationsListData[index].createdAt}, ${notificationsListData[index].type}, ${notificationsListData[index].requestId}');
                        reqID = notificationsListData[index].requestId;
                        fetchRequestData(
                            notificationsListData[index].requestId);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16), // Add desired padding value
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(222, 238, 252, 1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 1000,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal:
                                              16.0), // Add desired padding value
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          notificationsListData[index].name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  47, 90, 163, 1)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0,
                                          horizontal:
                                              16.0), // Add desired padding value
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          notificationsListData[index]
                                              .createdAt,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  52, 53, 54, 1)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 10), // Add desired height between notifications
                  ],
                );
              },
              itemCount: notificationsListData.length,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text('Notification'),
      titleTextStyle: TextStyle(
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
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12.0,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(12),
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

void main() {
  runApp(MaterialApp(
    home: NotificationPage(),
  ));
}
