import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'quotation_request.dart';
import 'package:path_provider/path_provider.dart';
import '/utils/device.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'buyer_home_page.dart';
// import 'editQuotation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:html' as html;
import 'EQ(user).dart';
import 'BH(user).dart';

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
  final String createdAt;
  final String type;

  final String quotationID; // Add the 'requestId' property

  NotificationsListData2({
    required this.name,
    required this.createdAt,
    required this.type,
    required this.quotationID, // Initialize the 'requestId' property
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

  String quotationId = "";
  String partName = "";
  String partNo = "";
  String description = "";
  String country = "";
  String model = "";
  String yearOfMake = "";
  String dateTime = "";
  String vendorId = "";
  String conditionId = "";

  String REQ = "";
  String cond = "";
  String vName = "";
  String vEmail = "";
  String vMobile = "";
  String uID = "";
  @override
  void initState() {
    super.initState();
    getTheUserID();
  }

  Future<String> fetchDataNotifications(
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

  Future<String> getTheUserID() async {
    final storage = html.window.localStorage;
    String? storedData = storage['data.json'];
    if (storedData != null) {
      List<dynamic> dataList = json.decode(storedData) as List<dynamic>;

      for (var data in dataList) {
        uID = data['id'];
      }
      fetchNotifications();
    }
    return "";
  }

  Future<void> fetchNotifications() async {
    try {
      final url = 'https://my.partscart.lk/getOrdersByUser.php';
      final dataSend = {
        'uID': uID,
        // Add more key-value pairs as needed
      };
      final response = await fetchDataNotifications(url, dataSend);

      if (response.startsWith('Error')) {
        print('Failed to fetch notifications. Error: $response');
        return;
      }

      final data = json.decode(response);

      setState(() {
        notificationsListData = List<NotificationsListData>.from(
          data.map((notification) => NotificationsListData(
                name: '${notification['part_name']} - ${notification['model']}',
                createdAt: notification['date_time'],
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

  Future<void> fetchQuotaList(paraReq) async {
    try {
      final url = 'https://my.partscart.lk/retrieveQuotaList.php';
      final dataSend = {
        'rID': paraReq,
      };
      final response = await http.post(Uri.parse(url), body: dataSend);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        // Print the echoing response of the PHP file
        print('PHP Response: $jsonData');

        final data = json.decode(jsonData);
        setState(() {
          notificationsListData2 = List<NotificationsListData2>.from(
            data.map((notification) => NotificationsListData2(
                  name:
                      '${notification['part_name']} - ${notification['model']}',
                  createdAt: notification['date_time'],
                  type: 'notification',
                  quotationID: notification[
                      'quotation_id'], // Assign the value of 'request_id'
                )),
          );
        });
        _showFullModal(context);
        // Accessing the data
      } else {
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch notifications. Error: $error');
    }
  }

  List<String> imgURLs = [];
  Future<void> fetchQuotaDetail(paraReq) async {
    try {
      final url = 'https://my.partscart.lk/quotationDetails.php';
      final dataSend = {
        'qID': paraReq,
      };
      final response = await http.post(Uri.parse(url), body: dataSend);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        // Print the echoing response of the PHP file
        print('PHP Response: $jsonData');

        final data = json.decode(jsonData);
        print(data);

        // Accessing the data
        if (data.isNotEmpty) {
          final quotation = data[0]; // Access the first quotation in the list

          quotationId = quotation['quotation_id'];
          partName = quotation['part_name'];
          partNo = quotation['part_no'];
          description = quotation['description'];
          country = quotation['country'];
          model = quotation['model'];
          yearOfMake = quotation['year_of_make'];
          dateTime = quotation['date_time'];
          vendorId = quotation['vendor_id'];
          conditionId = quotation['condition_id'];
          var imgLINKS = quotation['image_link'];

          // Modify image paths to absolute URLs
          List<String> imgPaths = imgLINKS.split(',');
          imgURLs = imgPaths
              .map((path) =>
                  'https://my.partscart.lk/next/${path.replaceAll('./', '')}')
              .where((url) => url != 'https://my.partscart.lk/next/')
              .toList();

          print(imgURLs);
          REQ = quotation['request_id'];
          if (conditionId == "4") {
            cond = "Brand new";
          } else if (conditionId == "5") {
            cond = "Brand new , Recondition";
          } else if (conditionId == "6") {
            cond = "Brand new , Recondition , Locally used";
          } else if (conditionId == "7") {
            cond = "Recondition";
          } else if (conditionId == "8") {
            cond = "Recondition,Locally used";
          } else if (conditionId == "9") {
            cond = "Brand new , Locally used";
          } else if (conditionId == "10") {
            cond = "Locally used";
          }
        }

        _showFullModal2(context);
      } else {
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch notifications. Error: $error');
    }
  }

  Future<void> fetchVendorDetail(paraReq) async {
    try {
      final url = 'https://my.partscart.lk/vFetchDetails.php';
      final dataSend = {
        'vID': paraReq,
      };
      final response = await http.post(Uri.parse(url), body: dataSend);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        // Print the echoing response of the PHP file
        print('PHP Response: $jsonData');

        final data = json.decode(jsonData);
        print(data);
        if (data.isNotEmpty) {
          final vData = data[0];
          vName = vData['company_name'];
          vEmail = vData['email'];
          vMobile = vData['mobile'];
        }
        _showBottomModal(context);
        // Accessing the data
      } else {
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch notifications. Error: $error');
    }
  }

  void saveRequestIdofNotify(String requestId) async {
    final Map<String, String> jsonMap = {'notify_ID': requestId};
    final jsonString = json.encode(jsonMap);
    final storage = html.window.localStorage;
    storage['notify_ID.json'] = jsonString;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => editQuotationReqest()),
    );
  }

  Future<void> approveTheOrder(paraReq) async {
    try {
      final url = 'https://my.partscart.lk/uApproveOrder.php';
      final dataSend = {
        'vID': paraReq,
        'text':
            'Your $partName - $partNo order which was sent in $dateTime has accepted.',
        'reqID': REQ,
      };
      final response = await http.post(Uri.parse(url), body: dataSend);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        // Print the echoing response of the PHP file
        print('PHP Response: $jsonData');
        _showDataDialog();
      }
    } catch (error) {
      print('Failed to fetch notifications. Error: $error');
    }
  }

  void showThePayment() {
    _PaymentModal(context);
  }

  void _showDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quotation approval"),
          content: Text("Quotation selection: success"),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuyerHomePage3()),
                );
              },
            ),
          ],
        );
      },
    );
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
              "All Quotations",
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
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print(
                                'Notification data: ${notificationsListData2[index].name}, ${notificationsListData2[index].createdAt}, ${notificationsListData2[index].type}, ${notificationsListData2[index].quotationID}');
                            fetchQuotaDetail(
                                notificationsListData2[index].quotationID);
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            title: Text(
                              notificationsListData2[index].name,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            subtitle: Text(
                              notificationsListData2[index].createdAt,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                        );
                      },
                      itemCount: notificationsListData2.length,
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
              "Quotation Report",
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
                  Text(partNo,
                      style: TextStyle(fontSize: 20, color: Color(0xFF877DAD))),
                  SizedBox(height: 30),
                  Text('Description:',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text(description,
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
                  Text(yearOfMake,
                      style: TextStyle(fontSize: 20, color: Color(0xFF877DAD))),
                  SizedBox(height: 30),
                  Text('Condition:',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text(cond,
                      style: TextStyle(fontSize: 20, color: Color(0xFF877DAD))),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      fetchVendorDetail(vendorId);
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
                      'Review the vendor',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      showThePayment();
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
                          Color.fromRGBO(96, 112, 255, 1)),
                    ),
                    child: Text(
                      'Accept the quotation',
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

  _PaymentModal(context) {
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
              "All Quotations",
              style: TextStyle(
                  color: Colors.black87, fontFamily: 'Overpass', fontSize: 20),
            ),
            elevation: 0.0,
          ),
          backgroundColor: Colors.white.withOpacity(0.90),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Spacer(),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          cursorColor: Colors.deepPurple,
                          maxLength: 20,
                          decoration: InputDecoration(
                            icon: Icon(Icons.numbers),
                            labelText: 'Card Number',
                            labelStyle: TextStyle(
                              color: Color(0xFF6200EE),
                            ),
                            suffixIcon: Icon(
                              Icons.check_circle,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6200EE)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: TextFormField(
                            cursorColor: Colors.deepPurple,
                            maxLength: 20,
                            decoration: InputDecoration(
                              icon: Icon(Icons.abc_outlined),
                              labelText: 'Full Name',
                              labelStyle: TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              suffixIcon: Icon(
                                Icons.check_circle,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                cursorColor: Colors.deepPurple,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.lock),
                                  labelText: 'Card Number',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF6200EE),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.check_circle,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF6200EE)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                cursorColor: Colors.deepPurple,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.date_range),
                                  labelText: 'MM/YY',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF6200EE),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.check_circle,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF6200EE)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: OutlinedButton(
                      child: Text("Proceed to payment"),
                      style: OutlinedButton.styleFrom(
                        primary: Color(0xFF6200EE),
                        side: BorderSide(
                          color: Color(0xFF6200EE),
                        ),
                      ),
                      onPressed: () {
                        approveTheOrder(vendorId);
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showBottomModal(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return new Container(
            // height: 800,
            color: Colors.transparent,
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0, // has the effect of softening the shadow
                    spreadRadius: 0.0, // has the effect of extending the shadow
                  )
                ],
              ),
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          "Vendor Details",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: const Color(0xfff8f8f8),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 100, // Desired width
                          height: 100, // Desired height
                          child: Image.asset("assets/avatar.png"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              vName,
                              style: TextStyle(
                                color: Color.fromARGB(169, 0, 0, 0),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email  : $vEmail',
                              style: TextStyle(
                                color: Color.fromARGB(169, 0, 0, 0),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Mobile : $vMobile',
                              style: TextStyle(
                                color: Color.fromARGB(169, 0, 0, 0),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
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
          Container(
            padding: EdgeInsets.only(left: 25 * widthFactor),
            alignment: Alignment.bottomLeft,
            child: Text(
              "Your Orders",
              style: TextStyle(
                fontSize: 25 * widthFactor,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print(
                      'Notification data: ${notificationsListData[index].name}, ${notificationsListData[index].createdAt}, ${notificationsListData[index].type}, ${notificationsListData[index].requestId}',
                    );
                    fetchQuotaList(notificationsListData[index].requestId);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(222, 239, 252, 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0), // Add padding to the title text
                          child: Text(
                            notificationsListData[index].name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(44, 88, 122, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal:
                                  8.0), // Add padding to the subtitle text
                          child: Text(
                            notificationsListData[index].createdAt,
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(75, 76, 77, 1)),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                saveRequestIdofNotify(
                                    notificationsListData[index].requestId);
                              },
                              color: Colors.black, // Set the icon color
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                    height: 10); // Add desired height between notifications
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
