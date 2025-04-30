import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';

class Atividade {
  final String titulo;
  final String descricao;
  final String duracao;
  final String intensidade;
  final List<String>? tags;

  Atividade({
    required this.titulo,
    required this.descricao,
    required this.duracao,
    required this.intensidade,
    required this.tags,
  });

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
      titulo: json['titulo'] ?? 'Sem título',
      descricao: json['descricao'] ?? '',
      duracao: json['duracao'] ?? '',
      intensidade: json['intensidade'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'descricao': descricao,
        'duracao': duracao,
        'intensidade': intensidade,
        'tags': tags ?? [],
      };
}

class AtividadePage extends StatefulWidget {
  final String categoria;

  const AtividadePage({super.key, required this.categoria});

  @override
  State<AtividadePage> createState() => _AtividadePageState();
}

class _AtividadePageState extends State<AtividadePage> {
  late Future<List<Atividade>> atividades;
  List<Atividade> salvos = [];

  Future<List<Atividade>> carregarAtividades() async {
    final String path = 'assets/data/${widget.categoria}.json';
    try {
      final String response = await rootBundle.loadString(path);
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Atividade.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Erro ao carregar atividades: $e');
      return [];
    }
  }

  Future<void> carregarSalvos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? salvosJson = prefs.getStringList(
      'salvos_${widget.categoria}',
    );
    if (salvosJson != null) {
      setState(() {
        salvos =
            salvosJson.map((e) => Atividade.fromJson(json.decode(e))).toList();
      });
    }
  }

  Future<void> salvarAtividade(Atividade atividade) async {
    final prefs = await SharedPreferences.getInstance();
    salvos.add(atividade);
    final jsonList = salvos.map((a) => json.encode(a.toJson())).toList();
    await prefs.setStringList('salvos_${widget.categoria}', jsonList);
    setState(() {});
  }

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
    atividades = carregarAtividades();
    carregarSalvos();
  }

  void mostrarCarta(Atividade atividade) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          child: FlipCard(
            front: Container(
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
              height: 450,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    atividade.titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Hora de aproveitar juntos!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.neutral,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(Icons.favorite, size: 80, color: AppColors.primary),
                  SizedBox(height: 30),
                  Text(
                    "Toque para virar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.neutral,
                    ),
                  ),
                ],
              ),
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
              height: 450,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      atividade.titulo,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titlePrimary,
                      ),
                    ),
                    SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: "Instrução: ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titlePrimary,
                        ),
                        children: [
                          TextSpan(
                            text: atividade.descricao,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: AppColors.titlePrimary,
                            ),
                          ),
                        ],
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
                    if (atividade.tags != null && atividade.tags!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Wrap(
                          spacing: 8,
                          children: atividade.tags!
                              .map((tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor: AppColors.inputBackground,
                                    labelStyle: TextStyle(
                                      color: AppColors.titlePrimary,
                                      fontSize: 14,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    SizedBox(height: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          onPressed: () => salvarAtividade(atividade),
                          icon: Icon(Icons.bookmark_add_outlined, color: AppColors.neutral, size: 20),
                          text: "Salvar",
                          backgroundColor: Colors.blue.shade600,
                          textColor: AppColors.neutral,
                        ),
                        SizedBox(height: 10),
                        CustomButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.check_circle_outline, color: AppColors.neutral, size: 20),
                          text: "Feito!",
                          backgroundColor: AppColors.indexCheck,
                          textColor: AppColors.neutral,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mostrarAleatoria(List<Atividade> lista) {
    final random = Random();
    final atividade = lista[random.nextInt(lista.length)];
    mostrarCarta(atividade);
  }

  void mostrarSalvos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Salvos"),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: salvos.length,
            itemBuilder: (context, index) {
              final item = salvos[index];
              return ListTile(
                title: Text(item.titulo),
                subtitle: Text(item.descricao),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Fechar"),
          ),
        ],
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
          icon: Icon(Icons.arrow_back_ios, size: screenHeight * 0.025, color: AppColors.titlePrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          titulosBonitos[widget.categoria] ?? 'Atividades',
          style: TextStyle(fontSize: screenHeight * 0.022, color: AppColors.titlePrimary, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, size: screenHeight * 0.025, color: AppColors.titlePrimary),
            onSelected: (value) async {
              final lista = await atividades;
              if (value == 'aleatoria') mostrarAleatoria(lista);
              if (value == 'salvos') mostrarSalvos();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.05),
                textStyle: TextStyle(
                  fontSize: screenHeight * 0.022,
                  color: AppColors.titlePrimary,
                  fontWeight: FontWeight.w500,
                ),
                value: 'aleatoria',
                child: Row(
                  children: [
                    Icon(Icons.shuffle, color: AppColors.icons, size: screenHeight * 0.025),
                    SizedBox(width: screenWidth * 0.03),
                    Text("Sugerir Atividade"),
                  ],
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.05),
                textStyle: TextStyle(
                  fontSize: screenHeight * 0.022,
                  color: AppColors.titlePrimary,
                  fontWeight: FontWeight.w500,
                ),
                value: 'salvos',
                child: Row(
                  children: [
                    Icon(Icons.bookmark, color: AppColors.icons, size: screenHeight * 0.025),
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
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.background
        ),
        child: FutureBuilder<List<Atividade>>(
          future: atividades,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar atividades.'));
            }

            final items = snapshot.data ?? [];

            if (items.isEmpty) {
              return Center(child: Text('Nenhuma atividade disponível.'));
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final atividade = items[index];
                return GestureDetector(
                  onTap: () => mostrarCarta(atividade),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01,
                    ),
                    padding: EdgeInsets.all(screenHeight * 0.02),
                    decoration: BoxDecoration(
                      color: AppColors.neutral,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderNavigation),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow.withAlpha(20),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: screenHeight * 0.14, // Altura mínima
                      maxHeight: screenHeight * 0.18, // Altura máxima para textos grandes
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          atividade.titulo,
                          style: TextStyle(
                            fontSize: screenHeight * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis, 
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Flexible(
                          child: Text(
                            atividade.descricao,
                            style: TextStyle(fontSize: screenHeight * 0.018),
                            maxLines: 3, 
                            overflow: TextOverflow.ellipsis, 
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
