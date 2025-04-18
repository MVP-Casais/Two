import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/memories/memories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<DateTime> getCurrentWeekDates() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];
    final dates = getCurrentWeekDates();
    final today = DateTime.now();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            snap: false,
            expandedHeight: 60.0,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: SvgPicture.asset('assets/images/TWO.svg', height: 16),
            ),
            leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconWithLabel(
                      Icons.remove_red_eye_outlined,
                      "Memórias",
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemoriesScreen(),
                        ),
                      ),
                    ),
                    _buildIconWithLabel(
                      Icons.widgets_outlined,
                      "Atividades",
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemoriesScreen(),
                        ),
                      ),
                    ),
                    _buildIconWithLabel(
                      Icons.edit_calendar_rounded,
                      "Planner do Casal",
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemoriesScreen(),
                        ),
                      ),
                    ),
                    _buildIconWithLabel(
                      Icons.settings_outlined,
                      "Configurações",
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemoriesScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
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
                          Text(
                            'Sem eventos',
                            style: TextStyle(
                              color: AppColors.titleSecondary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(weekDays.length, (index) {
                              final date = dates[index];
                              final isToday =
                                  date.day == today.day &&
                                  date.month == today.month &&
                                  date.year == today.year;

                              return Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  decoration:
                                      isToday
                                          ? BoxDecoration(
                                            color: AppColors.neutral,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          )
                                          : null,
                                  child: Column(
                                    children: [
                                      Text(
                                        weekDays[index],
                                        style: TextStyle(
                                          color: AppColors.titleSecondary,
                                          fontWeight:
                                              isToday
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors.titleSecondary,
                                          fontWeight:
                                              isToday
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
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
              ),
              _buildSectionHeader("Recordações do Amor"),
              _buildBigContainer(),
              SizedBox(height: 20),
              _buildSectionHeader("Vamos nos conectar mais?"),
              _buildCarousel(),
            ]),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
    );
  }

  Widget _buildIconWithLabel(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.icons),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: AppColors.titlePrimary,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
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
          GestureDetector(
            onTap: () {},
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

  Widget _buildBigContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 380,
        width: double.infinity,
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
      ),
    );
  }

  Widget _buildCarousel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        height: 130,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.90),
          itemCount: 4,
          itemBuilder: (context, index) {
            final titles = [
              "Pergunta do dia",
              "Exemplo 1",
              "Dica da Semana",
              "Motivação",
            ];
            final subtitles = [
              "Descrição para o card 1",
              "Descrição para o card 1",
              "Aqui vai uma dica interessante!",
              "Se inspire para começar o dia!",
            ];

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
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titles[index],
                          style: TextStyle(
                            color: AppColors.titleSecondary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          subtitles[index],
                          style: TextStyle(
                            color: AppColors.titleSecondary,
                            fontSize: 15,
                          ),
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
    );
  }
}
