import 'package:http/http.dart' as http;

class DeleteProductService {
  static Future<bool> deleteProduct(int itemId) async {
    final url = Uri.parse('http://localhost:3000/api/items/$itemId');

    final response = await http.delete(url, headers: {'Content-Type': 'application/json'});

    return response.statusCode == 200;
  }
}
