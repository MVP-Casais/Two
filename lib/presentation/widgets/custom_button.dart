import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final BorderSide? borderSide;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.onPressed,
    this.textColor,
    this.borderSide,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.055,
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(
            fontSize: screenHeight * 0.02,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(width: 10),
            ],
            Text(text, style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}
