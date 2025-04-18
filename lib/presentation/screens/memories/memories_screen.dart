import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: SvgPicture.asset(
          'assets/images/TWO.svg',
          height: 25,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _HomeIconButton(
                    assetPath: 'assets/images/memoriasTraco.svg',
                  ),
                  _HomeIconButton(
                    assetPath: 'assets/images/atividades.svg',
                  ),
                  _HomeIconButton(
                    assetPath: 'assets/images/planner.svg',
                  ),
                  _HomeIconButton(
                    assetPath: 'assets/images/config.svg',
                  ),
                ],
              ),
            ),
            // Aqui você pode adicionar mais widgets para o corpo da tela
          ],
        ),
      ),
    );
  }
}

// Widget separado para reutilização e limpeza do código
class _HomeIconButton extends StatelessWidget {
  final String assetPath;

  const _HomeIconButton({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ação ao tocar
      },
      child: SvgPicture.asset(
        assetPath,
        height: 80,
      ),
    );
  }
}
