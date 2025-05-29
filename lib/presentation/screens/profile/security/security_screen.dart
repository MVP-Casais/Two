import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';
import 'package:two/providers/change_password_provider.dart';
import 'package:two/services/delete_account_service.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isDeletingAccount = false;

  Future<void> _saveChanges() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    final changePasswordProvider = Provider.of<ChangePasswordProvider>(context, listen: false);
    final success = await changePasswordProvider.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso!')),
      );
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(changePasswordProvider.errorMessage ?? 'Erro ao alterar senha.')),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final TextEditingController passwordController = TextEditingController();

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        bool isDeletePasswordVisible = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              title: const Text('Confirmar Exclusão', style: TextStyle(color: AppColors.titlePrimary, fontWeight: FontWeight.w500)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Digite sua senha para confirmar a exclusão da conta.'),
                  const SizedBox(height: 10),
                  CustomInput(
                    controller: passwordController,
                    labelText: 'Senha Atual',
                    obscureText: !isDeletePasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isDeletePasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.icons,
                      ),
                      onPressed: () {
                        setState(() {
                          isDeletePasswordVisible = !isDeletePasswordVisible;
                        });
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                CustomButton(
                  text: "Excluir",
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.neutral,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "Cancelar",
                  backgroundColor: AppColors.inputBackground,
                  textColor: AppColors.titlePrimary,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (confirm == true) {
      final password = passwordController.text.trim();
      if (password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A senha é obrigatória para excluir a conta.')),
        );
        return;
      }

      setState(() {
        _isDeletingAccount = true;
      });

      try {
        final success = await DeleteAccountService.deleteAccount(password: password);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Conta excluída com sucesso.')),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/pre-login', (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao excluir a conta. Verifique sua senha.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir a conta: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isDeletingAccount = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final changePasswordProvider = Provider.of<ChangePasswordProvider>(context);

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
                  currentPasswordController,
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
                  newPasswordController,
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
                  confirmPasswordController,
                  _isConfirmPasswordVisible,
                  () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                SizedBox(height: screenWidth * 0.3),
                GestureDetector(
                  onTap: _isDeletingAccount ? null : _deleteAccount,
                  child: Center(
                    child: _isDeletingAccount
                        ? const CircularProgressIndicator()
                        : Text(
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
              text: changePasswordProvider.status == ChangePasswordStatus.loading
                  ? 'Salvando...'
                  : 'Salvar Alterações',
              textColor: AppColors.neutral,
              onPressed: changePasswordProvider.status == ChangePasswordStatus.loading
                  ? null
                  : _saveChanges,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputWithTitle(
    String title,
    String label,
    TextEditingController controller,
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
          controller: controller,
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
