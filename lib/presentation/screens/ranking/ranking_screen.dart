import 'package:flutter/material.dart';
import 'package:two/presentation/widgets/navegation.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Aqui você pode adicionar o conteúdo principal da tela de atividades
          Center(child: Text("Ranking")),
          FloatingBottomNav(
            currentIndex: 1,
            onTap: (index) {
              
            },
          ),
        ],
      ),
    );
  }
}
