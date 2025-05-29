import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/providers/app_usage_provider.dart';

class WeeklyReport extends StatelessWidget {
  WeeklyReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppUsageProvider>(
      builder: (context, appUsageProvider, _) {
        // Agora conexoesPorDia representa minutos/tempo de uso por dia
        final Map<String, int> tempoPorDia = appUsageProvider.weeklyUsage;
        final String maiorDiaAbreviado = tempoPorDia.isNotEmpty
            ? tempoPorDia.entries.reduce((a, b) => a.value > b.value ? a : b).key
            : '';
        final Map<String, String> diaCompleto = {
          "Seg": "Segunda-feira",
          "Ter": "Terça-feira",
          "Qua": "Quarta-feira",
          "Qui": "Quinta-feira",
          "Sex": "Sexta-feira",
          "Sáb": "Sábado",
          "Dom": "Domingo",
        };
        final String maiorDiaCompleto = diaCompleto[maiorDiaAbreviado] ?? maiorDiaAbreviado;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (tempoPorDia.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text('Sem dados para exibir'),
              )
            else ...[
              Text.rich(
                TextSpan(
                  text: 'Maior tempo de uso: ',
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
              SizedBox(
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: tempoPorDia.entries.map((entry) {
                    final String dia = entry.key;
                    final int minutos = entry.value;
                    final bool isMaior = dia == maiorDiaAbreviado;

                    final double alturaMax = 100;
                    final int maiorValor = tempoPorDia.values.isEmpty ? 1 : tempoPorDia.values.reduce((a, b) => a > b ? a : b);
                    final double alturaBarra = maiorValor > 0 ? (minutos / maiorValor) * alturaMax : 0;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                        Text(
                          dia,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isMaior ? FontWeight.bold : FontWeight.normal,
                            color: isMaior ? AppColors.primary : AppColors.titleSecondary,
                          ),
                        ),
                        Text(
                          '$minutos min',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.titleSecondary,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  String _capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }
}
