import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two/core/themes/app_colors.dart';

class HelpPageRegister extends StatefulWidget {
  const HelpPageRegister({super.key});

  @override
  State<HelpPageRegister> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPageRegister> {
  final List<bool> _expanded = [false, false, false, false, false]; 

  void _toggleExpansion(int index) {
    setState(() {
      _expanded[index] = !_expanded[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark, // ícones da status bar
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.icons,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Ajuda",
          style: TextStyle(
            color: AppColors.titlePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Precisa de ajuda para criar sua conta?",
              style: TextStyle(
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
                color: AppColors.titlePrimary,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Aqui estão algumas respostas para dúvidas comuns. Se precisar de mais ajuda, entre em contato com o suporte",
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: AppColors.textSecondarydark,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildExpandableField(
              index: 0,
              title: "Preciso usar um e-mail válido?",
              content:
                  "Sim! Usamos seu e-mail para verificar sua conta e recuperar senha caso necessário. É importante que você tenha acesso a ele.",
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildExpandableField(
              index: 1,
              title: "Posso usar um e-mail temporário?",
              content:
                  "Não. Apenas e-mails válidos são aceitos para garantir sua segurança e privacidade. E-mails temporários podem causar problemas de acesso no futuro.",
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildExpandableField(
              index: 2,
              title: "Quais são os requisitos para uma senha segura?",
              content: "Sua senha precisa ter:\n"
                  "- Pelo menos 8 caracteres,\n"
                  "- Pelo menos 1 letra maiúscula,\n"
                  "- Pelo menos 1 número,\n"
                  "- Pelo menos 1 caractere especial (!@#\$%)",
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildExpandableField(
              index: 3,
              title: "Posso mudar meu nome de usuário depois?",
              content:
                  "Sim, mas há um limite de vezes que você pode alterá-lo. Além disso, seu nome de usuário deve ser único e não pode conter caracteres especiais ou espaços.",
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildExpandableField(
              index: 4,
              title: "Meu nome de usuário está indisponível. O que fazer?",
              content:
                  "Tente variações, adicionando números ou caracteres especiais ou escolha um nome diferente. Lembre-se de que o nome de usuário deve ser único e não pode conter espaços.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableField({
    required int index,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => _toggleExpansion(index),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: AppColors.titlePrimary,
                  ),
                ),
              ),
              Icon(
                _expanded[index] ? Icons.expand_less : Icons.expand_more,
                color: AppColors.icons,
              ),
            ],
          ),
        ),
        if (_expanded[index])
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              content,
              style: const TextStyle(
                color: AppColors.textSecondarydark,
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }
}
