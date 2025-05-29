import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';
import 'package:two/services/auth_service.dart';
import 'package:two/providers/register_provider.dart';

class UserComplete extends StatefulWidget {
  final VoidCallback onComplete;

  const UserComplete({super.key, required this.onComplete});

  @override
  State<UserComplete> createState() => _UserCompleteState();
}

class _UserCompleteState extends State<UserComplete> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    nameController.text = registerProvider.nome ?? '';
    usernameController.text = registerProvider.username ?? '';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.045,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Text(
            "Insira o seu nome",
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 16),
          CustomInput(
            controller: nameController,
            labelText: "Nome completo",
            onChanged: (value) => registerProvider.setNome(value),
          ),
          SizedBox(height: 20),
          Text(
            "Insira o seu username",
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 16),
          CustomInput(
            controller: usernameController,
            labelText: "Digite seu username",
            onChanged: (value) => registerProvider.setUsername(value),
          ),
          SizedBox(height: 20),
          Text(
            "Selecione seu gênero",
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedGender == "Masculino"
                        ? AppColors.primary
                        : AppColors.background,
                    side: BorderSide(
                      color: selectedGender == "Masculino"
                          ? AppColors.primary
                          : AppColors.inputBorder,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = "Masculino";
                      registerProvider.setGenero("Masculino");
                    });
                  },
                  child: Text(
                    "Masculino",
                    style: TextStyle(
                      color: selectedGender == "Masculino"
                          ? AppColors.neutral
                          : AppColors.titlePrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedGender == "Feminino"
                        ? AppColors.primary
                        : AppColors.background,
                    side: BorderSide(
                      color: selectedGender == "Feminino"
                          ? AppColors.primary
                          : AppColors.inputBorder,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = "Feminino";
                      registerProvider.setGenero("Feminino");
                    });
                  },
                  child: Text(
                    "Feminino",
                    style: TextStyle(
                      color: selectedGender == "Feminino"
                          ? AppColors.neutral
                          : AppColors.titlePrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedGender == "Outro"
                        ? AppColors.primary
                        : AppColors.background,
                    side: BorderSide(
                      color: selectedGender == "Outro"
                          ? AppColors.primary
                          : AppColors.inputBorder,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = "Outro";
                      registerProvider.setGenero("Outro");
                    });
                  },
                  child: Text(
                    "Outro",
                    style: TextStyle(
                      color: selectedGender == "Outro"
                          ? AppColors.neutral
                          : AppColors.titlePrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          CustomButton(
            text: "Cadastrar",
            onPressed: () async {
              registerProvider.setNome(nameController.text);
              registerProvider.setUsername(usernameController.text);
              registerProvider.setGenero(selectedGender ?? 'Outro');
              final result = await AuthService.register(
                nome: registerProvider.nome ?? '',
                username: registerProvider.username ?? '',
                email: registerProvider.email ?? '',
                senha: registerProvider.senha ?? '',
                genero: (registerProvider.genero != null && registerProvider.genero!.isNotEmpty)
                    ? registerProvider.genero!
                    : 'Outro',
              );
              if (!mounted) return;
              if (result['statusCode'] == 201) {
                registerProvider.reset();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result['body']['error'] ?? 'Erro ao registrar')),
                );
              }
            },
            backgroundColor: AppColors.primary,
            textColor: AppColors.neutral,
          ),
        ],
      ),
    );
  }
}
