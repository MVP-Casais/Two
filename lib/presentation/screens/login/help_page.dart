import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two/core/themes/app_colors.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<bool> _expanded = [false, false, false, false];

  void _toggleExpansion(int index) {
    setState(() {
      _expanded[index] = !_expanded[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Controla a cor da status bar (topo do Android/iOS)
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
              "Como podemos ajudar?",
              style: TextStyle(
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
                color: AppColors.titlePrimary,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Aqui estão algumas soluções para os problemas mais comuns.",
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: AppColors.textSecondarydark,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildExpandableField(
              index: 0,
              title: "Esqueci minha senha. Como redefinir?",
              content:
                  "Para redefinir sua senha, clique em 'Esqueci minha senha' na tela de login e siga as instruções enviadas para o seu e-mail.",
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildExpandableField(
              index: 1,
              title: "Meu e-mail/senha está incorreto, o que fazer?",
              content:
                  "Verifique se digitou corretamente e tente novamente. Se o problema continuar, redefina sua senha.",
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildExpandableField(
              index: 2,
              title: "Quero entrar com o Google, mas não funciona",
              content:
                  "Certifique-se de que sua conta Google está conectada no dispositivo e tente novamente. Se o problema persistir, verifique as permissões do aplicativo nas configurações do dispositivo.",
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildExpandableField(
              index: 3,
              title: "Não recebi o e-mail de redefinição de senha",
              content:
                  "Espere alguns minutos e cheque sua caixa de spam. Se ainda não chegou, solicite novamente a redefinição de senha.",
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
