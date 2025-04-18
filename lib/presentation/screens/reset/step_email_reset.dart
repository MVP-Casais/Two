import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';

class EmailStepReset extends StatelessWidget {
  final VoidCallback onNext;

  const EmailStepReset({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
      CrossAxisAlignment.stretch;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            "Insira o e-mail da sua conta",
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
              wordSpacing: screenWidth * 0.01,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: screenHeight * 0.03),
          TextField(
            decoration: InputDecoration(
              labelText: "nome@exemplo.com",
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
        ],
      ),
    );
  }
}
