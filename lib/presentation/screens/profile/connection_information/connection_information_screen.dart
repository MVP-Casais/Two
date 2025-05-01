import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';

class ConnectionInformationScreen extends StatefulWidget {
  const ConnectionInformationScreen({super.key});

  @override
  State<ConnectionInformationScreen> createState() => _ConnectionInformationScreenState();
}

class _ConnectionInformationScreenState extends State<ConnectionInformationScreen> {
  bool _isBooleanOptionEnabled = false;

  void _mostrarParceiroConectado(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.background,
          child: SizedBox(
            width: screenWidth, 
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Parceiro Conectado',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titlePrimary,
                    ),
                  ),
                  const SizedBox(height: 26),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/300'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cirilo do Carrossel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titlePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '@ciliro',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondarylight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    backgroundColor: AppColors.primary,
                    text: 'Fechar',
                    textColor: AppColors.neutral,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.icons, size: 20,),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Informações da Conexão',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.titlePrimary,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenWidth * 0.1),
            _buildSectionTitle('Conexão'),
            GestureDetector(
              onTap: () {
                _mostrarParceiroConectado(context); // Abre o diálogo ao clicar
              },
              child: _buildTextWithButton(
                'Parceiro Conectado',
                'Conexão atual com: Cirilo do Carrossel (@ciliro)',
                onTap: () {
                  _mostrarParceiroConectado(context);
                },
              ),
            ),
            
            SizedBox(height: screenWidth * 0.01),
            _buildTextWithBooleanOption(
              'Compartilhar Planner',
              'Sincronize eventos, lembretes e compromissos no calendário do casal',
              value: _isBooleanOptionEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  _isBooleanOptionEnabled = newValue;
                });
              },
            ),
            SizedBox(height: screenWidth * 0.3),
            Center(
              child: GestureDetector(
                onTap: () {
                  // ação ao clicar em "Desconectar do Parceiro"
                },
                child: Text(
                  'Desconectar do Parceiro',
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondarylight,
      ),
    );
  }

  Widget _buildTextWithButton(String text, String subtext, {required VoidCallback onTap}) {

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.titlePrimary,
        ),
      ),
      subtitle: Text(
        subtext,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondarylight,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios, color: AppColors.icons, size: 18,),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildTextWithBooleanOption(String text, String subtext, {required bool value, required ValueChanged<bool> onChanged}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.titlePrimary,
        ),
      ),
      subtitle: Text(
        subtext,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondarylight,
        ),
      ),
      trailing: GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          width: screenWidth * 0.12,
          height: screenWidth * 0.06,
          decoration: BoxDecoration(
            color: value ? AppColors.primary : AppColors.placeholder,
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: value ? screenWidth * 0.07 : screenWidth * 0.01,
                top: screenWidth * 0.01,
                child: Container(
                  width: screenWidth * 0.04,
                  height: screenWidth * 0.04,
                  decoration: const BoxDecoration(
                    color: AppColors.neutral,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
