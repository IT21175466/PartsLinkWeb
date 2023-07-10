import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'vendorForm.dart';
import 'BF(platform).dart';

class PlatformScreen2 extends StatefulWidget {
  const PlatformScreen2({Key? key}) : super(key: key);

  @override
  _PlatformScreenState2 createState() => _PlatformScreenState2();
}

class _PlatformScreenState2 extends State<PlatformScreen2> {
  String? selectedOption;

  void _selectAnOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Selection Error"),
          content: Text("Please select one option."),
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
      appBar: AppBar(title: Text("Account Type")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'What do you want to do in the platform?',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 400,
                child: ListTile(
                  //contentPadding: EdgeInsets.symmetric(horizontal: 100),
                  title: const Text('I want to buy vehicle parts'),
                  leading: Radio(
                    value: 'user',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value as String?;
                      });
                      print('Selected: $value');
                    },
                  ),
                  onTap: () {
                    setState(() {
                      selectedOption = "user" as String?;
                    });
                    print('Selected: user');
                  },
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 400,
                child: ListTile(
                  //contentPadding: EdgeInsets.symmetric(horizontal: 100),
                  title: const Text('I want to sell vehicle parts'),
                  leading: Radio(
                    value: 'vendor',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value as String?;
                      });
                      print('Selected: $value');
                    },
                  ),
                  onTap: () {
                    setState(() {
                      selectedOption = "vendor" as String?;
                    });
                    print('Selected: vendor');
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    if (selectedOption == null) {
                      _selectAnOption(context);
                    } else {
                      if (selectedOption == "user") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BuyerForm2()),
                        );
                      } else if (selectedOption == "vendor") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerForm2()),
                        );
                      }
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Set the button's border radius
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(370, 65)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(182, 21, 66, 126)),
                    // Set the button's minimum size
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
