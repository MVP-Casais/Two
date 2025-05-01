import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/presentation/widgets/custom_input.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
            'Informações Pessoais',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
          ),
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: screenWidth * 0.1),
                      CircleAvatar(
                        radius: screenWidth * 0.15,
                        backgroundImage: const NetworkImage(
                          'https://i.pravatar.cc/300',
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.05),
                      GestureDetector(
                        onTap: () {
                        },
                        child: Text(
                          'Editar Perfil',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.titlePrimary,
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.1),
                      _buildInputField('Nome', 'Digite seu nome'),
                      SizedBox(height: screenWidth * 0.05),
                      _buildInputField(
                        'Nome de Usuário',
                        'Digite seu nome de usuário',
                      ),
                      SizedBox(height: screenWidth * 0.05),
                      _buildGenderDropdown(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: CustomButton(
                backgroundColor: AppColors.primary,
                text: 'Salvar',
                textColor: AppColors.neutral,
                onPressed: () {
                  // ação de salvar
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.titlePrimary,
          ),
        ),
        const SizedBox(height: 8),
        CustomInput(labelText: label),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    final List<String> genders = ['Masculino', 'Feminino', 'Outro'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gênero',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.titlePrimary,
          ),
        ),
        const SizedBox(height: 8),
        CustomInput(
          labelText: 'Gênero',
          isDropdown: true,
          dropdownItems: genders.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(
                gender,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            // ação ao selecionar um gênero
          },
        ),
      ],
    );
  }
}
