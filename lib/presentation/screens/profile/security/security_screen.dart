import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_input.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Senha e Segurança'),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenWidth * 0.1),
            _buildInputWithTitle(
              'Senha Atual',
              'Digite sua senha atual',
              _isCurrentPasswordVisible,
              () {
                setState(() {
                  _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                });
              },
            ),
            SizedBox(height: screenWidth * 0.05),
            _buildInputWithTitle(
              'Nova Senha',
              'Digite sua nova senha',
              _isNewPasswordVisible,
              () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
            ),
            SizedBox(height: screenWidth * 0.05),
            _buildInputWithTitle(
              'Confirmar Nova Senha',
              'Confirme sua nova senha',
              _isConfirmPasswordVisible,
              () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            SizedBox(height: screenWidth * 0.3),
            GestureDetector(
              onTap: () {
                // ação de excluir conta
              },
              child: Center(
                child: Text(
                  'Excluir conta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildInputWithTitle(
    String title,
    String label,
    bool isPasswordVisible,
    VoidCallback toggleVisibility,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.titlePrimary,
          ),
        ),
        const SizedBox(height: 8),
        CustomInput(
          labelText: label,
          obscureText: !isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: toggleVisibility,
          ),
        ),
      ],
    );
  }
}
