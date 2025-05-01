import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, size: 20, color: AppColors.icons),
          ),
          centerTitle: true,
          title: const Text(
            'Senha e Segurança',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
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
              ],
            ),
          ),
          Positioned(
            bottom: screenWidth * 0.05,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: CustomButton(
              backgroundColor: AppColors.primary,
              text: 'Salvar Alterações',
              textColor: AppColors.neutral,
              onPressed: () {
                // ação de salvar alterações
              },
            ),
          ),
        ],
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
