import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/navegation.dart';
import 'package:two/providers/profile_provider.dart';
import 'package:two/providers/ranking_provider.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: const Center(
                    child: Text(
                      'Ranking',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Card principal destacando o usuário
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Consumer<RankingProvider>(
                    builder: (context, rankingProvider, _) {
                      final ranking = rankingProvider?.ranking ?? [];
                      Widget rankingContainer({
                        required Widget child,
                      }) {
                        return Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.neutral,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withAlpha(100),
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
                                child,
                              ],
                            ),
                          ),
                        );
                      }

                      if (rankingProvider == null) {
                        return rankingContainer(
                          child: const Center(
                            child: Text('Ranking não disponível'),
                          ),
                        );
                      }
                      if (rankingProvider.loading == true) {
                        return rankingContainer(
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (rankingProvider.error != null) {
                        return rankingContainer(
                          child: Center(
                            child: Text(
                              'Erro ao buscar ranking: ${rankingProvider.error}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                      if (ranking.isEmpty) {
                        Future.microtask(() => rankingProvider.fetchRanking?.call());
                        return rankingContainer(
                          child: const Center(
                            child: Text('Ranking vazio'),
                          ),
                        );
                      }
                      // Encontrar o casal do usuário logado no ranking
                      int userIndex = -1;
                      Map? userRanking;
                      for (int i = 0; i < ranking.length; i++) {
                        final item = ranking[i];
                        if ((item['email'] != null && item['email'] == profileProvider.email) ||
                            (item['username'] != null && item['username'] == profileProvider.username)) {
                          userIndex = i;
                          userRanking = item;
                          break;
                        }
                      }
                      if (userRanking == null) {
                        return rankingContainer(
                          child: const Center(
                            child: Text(
                              'Você ainda não está no ranking',
                              style: TextStyle(
                                color: AppColors.titleSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }

                      final foto = userRanking['foto'] ?? userRanking['foto_perfil'] ?? '';
                      final nome = userRanking['nome'] ?? userRanking['nome_casal'] ?? 'Você';
                      final pontos = userRanking['pontos'] ?? userRanking['pontuacao'] ?? 0;
                      final posicao = userIndex + 1;

                      return rankingContainer(
                        child: Stack(
                          children: [
                            Positioned(
                              top: 15,
                              left: 20,
                              child: Text(
                                'Seu Ranking Atual',
                                style: TextStyle(
                                  color: AppColors.titleSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 65,
                              left: 13,
                              child: Text(
                                '#$posicao',
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
                                  CircleAvatar(
                                    radius: 27,
                                    backgroundImage: foto.isNotEmpty
                                        ? NetworkImage(foto)
                                        : const NetworkImage('https://i.pravatar.cc/300'),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nome,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.titleSecondary,
                                        ),
                                      ),
                                      const Text(
                                        'Você',
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
                                    '$pontos',
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
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Lista de ranking dinâmica
                Expanded(
                  child: Consumer<RankingProvider>(
                    builder: (context, rankingProvider, _) {
                      if (rankingProvider == null) {
                        return const Center(child: Text('Ranking não disponível'));
                      }
                      if (rankingProvider.loading == true) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (rankingProvider.error != null) {
                        return Center(child: Text('Erro: ${rankingProvider.error}'));
                      }
                      final ranking = rankingProvider.ranking ?? [];
                      if (ranking.isEmpty) {
                        Future.microtask(() => rankingProvider.fetchRanking?.call());
                        return const Center(child: Text('Nenhum casal no ranking.'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: ranking.length,
                        itemBuilder: (context, index) {
                          final item = ranking[index];
                          final nome = item['nome'] ?? item['nome_casal'] ?? 'Casal';
                          final pontos = item['pontos'] ?? item['pontuacao'] ?? 0;
                          final foto = item['foto'] ?? item['foto_perfil'] ?? '';
                          return _buildRankingItem(
                            position: index + 1,
                            name: nome,
                            points: pontos,
                            medal: index == 0
                                ? 'assets/images/moeda_ouro.svg'
                                : index == 1
                                    ? 'assets/images/moeda_prata.svg'
                                    : index == 2
                                        ? 'assets/images/moeda_bronze.svg'
                                        : null,
                            medalSize: 35,
                            imageUrl: foto,
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
          // Navegação inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingBottomNav(currentIndex: 1, onTap: (index) {}),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingItem({
    required int position,
    required String name,
    required int points,
    String? medal,
    double medalSize = 30,
    String? imageUrl,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                if (medal != null)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow.withAlpha(100),
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
                CircleAvatar(
                  radius: 24,
                  backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : const NetworkImage('https://i.pravatar.cc/300'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        'Casal',
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
          child: Divider(
            color: AppColors.secondary.withAlpha(100),
            thickness: 1,
          ),
        ),
        const SizedBox(height: 3),
      ],
    );
  }
}
