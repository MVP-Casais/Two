import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';

class PasswordStep extends StatefulWidget {
  final VoidCallback onNext;

  const PasswordStep({super.key, required this.onNext});

  @override
  State<PasswordStep> createState() => _PasswordStepState();
}

class _PasswordStepState extends State<PasswordStep> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.045),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Text(
            "Crie uma senha",
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: "******",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
          ),
          SizedBox(height: 5),
          Text("A senha deve ter pelo menos 8 caracteres",
              style: TextStyle(
                fontSize: screenHeight * 0.015,
                color: AppColors.textSecondarylight,
              )),
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
          TextField(
            controller: confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            decoration: InputDecoration(
              hintText: "Confirme sua senha",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
          ),
          SizedBox(height: 32),
          CustomButton(
            text: "Próximo",
            onPressed: widget.onNext,
            backgroundColor: AppColors.primary,
            textColor: AppColors.neutral,
          ),
        ],
      ),
    );
  }
}
