import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two/services/activity_service.dart';

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

class AtividadeProvider extends ChangeNotifier {
  final Map<String, List<Atividade>> _atividadesPorCategoria = {};
  final Set<String> _salvas = {};
  final Set<String> _feitas = {};

  List<Atividade> getAtividades(String categoria) {
    return _atividadesPorCategoria[categoria] ?? [];
  }

  Future<void> carregarAtividades(String categoria) async {
    if (_atividadesPorCategoria.containsKey(categoria)) return;
    final String path = 'assets/data/$categoria.json';
    final String response = await rootBundle.loadString(path);
    final List<dynamic> data = json.decode(response);
    final atividades = <Atividade>[];
    for (var i = 0; i < data.length; i++) {
      final atividade = Atividade.fromJson(data[i], id: data[i]['id'] ?? data[i]['titulo'] ?? '$i');
      atividade.isSalva = _salvas.contains(atividade.id);
      atividade.isFeita = _feitas.contains(atividade.id);
      atividades.add(atividade);
    }
    _atividadesPorCategoria[categoria] = atividades;
    notifyListeners();
  }

  Future<void> salvarAtividade(String categoria, Atividade atividade) async {
    _salvas.add(atividade.id);
    _updateStatus(categoria, atividade.id, salva: true);
    notifyListeners();
    // Salva no backend
    await ActivityService.saveActivity(atividade.id);
  }

  Future<void> removerAtividade(String categoria, Atividade atividade) async {
    _salvas.remove(atividade.id);
    _updateStatus(categoria, atividade.id, salva: false);
    notifyListeners();
    // Remove do backend
    await ActivityService.unsaveActivity(atividade.id);
  }

  Future<void> marcarComoFeita(String categoria, Atividade atividade) async {
    _feitas.add(atividade.id);
    _updateStatus(categoria, atividade.id, feita: true);
    notifyListeners();
    // Marca como feita no backend
    await ActivityService.markAsDone(atividade.id);
  }

  void _updateStatus(String categoria, String id, {bool? salva, bool? feita}) {
    final lista = _atividadesPorCategoria[categoria];
    if (lista == null) return;
    for (var a in lista) {
      if (a.id == id) {
        if (salva != null) a.isSalva = salva;
        if (feita != null) a.isFeita = feita;
      }
    }
  }

  List<Atividade> getSalvas(String categoria) {
    return getAtividades(categoria).where((a) => a.isSalva).toList();
  }
}
