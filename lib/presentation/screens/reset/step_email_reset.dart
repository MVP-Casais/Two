import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';
import 'package:two/providers/login_provider.dart';
import 'package:two/providers/password_reset_provider.dart';

class EmailStepReset extends StatelessWidget {
  final VoidCallback onNext;

  const EmailStepReset({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final loginProvider = Provider.of<LoginProvider>(context);
    final passwordResetProvider = Provider.of<PasswordResetProvider>(context);
    final TextEditingController emailController = TextEditingController(text: loginProvider.email);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Insira o seu E-mail para recuperação",
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
              backgroundColor: AppColors.primary,
              
              onPressed: () async {
                loginProvider.setEmail(emailController.text);
                if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digite um e-mail válido.')),
                  );
                  return;
                }
                final ok = await passwordResetProvider.sendCode(emailController.text);
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Código enviado para o e-mail.')),
                  );
                  onNext();
                } else if (passwordResetProvider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(passwordResetProvider.errorMessage!)),
                  );
                }
              },
              textColor: AppColors.neutral,
            ),
          ],
        ),
      ),
    );
  }
}
