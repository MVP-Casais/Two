import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/baseScreen/activities/reproduction/reproduction_screen.dart';
import 'package:two/presentation/screens/ranking/ranking_screen.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RankingScreen(),
                  ),
                );
              },
              child: Container(
                height: screenHeight * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          'assets/images/memorias_fundo.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.02,
                        left: screenWidth * 0.05,
                        child: Text(
                          'Ótimo progresso!',
                          style: TextStyle(
                            color: AppColors.titleSecondary,
                            fontSize: screenHeight * 0.029,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.03,
                        right: screenWidth * 0.08,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.003,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.terciary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Top 5',
                                style: TextStyle(
                                  color: AppColors.titleSecondary,
                                  fontSize: screenHeight * 0.016,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.015),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: screenHeight * 0.02,
                              color: AppColors.icons,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.09,
                        left: screenWidth * 0.05,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.55,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Faltam 200 pontos para subir de nível!',
                                style: TextStyle(
                                  color: AppColors.titleTerciary,
                                  fontSize: screenHeight * 0.02,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: screenHeight * 0.015,
                        left: screenWidth * 0.05,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.55,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '+3 desafios concluídos esta semana!',
                                style: TextStyle(
                                  color: AppColors.titleTerciary,
                                  fontSize: screenHeight * 0.018,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Text(
              'Vamos nos conectar mais?',
              style: TextStyle(
                fontSize: screenHeight * 0.028,
                fontWeight: FontWeight.bold,
                color: AppColors.titlePrimary,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildActivityCard(
              color: AppColors.cardBackgroundBlue,
              title: 'Para Curtir em Casa',
              subtitle: 'Momentos especiais sem sair do lar',
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AtividadePage(categoria: 'atividades_casa'),
                  ),
                );
              },
            ),
            _buildActivityCard(
              color: AppColors.cardBackgroundGreen,
              title: 'Explorando Juntos',
              subtitle: 'Descubra novos lugares e experiências',
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AtividadePage(categoria: 'atividades_externas'),
                  ),
                );
              },
            ),
            _buildActivityCard(
              color: AppColors.cardBackgroundOrange,
              title: 'Desafios em Casa',
              subtitle: 'Teste sua criatividade e cumplicidade',
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AtividadePage(categoria: 'desafios_casa'),
                  ),
                );
              },
            ),
            _buildActivityCard(
              color: AppColors.cardBackgroundPurple,
              title: 'Missões Lá Fora',
              subtitle: 'Aventuras que fortalecem o vínculo',
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AtividadePage(categoria: 'desafios_externos'),
                  ),
                );
              },
            ),
            _buildActivityCard(
              color: AppColors.cardBackgroundYellow,
              title: 'Conversas que Conectam',
              subtitle: 'Descubra mais sobre o outro',
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AtividadePage(categoria: 'perguntas_conexao'),
                  ),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.08),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required Color color,
    required String title,
    required String subtitle,
    required double screenHeight,
    required double screenWidth,
    required Null Function() onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.02),
        padding: EdgeInsets.all(screenHeight * 0.02),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenHeight * 0.022,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titlePrimary,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: screenHeight * 0.018,
                      color: AppColors.titlePrimary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: screenHeight * 0.025,
              color: AppColors.titlePrimary,
            ),
          ],
        ),
      ),
    );
  }
}
