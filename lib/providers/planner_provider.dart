import 'package:flutter/material.dart';
import 'package:two/services/planner_service.dart';
import 'package:two/services/connection_service.dart';

class PlannerProvider extends ChangeNotifier {
  Map<DateTime, List<Map<String, dynamic>>> eventsByDate = {};

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  Future<void> fetchEvents() async {
    final realCoupleId = await ConnectionService.getConnectedCoupleId();
    if (realCoupleId == null) {
      print('Erro: Não foi possível obter o id do casal conectado.');
      eventsByDate = {};
      // Adicione aqui: notifique o usuário se necessário
      safeNotifyListeners();
      return;
    }
    final result = await PlannerService.fetchEvents();
    if (result != null) {
      eventsByDate = result;
      safeNotifyListeners();
    } else {
      eventsByDate = {};
      safeNotifyListeners();
    }
  }

  Future<bool> createEvent({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String category,
    required Color categoryColor,
    required DateTime date,
    int? coupleId,
  }) async {
    // Sempre busque o coupleId do backend para garantir que está correto
    final realCoupleId = await ConnectionService.getConnectedCoupleId();
    if (realCoupleId == null) {
      print('Erro: Não foi possível obter o id do casal conectado.');
      return false;
    }
    final success = await PlannerService.createEvent(
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      category: category,
      categoryColor: categoryColor,
      date: date,
      coupleId: realCoupleId,
    );
    if (success) {
      await fetchEvents();
      return true;
    }
    return false;
  }

  Future<bool> updateEvent({
    required Map<String, dynamic> event,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String category,
    required Color categoryColor,
  }) async {
    final success = await PlannerService.updateEvent(
      event: event,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      category: category,
      categoryColor: categoryColor,
    );
    if (success) {
      await fetchEvents();
      return true;
    }
    return false;
  }

  Future<bool> deleteEvent(Map<String, dynamic> event) async {
    final success = await PlannerService.deleteEvent(event);
    if (success) {
      await fetchEvents();
      return true;
    }
    return false;
  }
}
