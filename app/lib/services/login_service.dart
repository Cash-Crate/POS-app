import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static final String baseUrl = 'http://localhost:3000/api';

  // LOGIN FUNCTION
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

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
        print("Login successful, response data: $data");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        await prefs.setString('userID', data['user_id'].toString());
        print("Stored userID in SharedPreferences: \${data['user_id']}");

        // Ensure expiration time is set correctly
        final expiresAt = DateTime.now().add(Duration(minutes: 15)).toIso8601String();
        await prefs.setString('expiresAt', expiresAt);

        // Log user session
        await logUserSession(data['user_id'].toString());
        return true;
      } else {
        print("Login failed with status code: \${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  // LOG USER SESSION ON LOGIN
  static Future<void> logUserSession(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print("No access token found, skipping session log.");
      return;
    }

    print("Logging user session with user_id: $userId");

    final url = Uri.parse('$baseUrl/logins/create');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'user_id': userId}),
      );

      print("Log user session response status: \${response.statusCode}");
      print("Log user session response body: \${response.body}");

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        String loginId = data['login_id'].toString();
        await prefs.setString('loginID', loginId);

        // debugging purposes
        print("User session logged successfully with login_id: $loginId");
      } else {
        print("Failed to log user session: \${response.body}");
      }
    } catch (e) {
      print("Error logging user session: $e");
    }
  }

  // CHECK IF TOKEN IS EXPIRED
  static Future<bool> isTokenExpired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? expiresAtString = prefs.getString('expiresAt');

    print("Stored expiration time in SharedPreferences: $expiresAtString");

    if (expiresAtString == null) return true;

    DateTime expiresAt = DateTime.parse(expiresAtString);
    print("Current time: \${DateTime.now()}");
    print("Expires at: $expiresAt");

    return DateTime.now().isAfter(expiresAt);
  }

  // REFRESH TOKEN FUNCTION
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

  // GET VALID ACCESS TOKEN
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

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve login_id instead of user_id
    String? loginId = prefs.getString('loginID');
    print("Login ID before logout: $loginId");

    if (loginId != null) {
      await removeUserSession(loginId);
    }

    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('expiresAt');
    await prefs.remove('loginID'); 

    print("SharedPreferences after logout:");
    print("Login ID: \${prefs.getString('loginID')}");
  }

  static Future<void> removeUserSession(String loginId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print("No access token found, skipping session removal.");
      return;
    }

    print("Removing session for login_id: $loginId");

    final url = Uri.parse('$baseUrl/logins/$loginId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      // debugging purposes
      print("Session removal response: \${response.statusCode}");
      print("Response body: \${response.body}");

      if (response.statusCode == 200) {
        print("User session removed successfully");
      } else {
        print("Failed to remove user session: \${response.body}");
      }
    } catch (e) {
      print("Error removing user session: $e");
    }
  }
}
