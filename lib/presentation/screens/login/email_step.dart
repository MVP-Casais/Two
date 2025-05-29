import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/register/register_screen.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';
import 'package:two/providers/login_provider.dart';

class EmailStep extends StatelessWidget {
  final VoidCallback onNext;

  const EmailStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final loginProvider = Provider.of<LoginProvider>(context);
    final TextEditingController emailController = TextEditingController(text: loginProvider.email);

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
            CustomInput(
              labelText: "Digite seu e-mail",
              controller: emailController,
              onChanged: (value) => loginProvider.setEmail(value),
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomButton(
              text: "Próximo",
              onPressed: () {
                loginProvider.setEmail(emailController.text);
                onNext();
              },
              backgroundColor: AppColors.primary,
              textColor: AppColors.neutral,
            ),
            SizedBox(height: screenHeight * 0.02),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
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
