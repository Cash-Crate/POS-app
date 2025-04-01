import 'package:http/http.dart' as http;
import '../services/login_service.dart';
class DeleteProductService {
  static Future<bool> deleteProduct(int itemId) async {
    final url = Uri.parse('http://localhost:3000/api/items/$itemId');

    // Fetch the access token
    String? token = await LoginService.getAccessToken(); 

    if (token == null || token.isEmpty) {
      print("No access token found");
      return false;
    }

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  
      },
    );

    return response.statusCode == 200;
  }
}
