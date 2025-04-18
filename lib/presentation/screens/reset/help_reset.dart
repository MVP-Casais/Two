import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/pre_login/pre_login.dart';

class HelpPageReset extends StatefulWidget {
  const HelpPageReset({super.key});

  @override
  State<HelpPageReset> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPageReset> {
  final List<bool> _expanded = [false, false, false, false];

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
        statusBarIconBrightness: Brightness.dark,
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
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Esqueceu sua senha?",
                  style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Não se preocupe! Vamos te ajudar a redefinir sua senha de forma rápida e segura para que você possa acessar sua conta novamente.",
                  style: TextStyle(
                    fontSize: screenHeight * 0.018,
                    color: AppColors.textSecondarydark,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildExpandableField(
                  index: 0,
                  title: "Campo de Entrada para E-mail",
                  content:
                      "Insira seu e-mail cadastrado e espere o código de confirmação chegar.",
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildExpandableField(
                  index: 1,
                  title: "Verifique sua caixa de entrada",
                  content:
                      "Enviamos um link para redefinir sua senha. Se não encontrar, verifique a pasta de spam ou lixo eletrônico.",
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildExpandableField(
                  index: 2,
                  title: "Não recebi o código de verificação. E agora?",
                  content:
                      "Verifique se o e-mail está correto e olhe na pasta de spam ou lixo eletrônico. Ainda com problemas? Aguarde alguns minutos e clique em “Reenviar código”. Se continuar sem receber, fale com o suporte.",
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildExpandableField(
                  index: 3,
                  title: "Minha conta foi comprometida. O que fazer?",
                  content:
                      "Troque sua senha imediatamente. Se você ainda tem acesso ao e-mail da conta, use a opção de redefinição de senha. Caso alguém tenha alterado o e-mail, entre em contato com nosso suporte para recuperar sua conta o quanto antes.",
                ),
                SizedBox(height: screenHeight * 0.05),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PreLoginPage()),
                    );
                  },
                  child: Text(
                    "Lembrou a senha? Faça login",
                    style: TextStyle(
                      color: AppColors.titlePrimary,
                      fontSize: screenHeight * 0.017,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
