import 'dart:io';
import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '/utils/device.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;

class RequestPart extends StatefulWidget {
  const RequestPart({super.key});

  @override
  State<RequestPart> createState() => _RequestPartState();
}

class _RequestPartState extends State<RequestPart> {
  DateTime selectedDate = DateTime.now();
  Country? selectedCountry;

  final ImagePicker imagePicker = ImagePicker();

  List<PlatformFile> imageFileList = [];

  TextEditingController _dateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController _partName = TextEditingController();
  TextEditingController _partNumber = TextEditingController();
  TextEditingController _partDescription = TextEditingController();
  TextEditingController _partModel = TextEditingController();
  TextEditingController _partAddition = TextEditingController();
  String userID = "";
  bool? check1 = false;
  bool? check2 = false;
  bool? check3 = false;
  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    retrieveUserData();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _wrongCredentials() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Data Entering Error"),
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

  void _successMSG() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Sending Request"),
          content: Text("Your request sent successfully."),
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

  void selectImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      List<PlatformFile> pickedFiles = result.files;
      imageFileList.addAll(pickedFiles);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Uploading Images'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Uploading...'),
              ],
            ),
          );
        },
      );

      for (int index = 0; index < imageFileList.length; index++) {
        await uploadImage(imageFileList[index]);
      }

      Navigator.of(context).pop(); // Close the uploading dialog
    }

    setState(() {});
  }

  List<String> _uploadedImageUrls = [];
  Future<void> uploadImage(PlatformFile platformFile) async {
    final bytes = platformFile.bytes;
    if (bytes == null) return;

    final url = Uri.parse(
        'https://my.partscart.lk/uploadFiles.php'); // Replace with your PHP script URL
    final request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      bytes,
      filename: platformFile.name,
    ));

    final response = await request.send();
    if (response.statusCode == 200) {
      final imageUrl = await response.stream.bytesToString();
      setState(() {
        _uploadedImageUrls.add(imageUrl);
      });
      print(_uploadedImageUrls);
    }
  }

  sendDataToApi(
      String para_name,
      String para_num,
      String para_desc,
      String para_country,
      String para_model,
      String para_date,
      String para_img,
      String para_addition,
      String user_ID) async {
    print("aawaa");
    var url =
        'https://my.partscart.lk/reqPart.php'; // Replace with your API endpoint

    DateTime currentDateTime = DateTime.now();

    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);
    print('User idddd:$userID');
    var data = {
      'part_name': para_name,
      'part_number': para_num,
      'part_desc': para_desc,
      'part_country': para_country,
      'part_model': para_model,
      'part_date': para_date,
      'part_img': para_img,
      'part_addition': para_addition,
      'user_ID': userID,
      'date_time': formattedDateTime,
    };

    var response = await http.post(Uri.parse(url), body: data);

    if (response.statusCode == 200) {
      // Request successful, do something with the response
      print(response.body);
      _successMSG();
    } else {
      // Request failed, handle the error
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text =
            '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
      });
    }
  }

  Future<void> retrieveUserData() async {
    final storage = html.window.localStorage;
    String? storedData = storage['data.json'];
    if (storedData != null) {
      List<dynamic> dataList = json.decode(storedData) as List<dynamic>;
      for (var item in dataList) {
        userID = item['id']
            as String; // Update this line to assign the value to the class-level variable
        print(userID);
        // Do something with the retrieved data
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Request a Part",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color.fromARGB(120, 0, 9, 225),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                width: 500,
                child: TextField(
                  controller: _partName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Part Name',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 500,
                child: TextField(
                  controller: _partNumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Part Number',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 500,
                child: TextField(
                  controller: _partDescription,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Description',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 500,
                child: TextField(
                  controller: countryController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: selectedCountry != null
                        ? '${selectedCountry!.name}'
                        : 'Select Country',
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: false,
                          onSelect: (Country country) {
                            setState(() {
                              selectedCountry = country;
                            });
                          },
                        );
                      },
                      icon: Icon(Icons.adaptive.arrow_forward),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 500,
                child: TextField(
                  controller: _partModel,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Model',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 500,
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    // ignore: unnecessary_null_comparison
                    hintText: selectedDate == null
                        ? '${selectedDate.year}'
                        : 'Select Year',
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: isIOS
                        ? IconButton(
                            icon: Icon(Icons.edit_calendar_outlined),
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext builder) {
                                  return Container(
                                    height: 300,
                                    child: CupertinoDatePicker(
                                      initialDateTime: selectedDate,
                                      onDateTimeChanged: (DateTime newDate) {
                                        setState(() {
                                          selectedDate = newDate;
                                          _dateController.text =
                                              '${selectedDate.year}';
                                        });
                                      },
                                      mode: CupertinoDatePickerMode.date,
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.edit_calendar_rounded),
                            onPressed: () {
                              _showDatePicker(context);
                              (DateTime newDate) {
                                setState(() {
                                  selectedDate = newDate;
                                  _dateController.text = '${selectedDate.year}';
                                });
                              };
                            },
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  Text(
                    'Images',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: const Color.fromARGB(50, 277, 277, 277),
                    ),
                    child: Column(
                      children: [
                        Spacer(),
                        GestureDetector(
                          child: Icon(
                            Icons.add_circle_rounded,
                            size: 40,
                            color: Colors.black54,
                          ),
                          onTap: () {
                            selectImages();
                          },
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GridView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final bytes = imageFileList[index].bytes;
                        final base64Image = base64Encode(bytes!);
                        return Image.memory(
                          base64Decode(base64Image),
                          fit: BoxFit.cover,
                        );
                      },
                      itemCount: imageFileList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ],
              ),
              Container(
                width: 500,
                child: TextField(
                  maxLines: 5,
                  controller: _partAddition,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Addition',
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 450,
                child: CheckboxListTile(
                  value: check1,
                  controlAffinity:
                      ListTileControlAffinity.leading, //checkbox at left
                  onChanged: (bool? value) {
                    setState(() {
                      check1 = value;
                    });
                  },
                  title: Text("Brand New"),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 450,
                child: CheckboxListTile(
                  value: check2,
                  controlAffinity:
                      ListTileControlAffinity.leading, //checkbox at left
                  onChanged: (bool? value) {
                    setState(() {
                      check2 = value;
                    });
                  },
                  title: Text("Recondition"),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 450,
                child: CheckboxListTile(
                  value: check3,
                  controlAffinity:
                      ListTileControlAffinity.leading, //checkbox at left
                  onChanged: (bool? value) {
                    setState(() {
                      check3 = value;
                    });
                  },
                  title: Text("Locally used"),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  var partname = _partName.text.trim();
                  var partnum = _partNumber.text.trim();
                  var partdesc = _partDescription.text.trim();
                  var partcountry =
                      selectedCountry != null ? '${selectedCountry!.name}' : '';
                  var partmodel = _partModel.text.trim();
                  var partdate = _dateController.text.trim();
                  var year = partdate.substring(0, 4);
                  var partimg = _uploadedImageUrls.join(',');
                  var partaddition = _partAddition.text.trim();

                  if (partname.isEmpty ||
                      partnum.isEmpty ||
                      partdesc.isEmpty ||
                      partcountry.isEmpty ||
                      partmodel.isEmpty ||
                      year.isEmpty) {
                    _wrongCredentials();
                  } else {
                    await sendDataToApi(
                        partname,
                        partnum,
                        partdesc,
                        partcountry,
                        partmodel,
                        year,
                        partimg,
                        partaddition,
                        userID);
                    // print("$year");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    color: const Color.fromARGB(255, 57, 55, 70),
                  ),
                  height: 80,
                  width: 500,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Spacer(),
                      Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.adaptive.arrow_forward,
                        color: const Color.fromARGB(255, 192, 188, 188),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
