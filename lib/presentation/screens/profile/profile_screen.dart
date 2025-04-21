import 'package:flutter/material.dart';
import 'package:two/presentation/widgets/navegation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Aqui você pode adicionar o conteúdo principal da tela de atividades
          Center(child: Text("Perfil")),
          FloatingBottomNav(
            currentIndex: 2, // Atualize conforme necessário
            onTap: (index) {
              
            },
          ),
        ],
      ),
    );
  }
}
