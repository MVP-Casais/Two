import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';
import 'package:two/providers/register_provider.dart';

class PasswordStep extends StatefulWidget {
  final VoidCallback onNext;

  const PasswordStep({super.key, required this.onNext});

  @override
  State<PasswordStep> createState() => _PasswordStepState();
}

class _PasswordStepState extends State<PasswordStep> {
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final TextEditingController passwordController =
        TextEditingController(text: registerProvider.senha ?? '');
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.045,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: screenHeight * 0.02),
          Text(
            "Crie uma senha",
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: screenHeight * 0.02),
          CustomInput(
            controller: passwordController,
            obscureText: !_isPasswordVisible,
            labelText: "Senha",
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
            onChanged: (value) => registerProvider.setSenha(value),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            "A senha deve ter pelo menos 8 caracteres",
            style: TextStyle(
              fontSize: screenHeight * 0.015,
              color: AppColors.textSecondarylight,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            "Confirme sua senha",
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: screenHeight * 0.02),
          CustomInput(
            controller: confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            labelText: "Confirme sua senha",
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.icons,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.04),
          CustomButton(
            text: "Próximo",
            onPressed: () {
              registerProvider.setSenha(passwordController.text);
              widget.onNext();
            },
            backgroundColor: AppColors.primary,
            textColor: AppColors.neutral,
          ),
        ],
      ),
    );
  }
}
