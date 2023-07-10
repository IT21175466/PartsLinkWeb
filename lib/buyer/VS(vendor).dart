import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '/buyer/widgets/login_fieid.dart';
import '/buyer/widgets/password.dart';
// import 'package:gap/main.dart';
import '/utils/device.dart';
import 'package:path_provider/path_provider.dart';
import 'VHP(vendor).dart';
import 'buyer_home_page_Android_IOS.dart';
import 'dart:html' as html;

class VendorSetting extends StatefulWidget {
  @override
  _VendorSettingState createState() => _VendorSettingState();
}

class _VendorSettingState extends State<VendorSetting> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String usr = ""; // Define the 'usr' variable to hold the username
  String pss = "";
  String eml = "";
  String uid = "";
  String mbl = "";

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the fetchData method to retrieve the username
  }

  void _showSuccessDialog(txt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Account"),
          content: Text(txt),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> fetchData() async {
    final storage = html.window.localStorage;
    String? storedData = storage['data2.json'];
    if (storedData != null) {
      List<dynamic> dataList = json.decode(storedData) as List<dynamic>;
      for (var item in dataList) {
        setState(() {
          usr = item['company_name'] as String;
          pss = item['password'] as String;
          eml = item['email'] as String;
          uid = item['id'] as String;
          mbl = item['mobile'] as String;
        });
        // Do something with the retrieved data
      }
    }
    return "";
  }

  Future<void> logOut() async {
    final storage = html.window.localStorage;
    storage.remove('data2.json');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BuyerHomePage2()),
    );
  }

  Future<void> updateUserData(uId, uName, uPass, uEmail) async {
    print('$uId,$uName,$uPass,$uEmail');
    final url = Uri.parse("https://my.partscart.lk/updateVendorData.php");
    try {
      final response = await http.get(url, headers: {
        'user': uName,
        'password': uPass,
        'email': uEmail,
        'id': uId,
      });
      if (response.statusCode == 200) {
        final jsonData = response.body;
        if (jsonData == "success") {
          List<Map<String, dynamic>> dataList = [];
          String id = uId;
          String username = uName;
          String email = uEmail;
          String mobile = mbl;
          String password = uPass;
          Map<String, dynamic> itemMap = {
            'id': id,
            'company_name': username,
            'email': email,
            'mobile': mobile,
            'password': password,
          };
          dataList.add(itemMap);
          final jsonDataToStore = json.encode(dataList);
          Directory directory = await getApplicationDocumentsDirectory();
          String filePath = '${directory.path}/data2.json';

          File file = File(filePath);
          await file.writeAsString(jsonDataToStore);
          _showSuccessDialog("Account Update : Success");
        }
      } else {
        _showSuccessDialog("Account Update : An error occurred");
      }
    } catch (error) {}
  }

  // Rest of the code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vendor Settings")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 5),
              Container(
                width: 100, // Desired width
                height: 100, // Desired height
                child: Image.asset("assets/avatar.png"),
              ),
              const SizedBox(height: 20),
              Text(
                '$usr',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      'Change Username',
                      style: TextStyle(
                        color: Color.fromARGB(169, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      width: 350,
                      height: 60, // Adjust the height as per your requirement
                      child: LoginField(
                        hintText: '$usr',
                        controller: _usernameController,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          color: Color.fromARGB(169, 0, 0, 0),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 50),
                    Container(
                      width: 350,
                      height: 60, // Adjust the height as per your requirement
                      child: Password(
                        hintText: '*********',
                        controller: _passwordController,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                      child: Text(
                        'Change Email',
                        style: TextStyle(
                          color: Color.fromARGB(169, 0, 0, 0),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 90),
                    Container(
                      width: 350,
                      height: 60, // Adjust the height as per your requirement
                      child: LoginField(
                        hintText: '$eml',
                        controller: _emailController,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  var userText = _usernameController.text.trim();
                  var passText = _passwordController.text.trim();
                  var emailText = _emailController.text.trim();

                  String uzrName = userText.isEmpty ? usr : userText;
                  String pzz = passText.isEmpty ? pss : passText;
                  String email = emailText.isEmpty ? eml : emailText;

                  updateUserData(uid, uzrName, pzz, email);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(Size(370, 65)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(182, 21, 66, 126)),
                ),
                child: Text(
                  // textAlign: TextAlign.start,
                  'Save Changes',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  logOut();
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color.fromARGB(169, 176, 12, 12),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
