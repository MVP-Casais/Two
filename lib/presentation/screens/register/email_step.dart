import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';
import 'package:two/providers/register_provider.dart';

class EmailStep extends StatelessWidget {
  final VoidCallback onNext;

  const EmailStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final TextEditingController emailController = TextEditingController(text: registerProvider.email);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.045,
      ),
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
          SizedBox(height: screenHeight * 0.02),
          CustomInput(
            labelText: "nome@exemplo.com",
            controller: emailController,
            onChanged: (value) => registerProvider.setEmail(value),
          ),
          SizedBox(height: screenHeight * 0.04),
          CustomButton(
            text: "Próximo",
            onPressed: () {
              registerProvider.setEmail(emailController.text);
              onNext();
            },
            backgroundColor: AppColors.primary,
            textColor: AppColors.neutral,
          ),
        ],
      ),
    );
  }
}
