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
          SizedBox(height: 20), 
          _buildMemoryContainer(imageWidth: 320), // 🔼 Defina a largura manualmente
        ],
      ),
    );
  }

  Widget _buildMemoryContainer({required double imageWidth}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), 
        child: Container(
          height: 450, 
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
          ),
          child: Stack(
            clipBehavior: Clip.antiAlias, 
            children: [
              // 🔼 **Imagem de fundo com bordas corretas**
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30), 
                  child: SvgPicture.asset(
                    'assets/images/fundoMemorias.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // 🖼 **Imagem interna com bordas corretas e largura ajustável**
              Positioned(
                top: 40, 
                left: 10, // 🔼 Pequeno espaçamento para evitar corte brusco
                right: 10, 
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13), // 🔼 Garantindo bordas arredondadas
                    child: SizedBox(
                      height: 250,
                      width: imageWidth, // 🔼 Agora você pode definir a largura manualmente!
                      child: SvgPicture.asset(
                        'assets/images/casalMaos.svg',
                        fit: BoxFit.cover, // 🔼 Expandindo sem cortar ou distorcer
                      ),
                    ),
                  ),
                ),
              ),
              
              // ✍ **Texto ajustado para melhor alinhamento**
              Positioned(
                bottom: 25, 
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Um símbolo eterno de amor e compromisso.', 
                    style: TextStyle(
                      color: AppColors.titleSecondary,
                      fontSize: 26, 
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