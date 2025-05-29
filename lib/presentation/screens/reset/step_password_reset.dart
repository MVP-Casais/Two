import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';
import 'package:two/providers/login_provider.dart';
import 'package:two/providers/password_reset_provider.dart';

class PasswordStepReset extends StatefulWidget {
  final VoidCallback onComplete;

  const PasswordStepReset({super.key, required this.onComplete});

  @override
  State<PasswordStepReset> createState() => _PasswordStepState();
}

class _PasswordStepState extends State<PasswordStepReset> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final passwordResetProvider = Provider.of<PasswordResetProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Crie sua nova senha",
                style: TextStyle(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16),
              CustomInput(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                labelText: "Nova senha",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.icons,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              SizedBox(height: 5),
              Text(
                "A senha deve ter pelo menos 8 caracteres",
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                  color: AppColors.textSecondarylight,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Confirme sua senha",
                style: TextStyle(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16),
              CustomInput(
                controller: confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                labelText: "Confirme a nova senha",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.icons,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomButton(
                text: "Atualizar senha",
                onPressed: () async {
                  final password = passwordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();
                  if (password.isEmpty || confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos.')),
                    );
                    return;
                  }
                  if (password.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('A senha deve ter pelo menos 8 caracteres.')),
                    );
                    return;
                  }
                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('As senhas não coincidem.')),
                    );
                    return;
                  }
                  final ok = await passwordResetProvider.resetPassword(
                    loginProvider.email ?? '',
                    password,
                  );
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Senha redefinida com sucesso!')),
                    );
                    widget.onComplete();
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
      ),
    );
  }
}
