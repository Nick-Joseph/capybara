import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onPressed;

  const SignInButton({
    Key? key,
    required this.imageAsset,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        height: 90,
        width: 60,
        child: Container(
          child: Image.asset(imageAsset),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
