import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'registerModule(vendor).dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'dart:html' as htmlz;
import 'network.dart';
import 'network2.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';


class SellerForm2 extends StatefulWidget {
  const SellerForm2({Key? key}) : super(key: key);

  @override
  _SellerForm2State createState() => _SellerForm2State();
}

class _SellerForm2State extends State<SellerForm2> {
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _conpasswordController = TextEditingController();
  TextEditingController _nicController = TextEditingController();

  bool? isCheckedBNew = false;
  bool? isCheckedRecondition = false;
  bool? isCheckedLocally = false;

  File? image;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    final imageTempory = File(image.path);

    setState(() => this.image = imageTempory);
  }

  String?
      selectedStringValue; //Assigning a number to this variable upon the checkbox1
  String? selectedStringValue2; //assign 2
  String? selectedStringValue3; //assign 3 .......check boxes

  String appr_id = ""; //customly set approve id after number of possibilities
  File? _selectedImage;
  String _uploadedImageUrl = "";
  File? _selectedImage2;
  String _uploadedImageUrl2 = "";
  File? _selectedFile1;
  String _uploadedFileUrl1 = "";
  String Img_url_up = "";
  String Img_url_up2 = "";
  String Img_url_up3 = "";

  void _wrongCredentials() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: Text("Credential Error"),
            content: Text("Please fill all the required fields."),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
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
  }

  void _passwordNotTheSame() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: Text("Matching error"),
            content: Text("Your passwords are not the same."),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
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
  }

  void _stillUploading() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: Text("Upload Inprogress"),
            content: Text(
                "Images are stil  uploading. Try again after few seconds."),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("Upload Inprogress"),
            content: Text(
                "Images are stil  uploading. Try again after few seconds."),
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
  }

  void _userCreation(alert) {
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("Vendor Creation"),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("Vendor Creation"),
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
  }

  String filename1 = "";
  String filename2 = "";
  String filename3 = "";
  List<PlatformFile>? _paths;
  void pickFiles() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      if (_paths != null) {
        if (_paths != null) {
          //passing file bytes and file name for API call
          ApiClient.uploadFile(_paths!.first.bytes!, _paths!.first.name);
          filename1 = _paths!.first.name;
        }
      }
    });
  }

  void pickFiles2() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      if (_paths != null) {
        if (_paths != null) {
          //passing file bytes and file name for API call
          ApiClient.uploadFile(_paths!.first.bytes!, _paths!.first.name);
          filename2 = _paths!.first.name;
        }
      }
    });
  }

  void pickFiles3() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg', 'heic', 'pdf'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      if (_paths != null) {
        if (_paths != null) {
          //passing file bytes and file name for API call
          ApiClient2.uploadFile(_paths!.first.bytes!, _paths!.first.name);
          filename3 = _paths!.first.name;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Seller Registration")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              Container(
                width: 675, // Set your desired width here
                child: TextField(
                  controller: _companyNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Company Name',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 675, // Set your desired width here
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Address',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 675, // Set your desired width here
                child: TextField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Mobile Number',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 675, // Set your desired width here
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'E-mail',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 675, // Set your desired width here
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 675, // Set your desired width here
                child: TextField(
                  controller: _conpasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Conform Password',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 675, // Set your desired width here
                child: TextField(
                  controller: _nicController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'NIC',
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Select NIC Front and Back",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: pickFiles,
                    child: Container(
                      width: 146,
                      height: 112,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: const Color.fromARGB(50, 277, 277, 277),
                      ),
                      child: Column(
                        children: [
                          Spacer(),
                          Icon(
                            Icons.add_circle_rounded,
                            size: 40,
                            color: Colors.black54,
                          ),
                          Text(
                            "NIC - Front",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: pickFiles2,
                    child: Container(
                      width: 146,
                      height: 112,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: const Color.fromARGB(50, 277, 277, 277),
                      ),
                      child: Column(
                        children: [
                          Spacer(),
                          Icon(
                            Icons.add_circle_rounded,
                            size: 40,
                            color: Colors.black54,
                          ),
                          Text(
                            "NIC - Back",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Select BR",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                        onPressed: pickFiles3,
                        child: Text(
                          'Open File Picker',
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Text(
                    "",
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CheckboxListTile(
                          title: Text("Brand New"),
                          value: isCheckedBNew,
                          onChanged: (bool? newBool) {
                            setState(() {
                              isCheckedBNew = newBool;
                              if (newBool == true) {
                                selectedStringValue = "5";
                              } else {
                                selectedStringValue = null;
                              }
                              isCheckedBNew = newBool;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          title: Text("Recondition"),
                          value: isCheckedRecondition,
                          onChanged: (bool? newBool) {
                            setState(() {
                              isCheckedRecondition = newBool;
                              if (newBool == true) {
                                selectedStringValue2 = "6";
                              } else {
                                selectedStringValue2 = null;
                              }
                              isCheckedRecondition = newBool;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          title: Text("Locally used"),
                          value: isCheckedLocally,
                          onChanged: (bool? newBool) {
                            setState(() {
                              isCheckedLocally = newBool;
                              if (newBool == true) {
                                selectedStringValue3 = "7";
                              } else {
                                selectedStringValue3 = null;
                              }
                              isCheckedLocally = newBool;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ListTile(
                title: const Text('Privacy Policy Terms & Services'),
                leading: Icon(Icons.radio_button_checked),
              ),
              ElevatedButton(
                onPressed: () async {
                  String companyname = _companyNameController.text;
                  String address = _addressController.text;
                  String mobile = _mobileController.text;
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  String nic = _nicController.text;
                  String conpassword = _conpasswordController.text;
                  String brlink = "Fake_Link"; //These are fake values
                  String approveid = "4";
                  String nicfront = "Fake_Link";
                  String nicback = "Fake_Link";
                  // debugPrint(selectedStringValue);
                  // debugPrint(selectedStringValue2);
                  // debugPrint(selectedStringValue3);
                  var f1 = './icons/$filename1';
                  var f2 = './icons/$filename2';
                  var f3 = './icons/$filename3';
                  print(f1);
                  print(f2);

                  if (isCheckedBNew == true && isCheckedRecondition == false && isCheckedLocally == false) {
                    appr_id = "4";
                    debugPrint(appr_id);
                  } else if (isCheckedBNew == true && isCheckedRecondition == true && isCheckedLocally == false) {
                    appr_id = "5";
                    debugPrint(appr_id);
                  } else if (isCheckedBNew == true && isCheckedRecondition == true && isCheckedLocally == true) {
                    appr_id = "6";
                    debugPrint(appr_id);
                  } else if (isCheckedBNew == false && isCheckedRecondition == true && isCheckedLocally == false) {
                    appr_id = "7";
                    debugPrint(appr_id);
                  } else if (isCheckedBNew == false && isCheckedRecondition == true && isCheckedLocally == true) {
                    appr_id = "8";
                    debugPrint(appr_id);
                  } else if (isCheckedBNew == true && isCheckedRecondition == false && isCheckedLocally == true) {
                    appr_id = "9";
                    debugPrint(appr_id);
                  } else if (isCheckedBNew == false && isCheckedRecondition == false && isCheckedLocally == true) {
                    appr_id = "10";
                    debugPrint(appr_id);
                  } else {
                    _wrongCredentials();
                    return;
                  }  
                  if (companyname.isEmpty ||
                      companyname == null ||
                      password.isEmpty ||
                      password == null ||
                      nic.isEmpty ||
                      nic == null ||
                      mobile.isEmpty ||
                      mobile == null ||
                      email.isEmpty ||
                      email == null ||
                      conpassword.isEmpty ||
                      conpassword == null ||
                      appr_id == null ||
                      appr_id == "") {
                    _wrongCredentials();
                  } else if (password != conpassword) {
                    _passwordNotTheSame();
                  } else if (f1 == null ||
                      f1 == "" ||
                      f1 == "./icons/" ||
                      f2 == null ||
                      f2 == "" ||
                      f2 == "./icons/" ||
                      f3 == null ||
                      f3 == "" ||
                      f3 == "./icons/") {
                    _stillUploading();
                  } else {
                    await fetchDataRegister(
                      "https://my.partscart.lk/reg_vendor.php",
                      companyname,
                      address,
                      mobile,
                      nic,
                      f3,
                      email,
                      appr_id,
                      approveid,
                      f1,
                      f2,
                      password,
                    );

                    _userCreation(
                        "Success. Admin will approve your account soon.");
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(182, 21, 66, 126)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Set the button's border radius
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(Size(370, 65)),

                  // Set the button's minimum size
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w500, // Specify the desired text size
                  ),
                ),
              ),
              SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
