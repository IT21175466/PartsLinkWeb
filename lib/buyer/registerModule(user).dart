//Backend Module of User Registration
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> fetchDataRegister(String urlz, String user, String password,
    String email, String mobile) async {
  final url = Uri.parse(urlz);
  //sending required data to the php
  try {
    final response = await http.get(url, headers: {
      'user': user,
      'password': password,
      'email': email,
      'mobile': mobile,
    });

    if (response.statusCode == 200) {
      final jsonData = response.body;
      return "Account created successfully";
    } else {
      return ('API request failed with status code ${response.statusCode}');
    }
  } catch (error) {
    return ('Error: $error');
  }
}
