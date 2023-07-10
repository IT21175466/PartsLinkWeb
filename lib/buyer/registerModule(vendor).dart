//Backend Module for Vendor Registration
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
 
fetchDataRegister(
  String urlz,
  String companyname,
  String address,
  String mobile,
  String nic,
  String brlink,
  String email,
  String appr_id,
  String approveid,
  String nicfront,
  String nicback,
  String password,
) async {
  final url = Uri.parse(urlz);

  // Prepare the data to be sent in the request body
  final data = {
    'companyname': companyname,
    'address': address,
    'mobile': mobile,
    'nic': nic,
    'brlink': brlink,
    'email': email,
    'checkbox': appr_id,
    'approveid': approveid,
    'nicfront': nicfront,
    'nicback': nicback,
    'password': password,
  };

  try {
    final response = await http.post(url, body: data);

    // Print the entered details and values sent to PHP
    print('Entered Details:');
    print('Company Name: $companyname');
    print('Address: $address');
    print('Mobile: $mobile');
    print('NIC: $nic');
    print('BR Link: $brlink');
    print('Email: $email');
    print('Checkbox: $appr_id');
    print('Approve ID: $approveid');
    print('NIC Front: $nicfront');
    print('NIC Back: $nicback');
    print('Password: $password');

    if (response.statusCode == 200) {
      final jsonData = response.body;
      // Print the echoing response of the PHP file
      print('PHP Response: $jsonData');
      return "Account created successfully";
    } else {
      return ('API request failed with status code ${response.statusCode}');
    }
  } catch (error) {
    return ('Error: $error');
  }
}
