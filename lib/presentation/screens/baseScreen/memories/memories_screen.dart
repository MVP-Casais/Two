import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              children: [
                MemoryCard(
                  title: 'Viagem ao Rio',
                  date: '12/08/2024',
                  description:
                      'Foi um dia inesquecível com muito sol e diversão!',
                  imagePath: 'assets/images/casal_Rio.svg',
                ),
                MemoryCard(
                  title: 'Aniversário da Ana',
                  date: '05/05/2023',
                  description:
                      'Festa surpresa cheia de alegria e boas risadas.',
                  imagePath: 'assets/images/aniversario.svg',
                ),
                MemoryCard(
                  title: 'Pôr do Sol',
                  date: '21/03/2023',
                  description: 'Momento de paz com um céu pintado de laranja.',
                  imagePath: 'assets/images/porDoSol.svg',
                ),
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MemoryCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String imagePath;

  const MemoryCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    const borderRadius = 24.0;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.025),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: screenHeight * 0.55,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withAlpha(20),
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Fundo com imagem
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/fundoMemorias.svg',
                  fit: BoxFit.cover,
                ),
              ),

              // Imagem do evento
              Positioned(
                top: screenHeight * 0.02,
                left: screenWidth * 0.03,
                right: screenWidth * 0.03,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: screenHeight * 0.30,
                      width: screenWidth * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(imagePath, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),

              // Textos
              Positioned(
                bottom: screenHeight * 0.05,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.titleSecondary,
                        fontSize: screenHeight * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      date,
                      style: TextStyle(
                        color: AppColors.titleSecondary,
                        fontSize: screenHeight * 0.016,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.titleSecondary,
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
