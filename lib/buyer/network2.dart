import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'vendorForm.dart';
import 'package:http/http.dart' as http;

class ApiClient2 {
  static var dio = Dio();

  static Future<void> uploadFile(List<int> file, String fileName) async {
    if (file == null) return;

    final url = Uri.parse('https://my.partscart.lk/uploadF.php'); // Replace with your PHP script URL
    final request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      file,
      filename: fileName,
      contentType: MediaType('image', 'png'),
    ));

    final response = await request.send();
    if (response.statusCode == 200) {
      final imageUrl = await response.stream.bytesToString();
      print(imageUrl);
      print(fileName);

      // Extract the image file name from the path
      // String imageName = _selectedImage!.path.split('/').last;

      // // Print the image file name for debugging
      // print(imageName);
    }
  }
}
