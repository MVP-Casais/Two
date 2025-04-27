import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                SizedBox(height: 80),
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
    const borderRadius = 24.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: 450,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withAlpha(20),
                blurRadius: 5,
                offset: Offset(100, 10),
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
                top: 16,
                left: 10,
                right: 10,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: 250,
                      width: 320,
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
                bottom: 40,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.titleSecondary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date,
                      style: TextStyle(
                        color: AppColors.titleSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.titleSecondary,
                        fontSize: 16,
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
