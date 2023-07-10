import 'dart:io';
import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:gap/utils/device.dart';
import 'package:path_provider/path_provider.dart';

class QuotationReqest extends StatefulWidget {
  const QuotationReqest({super.key});

  @override
  State<QuotationReqest> createState() => _QuotationReqestState();
}

class _QuotationReqestState extends State<QuotationReqest> {
  bool? isCheckedBNew = false;
  bool? isCheckedRecondition = false;
  bool? isCheckedLocally = false;
  DateTime selectedDate = DateTime.now();
  Country? selectedCountry;
  String userID = "";

  TextEditingController _dateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController _partName = TextEditingController();
  TextEditingController _partNumber = TextEditingController();
  TextEditingController _partDescription = TextEditingController();
  TextEditingController _partModel = TextEditingController();
  TextEditingController _partAddition = TextEditingController();

  String?
      selectedStringValue; //Assigning a number to this variable upon the checkbox1
  String? selectedStringValue2; //assign 2
  String? selectedStringValue3; //assign 3 .......check boxes

  String condition_id = "";

  final ImagePicker imagePicker = ImagePicker();

  List<XFile> imageFileList = [];

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    getUSERSID();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);

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
        await uploadImage(imageFileList[index].path);
      }

      Navigator.of(context).pop(); // Close the uploading dialog
    }

    setState(() {});
  }

  List<String> _uploadedImageUrls = [];
  Future<void> uploadImage(String imagePath) async {
    if (imagePath == null) return;

    final url = Uri.parse(
        'https://my.partscart.lk/uploadFiles.php'); // Replace with your PHP script URL
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    final response = await request.send();
    if (response.statusCode == 200) {
      final imageUrl = await response.stream.bytesToString();
      setState(() {
        _uploadedImageUrls.add(imageUrl);
      });
      print(_uploadedImageUrls);
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

  Future<String> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return directory.path + '/request_id.json';
  }

  String req_ID = "";
  Future<String> loadRequestId(paraCountry) async {
    try {
      final filePath = await getFilePath();
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final jsonMap = json.decode(jsonString);
      print("Got data from json");
      print(jsonMap['request_id']);
      req_ID = jsonMap['request_id'];
      _process(paraCountry);
      return "";
    } catch (e) {
      return "error";
    }
  }

  Future<String> getUSERSID() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/data.json';

    bool fileExists = await File(filePath).exists();
    if (fileExists) {
      String jsonData = await File(filePath).readAsString();
      List<dynamic> dataList = json.decode(jsonData);

      for (var data in dataList) {
        userID = data['id'];
      }
    }
    return "";
  }

  void _process(countryZ) async {
    //Uncomment this after finishing the vendor frontend
    // Directory directory =
    //     await getApplicationDocumentsDirectory();
    // String filePath = '${directory.path}/data.json';

    // bool fileExists = await File(filePath).exists();
    // if (fileExists) {
    //   String jsonData = await File(filePath).readAsString();
    //   List<dynamic> dataList = json.decode(jsonData);

    //   for (var data in dataList) {
    //     setState(() {
    //       userID = data['id'];
    //     });
    //   }
    // }
    DateTime currentDateTime = DateTime.now();
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);

    var partname = _partName.text.trim();
    var dateTime = formattedDateTime;
    var partnum = _partNumber.text.trim();
    var partdesc = _partDescription.text.trim();
    var partcountry = selectedCountry != null ? countryZ : '';
    var partmodel = _partModel.text.trim();
    var partdate = _dateController.text.trim();
    var year = partdate.substring(0, 4);
    var partimg = _uploadedImageUrls.join(',');
    var partaddition = _partAddition.text.trim();
    var condition_id = "";

    if (partname.isEmpty ||
            partnum.isEmpty ||
            partdesc.isEmpty ||
            partcountry.isEmpty ||
            partmodel.isEmpty ||
            year.isEmpty
        // year.isEmpty
        ) {
      _wrongCredentials();
    } else {
      if (isCheckedBNew == true &&
          isCheckedRecondition == false &&
          isCheckedLocally == false) {
        condition_id = "4";
        debugPrint(condition_id);
      } else if (isCheckedBNew == true &&
          isCheckedRecondition == true &&
          isCheckedLocally == false) {
        condition_id = "5";
        debugPrint(condition_id);
      } else if (isCheckedBNew == true &&
          isCheckedRecondition == true &&
          isCheckedLocally == true) {
        condition_id = "6";
        debugPrint(condition_id);
      } else if (isCheckedBNew == false &&
          isCheckedRecondition == true &&
          isCheckedLocally == false) {
        condition_id = "7";
        debugPrint(condition_id);
      } else if (isCheckedBNew == false &&
          isCheckedRecondition == true &&
          isCheckedLocally == true) {
        condition_id = "8";
        debugPrint(condition_id);
      } else if (isCheckedBNew == true &&
          isCheckedRecondition == false &&
          isCheckedLocally == true) {
        condition_id = "9";
        debugPrint(condition_id);
      } else if (isCheckedBNew == false &&
          isCheckedRecondition == false &&
          isCheckedLocally == true) {
        condition_id = "10";
        debugPrint(condition_id);
      } else {
        _wrongCredentials();
        return;
      }
      print("seems fine");
      print(partimg);
      print(userID);
      try {
        final url = 'https://my.partscart.lk/insert_quotation.php';

        final response = await http.post(Uri.parse(url), body: {
          'partname': partname,
          'dateTime': dateTime,
          'partnum': partnum,
          'partdesc': partdesc,
          'partcountry': partcountry,
          'partmodel': partmodel,
          'partdate': year,
          'partimg': partimg,
          'partaddition': partaddition,
          'userID': userID,
          'condition_id': condition_id,
          'reqID': req_ID,
        });

        if (response.statusCode == 200) {
          final jsonData = response.body;
          // Print the echoing response of the PHP file
          print('PHP Response: $jsonData');
          // ... handle success or display a success message
        } else {
          print('API request failed with status code ${response.statusCode}');
          // ... handle error or display an error message
        }
      } catch (error) {
        print('Error: $error');
        // ... handle error or display an error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quotation Request",
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
                        return Image.file(
                          File(imageFileList[index].path),
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Condition',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Column(
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
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  )
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  loadRequestId(selectedCountry!.name);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Set the button's border radius
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(Size(500, 65)),
                  // Set the button's minimum size
                ),
                child: Text('Accept Order'),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
