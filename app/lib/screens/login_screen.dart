import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../services/login_service.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    bool success = await LoginService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Redirect to dashboard
      );
    } else {
      setState(() {
        errorMessage = "Invalid email or password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/CashCrateLogo.webp', width: 100), // Add your logo
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : handleLogin,
                child: isLoading ? CircularProgressIndicator() : Text("Log In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
