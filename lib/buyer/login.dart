import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;
import 'platform.dart';
import 'BH(user).dart';
import 'VHP(vendor).dart';

class LoginPage2 extends StatefulWidget {
  @override
  State<LoginPage2> createState() => _LoginPageState2();
}

class _LoginPageState2 extends State<LoginPage2> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  List<String> dropdownItems = ['user', 'vendor'];
  String? selectedItem;

  void _showNoDataDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("No Data"),
            content: Text("No users found for the given credentials."),
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

  void _showSuccessDialog(txt) {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Process"),
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

  void _wrongCredentials() {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Wrong Credentials"),
            content: Text(
                "Please make sure you have filled all the fields correctly."),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home")),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 80,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Linking Sellers and Buyers in the World of Auto Parts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign
                          .center, // Optional if you want to align the text within the Text widget
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'User Type',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        DropdownButton<String>(
                          value: selectedItem,
                          icon: Icon(Icons.adaptive.arrow_forward),

                          iconSize: 24,
                          elevation: 16,

                          style: TextStyle(color: Colors.black),
                          underline: SizedBox(), // Remove the default underline
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedItem = newValue!;
                              debugPrint(selectedItem);
                            });
                          },
                          items: ['user', 'vendor']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double
                        .infinity, // Set the desired width for the username field

                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double
                        .infinity, // Set the desired width for the password field
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String username = _usernameController.text;
                        String password = _passwordController.text;
                        if (selectedItem == null ||
                            username.isEmpty ||
                            password.isEmpty) {
                          _wrongCredentials();
                        }
                        if (selectedItem != null &&
                            selectedItem == "user" &&
                            username.isNotEmpty &&
                            password.isNotEmpty) {
                          fetchData(
                              "https://my.partscart.lk/login_user.php",
                              username,
                              password,
                              selectedItem);
                        } else if (selectedItem != null &&
                            selectedItem == "vendor" &&
                            username.isNotEmpty &&
                            password.isNotEmpty) {
                          fetchData(
                              "https://my.partscart.lk/login_vendor.php",
                              username,
                              password,
                              selectedItem);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromARGB(182, 21, 66, 126)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(370, 65)),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight:
                              FontWeight.w500, // Specify the desired text size
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Perform the desired action when the text is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlatformScreen2()),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          "Not a member yet? Register",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "All rights reserved @GAP",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> fetchData(
      String urlz, String user, String password, selected) async {
    //about this save variable we will discuss later in this code :)
    String? save;
    if (selected == "user") {
      final url = Uri.parse(urlz);
      //sending user an password inputs into php API
      try {
        final response = await http.get(url, headers: {
          'user': user,
          'password': password,
        });

        if (response.statusCode == 200) {
          final jsonData = response.body;
          if (jsonData == "no_Data") {
            print("No users found for that credentials.");
            _showNoDataDialog();
          } else if (jsonData != "no_Data") {
            final parsedData = json.decode(jsonData);
            //cuz the json comes as an array by default according to our php code, we gotta ensure is it a list or a map
            if (parsedData is List) {
              List<Map<String, dynamic>> dataList = [];

              for (var item in parsedData) {
                // Access individual item properties
                String id = item['id'];
                String username = item['username'];
                String email = item['email'];
                String mobile = item['mobile'];
                String password = item['password'];

                //building map structure
                Map<String, dynamic> itemMap = {
                  'id': id,
                  'username': username,
                  'email': email,
                  'mobile': mobile,
                  'password': password,
                };

                dataList.add(itemMap);
              }
              //encode the list(which is dataList in this case)
              // final jsonDataToStore = json.encode(dataList);

              // Get the directory for storing the file
              //by default these files are stored in /data/user/0/blah blah which you don't have access by default. You have to root your 4n :)
              // Directory directory = await getApplicationDocumentsDirectory();
              // String filePath = '${directory.path}/data.json';

              // File file = File(filePath);
              // await file.writeAsString(jsonDataToStore);
              final storage = html.window.localStorage;

              // Construct the data to be stored
              final jsonDataToStore = json.encode(dataList);

              // Store the data in the local storage
              storage['data.json'] = jsonDataToStore;

              print('User login success');
              _showSuccessDialog('User login success');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BuyerHomePage3()),
              );
            }
          }
          //decoding encoded json
        } else {
          print('API request failed with status code ${response.statusCode}');
          _showSuccessDialog(
              'API request failed with status code ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
        _showSuccessDialog('Error: $error');
      }
    } else if (selected == "vendor") {
      final url = Uri.parse(urlz); // Replace with your API URL
      try {
        final response = await http.get(url, headers: {
          'user': user,
          'password': password,
        });

        if (response.statusCode == 200) {
          final jsonData = response.body;
          if (jsonData == "no_Data") {
            print("No vendor accounts found for these credentials.");
            _showSuccessDialog(
                "No vendor accounts found for these credentials.");
          } else if (jsonData != "no_Data") {
            final parsedData = json.decode(jsonData);

            if (parsedData is List) {
              List<Map<String, dynamic>> dataList = [];

              for (var item in parsedData) {
                //Accessing items in our fetched data
                String id = item['id'];
                String company_name = item['company_name'];
                String address = item['address'];
                String mobile = item['mobile'];
                String nic = item['nic'];
                String br_link = item['br_link'];
                String email = item['email'];
                String condition_id = item['condition_id'];
                String approve_id = item['approve_id'];
                String nic_front = item['nic_front'];
                String nic_back = item['nic_back'];
                String password = item['password'];
                //in our approve table in our database, 3 means approved.
                if (approve_id == "3") {
                  //okay let's talk about the save variable. if u scroll a lil bit you will see after these processes we
                  //have a process that will store data in our device.if admin has approved this vendor's acc then we will store his data in our storage.
                  //Otherwise we just don't :)
                  save = "success";
                  //setting up a map :)
                  Map<String, dynamic> itemMap = {
                    'id': id,
                    'company_name': company_name,
                    'mobile': mobile,
                    'email': email,
                    'password': password,
                  };

                  dataList.add(itemMap);
                  //As i said before 3 is approved and 4 is not approved. And this guy can't store his data in the storage :)
                } else if (approve_id == "4") {
                  save = 'fail';
                }
              }
              //if admin approval is true(in this case 'success' string) we will store data
              if (save == "success") {
                // final jsonDataToStore = json.encode(dataList);

                // Get the directory for storing the file
                // Directory directory = await getApplicationDocumentsDirectory();
                // String filePath = '${directory.path}/data2.json';

                // File file = File(filePath);
                // await file.writeAsString(jsonDataToStore);
                final storage = html.window.localStorage;

                // Construct the data to be stored
                final jsonDataToStore = json.encode(dataList);

                // Store the data in the local storage
                storage['data2.json'] = jsonDataToStore;
                print('Login success');
                _showSuccessDialog('Login success');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VendorHomePage()),
                );
              } else {
                print('Login failed: Admin approval is pending');
                _showSuccessDialog('Login failed: Admin approval is pending');
              }
            }
          }
        } else {
          print('API request failed with status code ${response.statusCode}');
          _showSuccessDialog(
              'API request failed with status code ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
        _showSuccessDialog('Error: $error');
      }
    }
  }
}
