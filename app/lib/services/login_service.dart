import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static final String baseUrl = 'http://localhost:3000/api';

  // LOGIN FUNCTION
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://localhost:3000/api/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        await prefs.setString('userID', data['user_id'].toString());

        // Store expiration time (15 minutes from now)
        final expiresAt = DateTime.now().add(Duration(minutes: 15)).toIso8601String();
        await prefs.setString('expiresAt', expiresAt);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  // CHECK IF TOKEN IS EXPIRED
  static Future<bool> isTokenExpired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? expiresAtString = prefs.getString('expiresAt');

    print("Stored expiration time in SharedPreferences: $expiresAtString");

    if (expiresAtString == null) return true;

    DateTime expiresAt = DateTime.parse(expiresAtString);
    print("Current time: ${DateTime.now()}");
    print("Expires at: $expiresAt");

    return DateTime.now().isAfter(expiresAt);
  }


  //REFRESH TOKEN FUNCTION
  static Future<String?> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      return null;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);

      // Update expiration time 15 minutes 
      DateTime expiresAt = DateTime.now().add(Duration(minutes: 15));
      await prefs.setString('expiresAt', expiresAt.toIso8601String());

      return data['accessToken'];
    } else {
      
      await prefs.clear();
      return null;
    }
  }

  //GET VALID ACCESS TOKEN 
  static Future<String?> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (await isTokenExpired()) {
    String? newAccessToken = await refreshToken();
    if (newAccessToken == null) {
      await logout(); 
      return null;
    }
    return newAccessToken;
  }

  return prefs.getString('accessToken');
}


  // LOGOUT FUNCTION
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
