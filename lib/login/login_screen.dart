import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import 'dart:io';
import 'package:capybara/widgets/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  final String termsOfServiceUrl = 'https://yourwebsite.com/terms';
  final String privacyPolicyUrl = 'https://yourwebsite.com/privacy';

  Future<void> _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _validateEmail(String email) {
    setState(() {
      _isEmailValid =
          RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
              .hasMatch(email);
    });
  }

  void _validatePassword(String password) {
    setState(() {
      _isPasswordValid = password.length >= 6;
    });
  }

  void _signInWithEmail() async {
    if (!_isEmailValid || !_isPasswordValid) return;

    setState(() => _isLoading = true);
    final user = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (user != null) {
      GoRouter.of(context).go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed. Check credentials.')),
      );
    }
  }

  void _signUpWithEmail() async {
    if (!_isEmailValid || !_isPasswordValid) return;

    setState(() => _isLoading = true);
    final user = await _authService.signUpWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (user != null) {
      GoRouter.of(context).go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-Up Failed. Try again.')),
      );
    }
  }

  void _signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      GoRouter.of(context).go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Failed.')),
      );
    }
  }

  void _signInWithApple() async {
    final user = await _authService.signInWithApple();
    if (user != null) {
      GoRouter.of(context).go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Apple Sign-In Failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Capybara!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            SizedBox(height: 20),
            Image.asset('lib/assets/loginpicture.png', height: 250, width: 250),
            SizedBox(height: 30),
            _buildTextField(
              _emailController,
              "Email",
              _validateEmail,
              !_isEmailValid,
              "Invalid email format",
            ),
            SizedBox(height: 20),
            _buildTextField(
              _passwordController,
              "Password",
              _validatePassword,
              !_isPasswordValid,
              "Password must be at least 6 characters",
              obscureText: true,
            ),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      _buildButton("Sign In", _signInWithEmail),
                      SizedBox(height: 10),
                      _buildButton("Sign Up", _signUpWithEmail,
                          isOutlined: true),
                      SizedBox(height: 20),
                      _buildSocialButtons(),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _launchUrl(termsOfServiceUrl),
                        child: const Text("Terms of Service",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline)),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _launchUrl(privacyPolicyUrl),
                        child: const Text("Privacy Policy",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // 🔹 Custom Text Field with Red Border for Errors
  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    Function(String) onChanged,
    bool hasError,
    String errorMessage, {
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? Colors.red : Colors.transparent,
              width: 2,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // 🔹 Custom Button
  Widget _buildButton(String text, VoidCallback onPressed,
      {bool isOutlined = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : Color(0xFF2D3142),
          foregroundColor: isOutlined ? Color(0xFF2D3142) : Colors.white,
          side: isOutlined
              ? BorderSide(color: Color(0xFF2D3142))
              : BorderSide.none,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 🔹 Social Sign-In Buttons
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPillIconButton("lib/assets/google_button.png", _signInWithGoogle),
        if (Platform.isIOS) SizedBox(width: 16),
        if (Platform.isIOS)
          _buildPillIconButton(
              "lib/assets/apple_buttonx2.png", _signInWithApple,
              isDark: true),
      ],
    );
  }

// 🔹 Custom Pill Icon Button
  Widget _buildPillIconButton(String asset, VoidCallback onPressed,
      {bool isDark = false}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 75, // Circular pill shape
        height: 75,
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
          ],
          border: isDark ? null : Border.all(color: Colors.grey.shade300),
        ),
        padding: EdgeInsets.all(12),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}
