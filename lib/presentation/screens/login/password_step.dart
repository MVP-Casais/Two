import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/reset/reset_password.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';
import 'package:two/providers/login_provider.dart';

class PasswordStep extends StatefulWidget {
  final VoidCallback onNext;

  const PasswordStep({super.key, required this.onNext});

  @override
  State<PasswordStep> createState() => _PasswordStepState();
}

class _PasswordStepState extends State<PasswordStep> {
  bool _obscureText = true;
  bool _rememberPassword = false;
  final TextEditingController passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    passwordController.text = loginProvider.senha ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Senha",
              style: TextStyle(
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
                color: AppColors.titlePrimary,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomInput(
              obscureText: _obscureText,
              labelText: "Digite sua senha",
              controller: passwordController,
              onChanged: (value) => loginProvider.setSenha(value),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberPassword,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _rememberPassword = value ?? false;
                        });
                      },
                    ),
                    Text(
                      "Lembrar senha",
                      style: TextStyle(
                        color: AppColors.titlePrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: screenHeight * 0.016,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPassword(),
                      ),
                    );
                  },
                  child: Text(
                    "Esqueci a senha",
                    style: TextStyle(
                      color: AppColors.titlePrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: screenHeight * 0.016,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomButton(
              text: "Próximo",
              onPressed: () async {
                loginProvider.setSenha(passwordController.text);
                final success = await loginProvider.login();
                if (!mounted) return;
                if (success) {
                  widget.onNext();
                } else if (loginProvider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loginProvider.errorMessage!)),
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
