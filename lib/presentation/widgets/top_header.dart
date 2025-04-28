import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two/core/themes/app_colors.dart';

class TopHeader extends StatelessWidget {
  final bool useSliver;
  final VoidCallback? onAddEvent; // Adiciona o callback para o botão de adicionar

  const TopHeader({
    super.key,
    this.useSliver = false,
    this.onAddEvent, // Inicializa o callback
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        SvgPicture.asset('assets/images/TWO.svg', height: 24),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onAddEvent, // Chama o callback ao pressionar o botão
        ),
      ],
    );

    if (useSliver) {
      return SliverAppBar(
        floating: false,
        snap: false,
        expandedHeight: 60.0,
        backgroundColor: AppColors.background,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 70, left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
              SvgPicture.asset('assets/images/TWO.svg', height: 24),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onAddEvent, // Chama o callback ao pressionar o botão
              ),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 5, right: 5),
          child: content,
        ),
      );
    }
  }
}
