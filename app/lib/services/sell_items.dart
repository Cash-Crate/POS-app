import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/login_service.dart';

class ProductService {
  static Future<bool> sellItem(int itemId, int quantity) async {
    // Retrieve the access token
    String? token = await LoginService.getAccessToken(); 

    if (token == null || token.isEmpty) {
      print("No access token found");
      return false;
    }


    final url = Uri.parse('http://localhost:3000/api/items/$itemId/$quantity'); 
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json', 
        'Authorization': 'Bearer $token',  
      },
    );

    // Debugging logs
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

 
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] != null && data['message']!.contains('successfully')) {
        return true;
      } else {
        print("Item update failed: ${data['message']}");
        return false;
      }
    } else {
      print('Error: ${response.body}'); 
      return false; 
    }
  }
}
