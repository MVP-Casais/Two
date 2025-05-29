import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/baseScreen/base_screen.dart';
import 'package:two/presentation/widgets/graph.dart';
import 'package:two/presentation/widgets/navegation.dart';
import 'package:two/presentation/widgets/top_header.dart';
import 'package:two/presentation/widgets/top_menu.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:two/providers/planner_provider.dart';
import 'package:two/providers/memories_provider.dart';
import 'package:two/providers/connection_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<DateTime> getCurrentWeekDates() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);
    final memoriesProvider =
        Provider.of<MemoriesProvider>(context, listen: false);
    final plannerProvider =
        Provider.of<PlannerProvider>(context, listen: false);

    // Garante que a conexão, memórias e eventos são restaurados logo ao entrar na home
    Future.microtask(() async {
      await connectionProvider.restoreConnection();
      await memoriesProvider.fetchMemories();
      await plannerProvider.fetchEvents();
    });

    final weekDays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];
    final dates = getCurrentWeekDates();
    final today = DateTime.now();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const TopHeader(useSliver: true, showAddIcon: false),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 10),
                  TopMenu(navigateToBaseScreen: true),
                  SizedBox(height: 10),
                  // Mini calendário com contador de eventos do dia
                  Consumer<PlannerProvider>(
                    builder: (context, plannerProvider, _) {
                      // Atualiza sempre que eventos mudam
                      final todayKey =
                          DateTime(today.year, today.month, today.day);
                      final eventsToday =
                          plannerProvider.eventsByDate[todayKey] ?? [];
                      final count = eventsToday.length;
                      return Container(
                        margin: EdgeInsets.all(20),
                        height: 130,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: SvgPicture.asset(
                                  'assets/images/calendario.svg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Mostra a quantidade de eventos de hoje
                                  Text(
                                    count == 0
                                        ? 'Sem eventos'
                                        : '$count evento${count > 1 ? "s" : ""} hoje',
                                    style: TextStyle(
                                      color: AppColors.titleSecondary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(weekDays.length, (
                                      index,
                                    ) {
                                      final date = dates[index];
                                      final isToday = date.day == today.day &&
                                          date.month == today.month &&
                                          date.year == today.year;

                                      return Flexible(
                                        child: Container(
                                          width: isToday ? 50 : 40,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          decoration: isToday
                                              ? BoxDecoration(
                                                  color: AppColors.neutral,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )
                                              : null,
                                          child: Column(
                                            children: [
                                              Text(
                                                weekDays[index],
                                                style: TextStyle(
                                                  color:
                                                      AppColors.titleSecondary,
                                                  fontWeight: isToday
                                                      ? FontWeight.bold
                                                      : FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text(
                                                    '${date.day}',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors
                                                          .titleSecondary,
                                                      fontWeight: isToday
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  _buildSectionHeader(
                    context,
                    "Recordações do Amor",
                    onButtonTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BaseScreen(initialPage: 0)),
                      );
                    },
                  ),
                  _buildMemoriesCarousel(context),
                  SizedBox(height: 20),
                  _buildSectionHeader(
                    context,
                    "Vamos nos conectar mais?",
                    onButtonTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BaseScreen(initialPage: 1)),
                      );
                    },
                  ),
                  _buildCarousel(),
                  _buildSectionHeader(
                    context,
                    "Relatório Semanal",
                    showButton: false,
                  ),
                  WeeklyReport(),
                  SizedBox(height: 120),
                ]),
              ),
            ],
          ),
          Positioned(
            child: FloatingBottomNav(currentIndex: 0, onTap: (index) {}),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      {bool showButton = true, VoidCallback? onButtonTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.titlePrimary,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (showButton)
            GestureDetector(
              onTap: onButtonTap,
              child: Text(
                "Ver todos",
                style: TextStyle(
                  color: AppColors.titlePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    final PageController pageController = PageController(
      viewportFraction: 0.95,
    );

    int currentIndex = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        Future<List<Map<String, String>>> loadActivitiesForToday() async {
          final List<String> jsonFiles = [
            'assets/data/perguntas_conexao.json',
            'assets/data/desafios_casa.json',
            'assets/data/atividades_casa.json',
            'assets/data/desafios_externos.json',
          ];

          final List<Map<String, String>> activities = [];
          for (final file in jsonFiles) {
            final String jsonString = await rootBundle.loadString(file);
            final List<dynamic> fileActivities = json.decode(jsonString);
            final int activityIndex =
                DateTime.now().day % fileActivities.length;
            final Map<String, dynamic> activity = fileActivities[activityIndex];
            activities.add({
              "title": file.contains("perguntas") ? "Pergunta" : "Desafio",
              "description": activity["descricao"],
            });
          }
          return activities;
        }

        return FutureBuilder<List<Map<String, String>>>(
          future: loadActivitiesForToday(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final activities = snapshot.data!;
            return Column(
              children: [
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: activities.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index; // <- Atualiza corretamente agora
                      });
                    },
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: SvgPicture.asset(
                                'assets/images/fundo_carrosel.svg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 30,
                              left: 16,
                              right: 16,
                              child: Text(
                                activity["title"]!,
                                style: TextStyle(
                                  color: AppColors.titleSecondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Positioned(
                              bottom: 40,
                              left: 16,
                              right: 16,
                              child: Text(
                                activity["description"]!,
                                style: TextStyle(
                                  color: AppColors.titleSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(activities.length, (index) {
                    final isActive = index == currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.terciary : AppColors.icons,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMemoriesCarousel(BuildContext context) {
    return Consumer<MemoriesProvider>(
      builder: (context, memoriesProvider, _) {
        final memories = memoriesProvider.memories;
        if (memories.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Container(
              height: 320,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withAlpha((0.2 * 255).toInt()),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Adicione suas memórias para vê-las aqui!",
                  style: TextStyle(
                    color: AppColors.titlePrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        // Pega até 3 memórias aleatórias
        final random = memories.length <= 3
            ? List.of(memories)
            : (memories.toList()..shuffle()).take(3).toList();

        final PageController pageController =
            PageController(viewportFraction: 0.95);

        return SizedBox(
          child: SizedBox(
            height: 320,
            child: PageView.builder(
              controller: pageController,
              itemCount: random.length,
              itemBuilder: (context, index) {
                final memory = random[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: memory.imageUrl.isNotEmpty
                            ? Image.network(
                                memory.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stack) =>
                                    Container(
                                  color: AppColors.neutral,
                                  child: const Center(
                                      child:
                                          Icon(Icons.broken_image, size: 40)),
                                ),
                              )
                            : Container(
                                color: AppColors.neutral,
                                child: const Center(
                                    child: Icon(Icons.broken_image, size: 40)),
                              ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            memory.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
