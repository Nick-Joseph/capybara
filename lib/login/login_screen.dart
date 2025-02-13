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

  void signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await _authService.signUp(email, password);

    if (user != null) {
      GoRouter.of(context).go('/'); //
      print('Sign Up Successful: ${user.email}');
      // Navigate to home screen
    } else {
      print('Sign Up Failed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Failed. Check your credentials')),
      );
    }
  }

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    final user = await _authService.signIn(email, password);

    if (user != null) {
      GoRouter.of(context).go('/'); // Redirect after login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed. Check your credentials')),
      );
    }
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
              style: TextStyle(fontSize: 40),
            ),
            Container(
                height: 300,
                width: 300,
                child: Image.asset('lib/assets/loginpicture.png')),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
