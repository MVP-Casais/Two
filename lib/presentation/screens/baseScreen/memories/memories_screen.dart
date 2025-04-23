import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(height: 20), // 🔼 Espaço para elevar o layout mais perto do topo
          _buildMemoryContainer(),
        ],
      ),
    );
  }

  Widget _buildMemoryContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // Mantendo bordas arredondadas
        child: Container(
          height: 350, // 🔼 Ajustando altura para subir o contêiner
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
          ),
          child: Stack(
            children: [
              // 🔼 **Subindo a imagem de fundo**
              Positioned(
                top: -30, // 🔼 Movendo o fundo para cima
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/images/fundoMemorias.svg', // Caminho correto do fundo
                  fit: BoxFit.cover,
                ),
              ),
              // 🖼 **Imagem das mãos - agora bem centralizada**
              Positioned(
                top: 50, // 🔼 Ajustando altura correta
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    height: 200, // 🔼 Mantendo proporção correta
                    width: 200,
                    child: SvgPicture.asset(
                      'assets/images/maosDadasCasal.svg', // Caminho correto da imagem interna
                      fit: BoxFit.contain, // Garantindo encaixe correto
                    ),
                  ),
                ),
              ),
              // ✍ **Texto ajustado para melhor alinhamento**
              Positioned(
                bottom: 30, // 🔼 Subindo o texto um pouco mais
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Um símbolo eterno de amor e compromisso.', // Texto ajustável
                    style: TextStyle(
                      color: AppColors.titleSecondary,
                      fontSize: 24, // 🔼 Ajuste da fonte para melhor encaixe
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
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