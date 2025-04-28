import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/baseScreen/home/home_screen.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho padrão
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Icon(Icons.arrow_back_ios, size: 20),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Ranking',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Card principal destacando o usuário
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(60, 0, 0, 0),
                      blurRadius: 2,
                      offset: const Offset(1, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          'assets/images/fundo_ranking.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 20,
                        child: Text(
                          'Seu Ranking Atual',
                          style: TextStyle(
                            color: AppColors.titleSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 65,
                        left: 13,
                        child: Text(
                          '#5',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: AppColors.titleSecondary,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 55,
                        left: 50,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 27,
                              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Usuário 5',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.titleSecondary,
                                  ),
                                ),
                                Text(
                                  'Exemplo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: AppColors.titleSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 35,
                        right: 20,
                        child: Row(
                          children: [
                            Text(
                              '462',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleSecondary,
                              ),
                            ),
                            const SizedBox(width: 3),
                            SvgPicture.asset(
                              'assets/images/sinal_pontos_ranking.svg',
                              height: 12,
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Lista de ranking com separação rosa e moedas
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _buildRankingItem(position: 1, name: 'Usuário 1', points: 749, medal: 'assets/images/moeda_ouro.svg', medalSize: 35),
                  _buildRankingItem(position: 2, name: 'Usuário 2', points: 652, medal: 'assets/images/moeda_prata.svg', medalSize: 35),
                  _buildRankingItem(position: 3, name: 'Usuário 3', points: 576, medal: 'assets/images/moeda_bronze.svg', medalSize: 35),
                  _buildRankingItem(position: 4, name: 'Usuário 4', points: 494),
                  _buildRankingItem(position: 5, name: 'Usuário 5', points: 462),
                  _buildRankingItem(position: 6, name: 'Usuário 6', points: 311),
                ],
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingItem({
    required int position,
    required String name,
    required int points,
    String? medal,
    double medalSize = 30,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (medal != null)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(100, 0, 0, 0),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      medal,
                      height: medalSize,
                      width: medalSize,
                    ),
                  )
                else
                  Text(
                    '#$position',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleSecondary,
                    ),
                  ),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Exemplo',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color.fromRGBO(70, 70, 70, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '$points',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 3),
                    SvgPicture.asset(
                      'assets/images/sinal_pontos_ranking.svg',
                      height: 11,
                      width: 11,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: Color.fromARGB(255, 255, 149, 183), thickness: 1),
        ),
        const SizedBox(height: 3),
      ],
    );
  }
}
