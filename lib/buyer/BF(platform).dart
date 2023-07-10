import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import '/buyer/widgets/login_fieid.dart';
import 'registerModule(user).dart';

class BuyerForm2 extends StatefulWidget {
  const BuyerForm2({Key? key}) : super(key: key);

  @override
  _BuyerFormState2 createState() => _BuyerFormState2();
}

class _BuyerFormState2 extends State<BuyerForm2> {
  int selectedRadioTile = 1;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _conpasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  bool _obscureText = true;
  String? alert;
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  void _wrongCredentials() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Credential Error"),
          content: Text("Please fill all the required fields."),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _passwordNotTheSame() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Matching error"),
          content: Text("Your passwords are not the same."),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _userCreation(alert) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("User Creation"),
          content: Text(alert),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
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
      appBar: AppBar(title: Text("Create User")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 450, // Set your desired width here
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Username',
                  ),
                ),
              ),
              // Container(
              //   width: 450, // Set the desired width for the username field
              //   child: TextField(
              //     controller: _usernameController,
              //     decoration: InputDecoration(
              //       hintText: 'Username',
              //       hintStyle: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.w400,
              //         fontSize: 16,
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       filled: true,
              //       fillColor: Colors.white,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                width: 450, // Set your desired width here
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Email',
                  ),
                ),
              ),
              // Container(
              //   width: 450, // Set the desired width for the username field
              //   child: TextField(
              //     controller: _emailController,
              //     decoration: InputDecoration(
              //       hintText: 'Email',
              //       hintStyle: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.w400,
              //         fontSize: 16,
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       filled: true,
              //       fillColor: Colors.white,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                width: 450, // Set your desired width here
                child: TextField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Mobile Number',
                  ),
                ),
              ),
              // Container(
              //   width: 450, // Set the desired width for the username field
              //   child: TextField(
              //     controller: _mobileController,
              //     decoration: InputDecoration(
              //       hintText: 'Mobile Number',
              //       hintStyle: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.w400,
              //         fontSize: 16,
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       filled: true,
              //       fillColor: Colors.white,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                width: 450, // Set your desired width here
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Password',
                  ),
                ),
              ),
              // Container(
              //   width: 450, // Set the desired width for the username field

              //   child: TextField(
              //     controller: _passwordController,
              //     obscureText: true,
              //     decoration: InputDecoration(
              //       hintText: 'Password',
              //       hintStyle: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.w400,
              //         fontSize: 16,
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       filled: true,
              //       fillColor: Colors.white,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                width: 450, // Set your desired width here
                child: TextField(
                  controller: _conpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Confirm Password',
                  ),
                ),
              ),
              // Container(
              //   width: 450, // Set the desired width for the username field
              //   child: TextField(
              //     controller: _conpasswordController,
              //     obscureText: true,
              //     decoration: InputDecoration(
              //       hintText: 'Confirm Password',
              //       hintStyle: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.w400,
              //         fontSize: 16,
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       filled: true,
              //       fillColor: Colors.white,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  String username = _usernameController.text;
                  String password = _passwordController.text;
                  String mobile = _mobileController.text;
                  String email = _emailController.text;
                  String conpassword = _conpasswordController.text;

                  if (username.isEmpty ||
                      username == null ||
                      password.isEmpty ||
                      password == null ||
                      mobile.isEmpty ||
                      mobile == null ||
                      email.isEmpty ||
                      email == null ||
                      conpassword.isEmpty ||
                      conpassword == null) {
                    _wrongCredentials();
                  } else if (password != conpassword) {
                    _passwordNotTheSame();
                  } else {
                    String alert = await fetchDataRegister(
                      "https://my.partscart.lk/reg_user.php",
                      username,
                      password,
                      email,
                      mobile,
                    );
                    _userCreation(alert);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(182, 21, 66, 126)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(Size(400, 65)),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w500, // Specify the desired text size
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
