import 'package:flutter/material.dart';
import 'package:two/core/themes/app_colors.dart';

class WeeklyReport extends StatelessWidget {
  final Map<String, int> conexoesPorDia = {
    "Seg": 4,
    "Ter": 3,
    "Qua": 6,
    "Qui": 5,
    "Sex": 1,
    "Sáb": 10, // <- Maior conexão
    "Dom": 9,
  };

  // Mapa para converter dia abreviado -> nome completo
  final Map<String, String> diaCompleto = {
    "Seg": "Segunda-feira",
    "Ter": "Terça-feira",
    "Qua": "Quarta-feira",
    "Qui": "Quinta-feira",
    "Sex": "Sexta-feira",
    "Sáb": "Sábado",
    "Dom": "Domingo",
  };

  WeeklyReport({super.key});

  @override
  Widget build(BuildContext context) {
    final String maiorDiaAbreviado = conexoesPorDia.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final String maiorDiaCompleto = diaCompleto[maiorDiaAbreviado] ?? maiorDiaAbreviado;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            text: 'Maior Conexão: ',
            style: const TextStyle(fontSize: 16),
            children: [
              TextSpan(
                text: _capitalize(maiorDiaCompleto),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Gráfico com animação
        SizedBox(
          height: 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: conexoesPorDia.entries.map((entry) {
              final String dia = entry.key;
              final int valor = entry.value;
              final bool isMaior = dia == maiorDiaAbreviado;

              final double alturaMax = 100;
              final double alturaBarra = (valor / 10) * alturaMax;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Vela com animação
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: alturaBarra),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (context, animatedHeight, child) {
                      return Container(
                        width: 30,
                        height: animatedHeight,
                        decoration: BoxDecoration(
                          color: isMaior ? AppColors.primary : AppColors.terciary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  // Dia da semana
                  Text(
                    dia,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isMaior ? FontWeight.bold : FontWeight.normal,
                      color: isMaior ? AppColors.primary : AppColors.titleSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }
}
