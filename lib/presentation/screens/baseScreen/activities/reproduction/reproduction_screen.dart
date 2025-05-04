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
  final Set<String> atividadesFeitas = {};

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
    if (!salvos.contains(atividade)) {
      salvos.add(atividade);
      final jsonList = salvos.map((a) => json.encode(a.toJson())).toList();
      await prefs.setStringList('salvos_${widget.categoria}', jsonList);
      setState(() {});
    }
  }

  Future<void> removerAtividade(Atividade atividade) async {
    final prefs = await SharedPreferences.getInstance();
    salvos.removeWhere((item) => item.titulo == atividade.titulo);
    final jsonList = salvos.map((a) => json.encode(a.toJson())).toList();
    await prefs.setStringList('salvos_${widget.categoria}', jsonList);
    setState(() {});
  }

  void marcarComoFeito(Atividade atividade) {
    setState(() {
      atividadesFeitas.add(atividade.titulo);
    });
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
    final height = MediaQuery.of(context).size.height * 0.6;
    final isSalvo = salvos.any((item) => item.titulo == atividade.titulo);
    final isFeito = atividadesFeitas.contains(atividade.titulo);

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
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        onPressed: () async {
                          if (isSalvo) {
                            await removerAtividade(atividade);
                          } else {
                            await salvarAtividade(atividade);
                          }
                          setState(() {});
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
                          setState(() {});
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

  void mostrarAleatoria(List<Atividade> lista) {
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
    if (salvos.isEmpty) {
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
                  itemCount: salvos.length,
                  itemBuilder: (context, index) {
                    final item = salvos[index];
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
                              onPressed: () async {
                                await removerAtividade(item);
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
            onSelected: (value) async {
              final lista = await atividades;
              if (value == 'aleatoria') mostrarAleatoria(lista);
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
      body: Container(
        decoration: BoxDecoration(color: AppColors.background),
        child: FutureBuilder<List<Atividade>>(
          future: atividades,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar atividades.'));
            }

            final items = snapshot.data ?? [];

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
                final isFeito = atividadesFeitas.contains(atividade.titulo);

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
                            size: 40, // Reduzir o tamanho do ícone
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      if (isFeito)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
      ),
    );
  }
}
