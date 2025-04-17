import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';

class EmailStep extends StatelessWidget {
  final VoidCallback onNext;

  const EmailStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.045),
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
          SizedBox(height: 16),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "nome@exemplo.com",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 32),
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
