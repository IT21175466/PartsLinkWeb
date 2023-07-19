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
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'package:file_picker/file_picker.dart';

class editQuotationReqest extends StatefulWidget {
  const editQuotationReqest({super.key});

  @override
  State<editQuotationReqest> createState() => _editQuotationReqestState();
}

class _editQuotationReqestState extends State<editQuotationReqest> {
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
  TextEditingController _partYear = TextEditingController();

  String?
      selectedStringValue; //Assigning a number to this variable upon the checkbox1
  String? selectedStringValue2; //assign 2
  String? selectedStringValue3; //assign 3 .......check boxes

  String condition_id = "";

  final ImagePicker imagePicker = ImagePicker();

  List<PlatformFile> imageFileList = [];

  @override
  void initState() {
    super.initState();
    loadRequestId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void sendME(paraCountry) {
    final paraName = _partName.text.trim();
    final paraPrice = _partNumber.text.trim();
    final paraDesc = _partDescription.text.trim();
    final paraModel = _partModel.text.trim();
    final paraYear = _partYear.text.trim();
    if (_uploadedImageUrls.isNotEmpty) {
      var partimg = _uploadedImageUrls.join(',');
      if (paraName.isNotEmpty &&
          paraPrice.isNotEmpty &&
          paraModel.isNotEmpty &&
          paraYear.isNotEmpty) {
        sendMetoDB(paraName, paraPrice, paraModel, paraYear, partimg,
            paraCountry, paraDesc);
      }
    } else {
      if (paraName.isNotEmpty &&
          paraPrice.isNotEmpty &&
          paraModel.isNotEmpty &&
          paraYear.isNotEmpty) {
        sendMetoDB2(
            paraName, paraPrice, paraModel, paraYear, paraCountry, paraDesc);
      }
    }
  }

  void sendMetoDB(p1, p2, p3, p4, p5, p6, p7) async {
    try {
      final url = 'https://my.partscart.lk/update_the_vendor_quotation.php';
      final dataSend = {
        'nid': notify_ID,
        'paraName': p1,
        'paraPrice': p2,
        'paraModel': p3,
        'paraYear': p4,
        'paraImage': p5,
        'paraCountry': p6,
        'paraDescription': p7,
        // Add more key-value pairs as needed
      };
      final response = await http.post(Uri.parse(url), body: dataSend);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        print(jsonData);
        _updatedAlert();
      }
    } catch (Exception) {
      print(Exception);
    }
  }

  void sendMetoDB2(p1, p2, p3, p4, p5, p6) async {
    try {
      final url = 'https://my.partscart.lk/update_withoutImage.php';
      final dataSend = {
        'nid': notify_ID,
        'paraName': p1,
        'paraPrice': p2,
        'paraModel': p3,
        'paraYear': p4,
        'paraCountry': p5,
        'paraDescription': p6,
        // Add more key-value pairs as needed
      };
      final response = await http.post(Uri.parse(url), body: dataSend);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        print(jsonData);
        _updatedAlert();
      }
    } catch (Exception) {
      print(Exception);
    }
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

  void _updatedAlert() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Data Update"),
          content: Text("Date update process : success."),
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

  // Future<String> getFilePath() async {
  //   final directory = await getTemporaryDirectory();
  //   return directory.path + '/notify_ID.json';
  // }

  String notify_ID = "";
  Future<void> loadRequestId() async {
    try {
      final storage = html.window.localStorage;
      if (storage != null) {
        String? storedData = storage['notify_ID2.json'];
        if (storedData != null) {
          Map<String, dynamic> dataMap = jsonDecode(storedData);
          if (dataMap.containsKey('notify_ID')) {
            notify_ID = dataMap['notify_ID'];
            print(notify_ID);
            loadDatatoPlaceholders();
            return;
          }
        }
      }
    } catch (e) {
      print('Error loading request ID: $e');
    }
  }

  String partCountry = "";
  String partImgz = "";
  void loadDatatoPlaceholders() async {
    try {
      print("id is:$notify_ID");
      final url = 'https://my.partscart.lk/update_the_quota.php';
      final dataSend = {'nid': notify_ID};
      final response = await http.post(Uri.parse(url), body: dataSend);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        // Parse the JSON response
        print(jsonData);
        final responseData = jsonDecode(jsonData)[0];

        if (responseData.isNotEmpty) {
          final notificationData = responseData;
          // Access the values from the notificationData map
          final partName = notificationData['part_name'];
          final partNumber = notificationData['part_no'];
          final partDescription = notificationData['description'];
          final partModel = notificationData['model'];
          final partYear = notificationData['year_of_make'];
          partCountry = notificationData['country'];
          print(partCountry);
          partImgz = notificationData['image_link'];
          print(partImgz);

          // Update the text of the corresponding TextEditingController
          _partName.text = partName;
          _partNumber.text = partNumber;
          _partDescription.text = partDescription;
          _partModel.text = partModel;
          _partYear.text = partYear;
        }
      }
    } catch (error) {
      print('Failed to fetch notifications. Error: $error');
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
              Text(
                "If you do not edit these fields they will be reverted to their default values.",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
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
                    labelText: 'Part Price',
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
                    labelText: 'Part Description',
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
                        : 'Select a country',
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
                    labelText: 'Part Model',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 500,
                child: TextField(
                  controller: _partYear,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Part Year',
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  selectedCountry != null
                      ? sendME(selectedCountry!.name)
                      : sendME(partCountry);
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
                child: Text('Edit the quotation'),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
