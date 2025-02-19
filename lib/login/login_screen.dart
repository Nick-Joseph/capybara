import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false; // Track loading state
  bool _isEmailValid = true; // Track email validity

  void signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (_validateInputs(email, password)) {
      setState(() {
        _isLoading = true;
      });

      User? user = await _authService.signUp(email, password);

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        GoRouter.of(context).go('/');
        print('Sign Up Successful: ${user.email}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Sign Up Failed. Please check your credentials.')),
        );
      }
    }
  }

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (_validateInputs(email, password)) {
      setState(() {
        _isLoading = true;
      });

      final user = await _authService.signIn(email, password);

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        GoRouter.of(context).go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Login Failed. Please check your credentials.')),
        );
      }
    }
  }

  bool _validateInputs(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return false;
    }
    if (!_isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email.')),
      );
      return false;
    }
    return true;
  }

  void _validateEmail(String email) {
    setState(() {
      _isEmailValid =
          RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
              .hasMatch(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Capybara!',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 250,
              width: 250,
              child: Image.asset('lib/assets/loginpicture.png'),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _emailController,
              onChanged:
                  _validateEmail, // Trigger email validation on text change
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorText: !_isEmailValid
                    ? 'Please enter a valid email.'
                    : null, // Show error text when invalid
                errorStyle: TextStyle(color: Colors.red),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text('Sign In', style: TextStyle(fontSize: 18)),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: signUp,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: Colors.teal[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text('Sign Up', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
