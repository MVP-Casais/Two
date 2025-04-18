import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:two/core/themes/app_colors.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: SvgPicture.asset(
          'assets/images/TWO.svg',
          height: 25,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0, 
      ),
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/images/memorias.svg', height: 80),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/images/atividades.svg', height: 80),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/images/planner.svg', height: 80),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/images/config.svg', height: 80),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
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
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sem eventos',
                          style: TextStyle(
                            color: Colors.brown[800],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(weekDays.length, (index) {
                            final date = dates[index];
                            final isToday = date.day == today.day &&
                                date.month == today.month &&
                                date.year == today.year;

                            return Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                decoration: isToday
                                    ? BoxDecoration(
                                        color: Colors.pink.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : null,
                                child: Column(
                                  children: [
                                    Text(
                                      weekDays[index],
                                      style: TextStyle(
                                        color: isToday ? Colors.brown[800] : Colors.brown[800],
                                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${date.day}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: isToday ? Colors.black87 : Colors.white,
                                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
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
           
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30), 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline, 
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Text(
                  "Recordações do Amor",
                  style: TextStyle(
                    color: AppColors.titlePrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Ver todos",
                  style: TextStyle(
                    color: AppColors.titlePrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 380,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
    


              ),
            ),

            Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20), 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline, 
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Text(
                  "Vamos nos conectar mais?",
                  style: TextStyle(
                    color: AppColors.titlePrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Ver todos",
                  style: TextStyle(
                    color: AppColors.titlePrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
         
    Padding(
  padding: EdgeInsets.symmetric(horizontal: 0), // Margem externa do carrossel
  child: Container(
    height: 130, // Altura do carrossel
    child: PageView.builder(
      controller: PageController(viewportFraction: 0.9), // Define quanto espaço cada card ocupa
      itemCount: 4, // Número de cards no carrossel
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8), // Espaçamento interno entre os cards
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: SvgPicture.asset(
                  'assets/images/fundo_carrosel.svg',
                  fit: BoxFit.cover,
                  width: double.infinity, // Garante que o card preencha toda a largura alocada
                ),
              ),
              Positioned(
                bottom: 40, // Posiciona os textos na parte inferior
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Títulos dinâmicos para cada card
                      index == 0
                          ? "Pergunta do dia"
                          : index == 1
                              ? "Exemplo 1"
                              : index == 2
                                  ? "Dica da Semana"
                                  : "Motivação",
                      style: TextStyle(
                        color: AppColors.titleSecondary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      // Descrições dinâmicas para cada card
                      index == 0
                          ? "Descrição para o card 1"
                          : index == 1
                              ? "Descrição para o card 1"
                              : index == 2
                                  ? "Aqui vai uma dica interessante!"
                                  : "Se inspire para começar o dia!",
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
),



   

          ],
        ),
      ),
      backgroundColor: AppColors.neutral,
    );
  }
}
