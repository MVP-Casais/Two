import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 200,
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
                        top: 18,
                        left: 20,
                        child: Text(
                          'Ótimo progresso!',
                          style: TextStyle(
                            color: AppColors.titleSecondary,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 23,
                        right: 30,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.terciary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Top 5',
                                style: TextStyle(
                                  color: AppColors.titleSecondary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppColors.icons,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 70,
                        left: 20,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 220),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Faltam 200 pontos para subir de nível!',
                                style: TextStyle(
                                  color: AppColors.titleTerciary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 20,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 220),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '+3 desafios concluídos esta semana!',
                                style: TextStyle(
                                  color: AppColors.titleTerciary,
                                  fontSize: 14,
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

            SizedBox(height: 30),

            Text(
              'Vamos nos conectar mais?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.titlePrimary,
              ),
            ),

            SizedBox(height: 20),

            _buildActivityCard(
              color: Colors.blue.shade200,
              title: 'Para Curtir em Casa',
              subtitle: 'Momentos especiais sem sair do lar',
            ),
            _buildActivityCard(
              color: Colors.green.shade200,
              title: 'Explorando Juntos',
              subtitle: 'Descubra novos lugares e experiências',
            ),
            _buildActivityCard(
              color: Colors.orange.shade200,
              title: 'Desafios em Casa',
              subtitle: 'Teste sua criatividade e cumplicidade',
            ),
            _buildActivityCard(
              color: Colors.purple.shade200,
              title: 'Missões Lá Fora',
              subtitle: 'Aventuras que fortalecem o vínculo',
            ),
            _buildActivityCard(
              color: Colors.yellow.shade200,
              title: 'Conversas que Conectam',
              subtitle: 'Descubra mais sobre o outro',
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titlePrimary,
                    ),
                  ),

                  SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.titlePrimary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: AppColors.titlePrimary,
            ),
          ],
        ),
      ),
    );
  }
}
