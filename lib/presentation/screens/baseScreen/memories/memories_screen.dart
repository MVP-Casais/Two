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
                  description: 'Foi um dia inesquecível com muito sol e diversão!',
                  imagePath: 'assets/images/casal_Rio.svg',
                ),
                MemoryCard(
                  title: 'Aniversário da Ana',
                  date: '05/05/2023',
                  description: 'Festa surpresa cheia de alegria e boas risadas.',
                  imagePath: 'assets/images/aniversario.svg',
                ),
                MemoryCard(
                  title: 'Pôr do Sol',
                  date: '21/03/2023',
                  description: 'Momento de paz com um céu pintado de laranja.',
                  imagePath: 'assets/images/porDoSol.svg',
                ),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
        height: 450, 
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(90),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/fundoMemorias.svg',
                  fit: BoxFit.cover,
                ),
              ),

              // 📸 **Imagem interna com sombra**
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
                          color: Color(0x4D000000), 
                          blurRadius: 2,
                          offset: Offset(4, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        height: 250,
                        width: 320,
                        child: SvgPicture.asset(imagePath, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),

              // 📝 **Texto da memória**
              Positioned(
                bottom: 40, 
                left: 20, 
                right: 20, 
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.titleSecondary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5), 
                      Text(
                        date,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 65, 19, 19),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 5), 
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
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