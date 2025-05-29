import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:two/providers/login_provider.dart';
import 'package:two/providers/password_reset_provider.dart';

class VerificationStepReset extends StatelessWidget {
  final VoidCallback onNext;

  const VerificationStepReset({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final loginProvider = Provider.of<LoginProvider>(context);
    final passwordResetProvider = Provider.of<PasswordResetProvider>(context);
    final List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());
    final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
              "O código foi enviado para o seu email: ${loginProvider.email ?? ''}",
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
                  child: Center(
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 45,
                        color: AppColors.titlePrimary,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextButton(
              onPressed: () async {
                final ok = await passwordResetProvider.sendCode(loginProvider.email ?? '');
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Código reenviado para o e-mail.')),
                  );
                } else if (passwordResetProvider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(passwordResetProvider.errorMessage!)),
                  );
                }
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
              text: "Próximo",
              onPressed: () async {
                final code = controllers.map((c) => c.text).join();
                if (code.length != 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digite o código completo.')),
                  );
                  return;
                }
                final ok = await passwordResetProvider.verifyCode(loginProvider.email ?? '', code);
                if (ok) {
                  onNext();
                } else if (passwordResetProvider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(passwordResetProvider.errorMessage!)),
                  );
                }
              },
              backgroundColor: AppColors.primary,
              textColor: AppColors.neutral,
            ),
          ],
        ),
      ),
    );
  }
}
