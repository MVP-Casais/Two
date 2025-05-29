import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flip_card/flip_card.dart';
import 'package:provider/provider.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:two/providers/atividade_provider.dart' as prov;

class Atividade {
  final String id;
  final String titulo;
  final String descricao;
  final String duracao;
  final String intensidade;
  final List<String>? tags;
  bool isSalva;
  bool isFeita;

  Atividade({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.duracao,
    required this.intensidade,
    required this.tags,
    this.isSalva = false,
    this.isFeita = false,
  });

  factory Atividade.fromJson(Map<String, dynamic> json, {String? id}) {
    return Atividade(
      id: id ?? json['id'] ?? json['titulo'] ?? '',
      titulo: json['titulo'] ?? 'Sem título',
      descricao: json['descricao'] ?? '',
      duracao: json['duracao'] ?? '',
      intensidade: json['intensidade'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'descricao': descricao,
        'duracao': duracao,
        'intensidade': intensidade,
        'tags': tags ?? [],
        'isSalva': isSalva,
        'isFeita': isFeita,
      };
}

class AtividadePage extends StatefulWidget {
  final String categoria;

  const AtividadePage({super.key, required this.categoria});

  @override
  State<AtividadePage> createState() => _AtividadePageState();
}

class _AtividadePageState extends State<AtividadePage> {
  final Map<String, String> titulosBonitos = {
    'atividades_casa': 'Para Curtir em Casa',
    'atividades_externas': 'Explorando Juntos',
    'desafios_casa': 'Desafios em Casa',
    'desafios_externos': 'Missões Lá Fora',
    'perguntas_conexao': 'Conversas',
  };

  @override
  void initState() {
    super.initState();
    // Carrega as atividades do provider ao iniciar
    Future.microtask(() {
      Provider.of<prov.AtividadeProvider>(context, listen: false)
          .carregarAtividades(widget.categoria);
    });
  }

  void salvarAtividade(prov.Atividade atividade) {
    Provider.of<prov.AtividadeProvider>(context, listen: false)
        .salvarAtividade(widget.categoria, atividade);
    setState(() {});
  }

  void removerAtividade(prov.Atividade atividade) {
    Provider.of<prov.AtividadeProvider>(context, listen: false)
        .removerAtividade(widget.categoria, atividade);
    setState(() {});
  }

  void marcarComoFeito(prov.Atividade atividade) {
    Provider.of<prov.AtividadeProvider>(context, listen: false)
        .marcarComoFeita(widget.categoria, atividade);
    setState(() {});
  }

  void mostrarCarta(prov.Atividade atividade) {
    final height = MediaQuery.of(context).size.height * 0.6;
    final isSalvo = atividade.isSalva;
    final isFeito = atividade.isFeita;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          child: FlipCard(
            front: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.terciary,
                        AppColors.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(24),
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        atividade.titulo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Hora de aproveitar juntos!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral,
                        ),
                      ),
                      SizedBox(height: 20),
                      Icon(Icons.favorite, size: 100, color: AppColors.primary),
                      SizedBox(height: 30),
                      Text(
                        "Toque para virar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isFeito)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            "Concluído",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            back: Container(
              decoration: BoxDecoration(
                color: AppColors.neutral,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.titlePrimary,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(24),
              height: height,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            atividade.titulo,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titlePrimary,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            atividade.descricao,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.titlePrimary,
                            ),
                          ),
                          if (atividade.duracao.isNotEmpty) ...[
                            SizedBox(height: 16),
                            RichText(
                              text: TextSpan(
                                text: "Duração: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titlePrimary,
                                ),
                                children: [
                                  TextSpan(
                                    text: atividade.duracao,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.titlePrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (atividade.intensidade.isNotEmpty) ...[
                            SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                text: "Intensidade: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titlePrimary,
                                ),
                                children: [
                                  TextSpan(
                                    text: atividade.intensidade,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.titlePrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (atividade.tags != null &&
                              atividade.tags!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Wrap(
                                spacing: 8,
                                children: atividade.tags!
                                    .map((tag) => Chip(
                                          label: Text(tag),
                                          backgroundColor:
                                              AppColors.inputBackground,
                                          labelStyle: TextStyle(
                                            color: AppColors.titlePrimary,
                                            fontSize: 14,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        onPressed: () {
                          if (isSalvo) {
                            removerAtividade(atividade);
                          } else {
                            salvarAtividade(atividade);
                          }
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          isSalvo ? Icons.bookmark : Icons.bookmark_border,
                          color: AppColors.neutral,
                          size: 20,
                        ),
                        text: isSalvo ? "Remover dos Salvos" : "Salvar",
                        backgroundColor: Colors.blue.shade600,
                        textColor: AppColors.neutral,
                      ),
                      SizedBox(height: 8),
                      CustomButton(
                        onPressed: () {
                          if (!isFeito) {
                            marcarComoFeito(atividade);
                          }
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          isFeito
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: AppColors.neutral,
                          size: 20,
                        ),
                        text: isFeito ? "Concluído" : "Marcar como Concluído",
                        backgroundColor: AppColors.indexCheck,
                        textColor: AppColors.neutral,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void mostrarAleatoria(List<prov.Atividade> lista) {
    if (lista.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhuma atividade disponível para sugerir.')),
      );
      return;
    }
    final random = Random();
    final atividade = lista[random.nextInt(lista.length)];
    mostrarCarta(atividade);
  }

  void mostrarSalvos() {
    final salvosList =
        Provider.of<prov.AtividadeProvider>(context, listen: false)
            .getSalvas(widget.categoria);
    if (salvosList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhuma atividade salva.')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "Salvos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: salvosList.length,
                  itemBuilder: (context, index) {
                    final item = salvosList[index];
                    return GestureDetector(
                      onTap: () => mostrarCarta(item),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.neutral,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow.withAlpha(50),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.titulo,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titlePrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.descricao,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondarylight,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                removerAtividade(item);
                                Navigator.pop(context); // Fechar o diálogo
                                mostrarSalvos(); // Reabrir com a lista atualizada
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Fechar",
                backgroundColor: AppColors.primary,
                textColor: AppColors.neutral,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: screenHeight * 0.025, color: AppColors.titlePrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          titulosBonitos[widget.categoria] ?? 'Atividades',
          style: TextStyle(
              fontSize: screenHeight * 0.022,
              color: AppColors.titlePrimary,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu,
                size: screenHeight * 0.025, color: AppColors.titlePrimary),
            onSelected: (value) {
              final items =
                  Provider.of<prov.AtividadeProvider>(context, listen: false)
                      .getAtividades(widget.categoria);
              if (value == 'aleatoria') mostrarAleatoria(items);
              if (value == 'salvos') mostrarSalvos();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015,
                    horizontal: screenWidth * 0.05),
                textStyle: TextStyle(
                  fontSize: screenHeight * 0.022,
                  color: AppColors.titlePrimary,
                  fontWeight: FontWeight.w500,
                ),
                value: 'aleatoria',
                child: Row(
                  children: [
                    Icon(Icons.shuffle,
                        color: AppColors.icons, size: screenHeight * 0.025),
                    SizedBox(width: screenWidth * 0.03),
                    Text("Sugerir Atividade"),
                  ],
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015,
                    horizontal: screenWidth * 0.05),
                textStyle: TextStyle(
                  fontSize: screenHeight * 0.022,
                  color: AppColors.titlePrimary,
                  fontWeight: FontWeight.w500,
                ),
                value: 'salvos',
                child: Row(
                  children: [
                    Icon(Icons.bookmark,
                        color: AppColors.icons, size: screenHeight * 0.025),
                    SizedBox(width: screenWidth * 0.03),
                    Text("Ver Salvos"),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white,
            elevation: 8,
          ),
        ],
      ),
      body: Consumer<prov.AtividadeProvider>(
        builder: (context, atividadeProvider, _) {
          final items = atividadeProvider.getAtividades(widget.categoria);
          if (items.isEmpty) {
            return const Center(child: Text('Nenhuma atividade disponível.'));
          }
          return GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenHeight * 0.02,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: screenWidth * 0.02,
              mainAxisSpacing: screenHeight * 0.02,
              childAspectRatio: 0.7,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final atividade = items[index];
              final isFeito = atividade.isFeita;

              return GestureDetector(
                onTap: () => mostrarCarta(atividade),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.terciary,
                            AppColors.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    if (isFeito)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text(
                                "Concluído",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
