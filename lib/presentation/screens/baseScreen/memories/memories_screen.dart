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
          _buildMemoryContainer(imageWidth: 320), 
        ],
      ),
    );
  }

  Widget _buildMemoryContainer({required double imageWidth}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 450, 
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(90), // 🔼 Sombra mais escura para maior destaque
              blurRadius: 4, 
              offset: Offset(0, 4), 
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30), 
          child: Stack(
            clipBehavior: Clip.antiAlias, 
            children: [
              // 🔼 **Imagem de fundo com bordas corrigidas e sombra sutil**
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25), 
                  child: SvgPicture.asset(
                    'assets/images/fundoMemorias.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // 🖼 **Imagem interna com sombra mais escura**
              Positioned(
                top: 16, 
                left: 10, 
                right: 10, 
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18), 
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(160), // 🔼 Agora a sombra está mais intensa!
                          blurRadius: 4, // 🔼 Mantendo suavidade sem espalhar demais
                          offset: Offset(0, 4), // 🔼 Reforçando efeito elevado
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18), 
                      child: SizedBox(
                        height: 250,
                        width: imageWidth, 
                        child: SvgPicture.asset(
                          'assets/images/casalMaos.svg',
                          fit: BoxFit.cover, 
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // ✍ **Texto ajustado para melhor alinhamento**
              Positioned(
                bottom: 19, 
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    'Um símbolo eterno de amor e compromisso.', 
                    style: TextStyle(
                      color: AppColors.titleSecondary,
                      fontSize: 35, 
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