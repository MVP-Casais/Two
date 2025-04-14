import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';

class EmailStep extends StatelessWidget {
  final VoidCallback onNext;

  const EmailStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "E-mail",
              style: TextStyle(
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
                color: AppColors.titlePrimary,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: screenHeight * 0.03),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite seu e-mail",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomButton(
              text: "Próximo",
              onPressed: onNext,
              backgroundColor: AppColors.primary,
              textColor: AppColors.neutral,
            ),
            SizedBox(height: screenHeight * 0.02),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                "Criar uma conta",
                style: TextStyle(
                  color: AppColors.titlePrimary,
                  fontSize: screenHeight * 0.018,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
