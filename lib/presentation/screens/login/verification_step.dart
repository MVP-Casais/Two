import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';

class VerificationStep extends StatelessWidget {
  final VoidCallback onComplete;

  const VerificationStep({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.045), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Insira o código",
              style: TextStyle(
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
                color: AppColors.titlePrimary,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "O código foi enviado para o seu email: usuario@email.com",
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: AppColors.textSecondarydark,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => Container(
                  width: screenHeight * 0.07,
                  height: screenHeight * 0.10,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.inputBorder),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextButton(
              onPressed: () {
                // Implementar lógica de reenviar código
              },
              child: Text(
                "Reenviar código",
                style: TextStyle(
                  color: AppColors.titlePrimary,
                  fontSize: screenHeight * 0.018,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomButton(
              text: "Entrar",
              onPressed: onComplete,
              backgroundColor: AppColors.primary,
              textColor: AppColors.neutral,
            ),
          ],
        ),
      ),
    );
  }
}
