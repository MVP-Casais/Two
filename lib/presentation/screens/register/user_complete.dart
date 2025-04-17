import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';

class UserComplete extends StatefulWidget {
  final VoidCallback onComplete;

  const UserComplete({super.key, required this.onComplete});

  @override
  State<UserComplete> createState() => _UserCompleteState();
}

class _UserCompleteState extends State<UserComplete> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Nome completo",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: "Digite seu username",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
                    backgroundColor:
                        selectedGender == "Masculino"
                            ? AppColors.primary
                            : AppColors.background,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = "Masculino";
                    });
                  },
                  child: Text(
                    "Masculino",
                    style: TextStyle(
                      color:
                          selectedGender == "Masculino"
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
                    backgroundColor:
                        selectedGender == "Feminino"
                            ? AppColors.primary
                            : AppColors.background,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = "Feminino";
                    });
                  },
                  child: Text(
                    "Feminino",
                    style: TextStyle(
                      color:
                          selectedGender == "Feminino"
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
                    backgroundColor:
                        selectedGender == "Outro"
                            ? AppColors.primary
                            : AppColors.background,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = "Outro";
                    });
                  },
                  child: Text(
                    "Outro",
                    style: TextStyle(
                      color:
                          selectedGender == "Outro"
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
            text: "Concluir",
            onPressed: widget.onComplete,
            backgroundColor: AppColors.primary,
            textColor: AppColors.neutral,
          ),
        ],
      ),
    );
  }
}
