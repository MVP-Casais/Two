import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two/services/connection_service.dart';

class Partner {
  final String name;
  final String username;
  final String? avatarUrl;
  final int? coupleId;

  Partner({
    required this.name,
    required this.username,
    this.avatarUrl,
    this.coupleId,
  });

  factory Partner.fromMap(Map<String, dynamic> map) {
    return Partner(
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      avatarUrl: map['avatarUrl'],
      coupleId: map['coupleId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'avatarUrl': avatarUrl,
      'coupleId': coupleId,
    };
  }
}

class ConnectionProvider extends ChangeNotifier {
  bool isConnected = false;
  Partner? partner;
  bool syncPlanner = false;

  /// Sempre busca do backend e atualiza local, garantindo atualização em todas as telas.
  Future<void> restoreConnection() async {
    final prefs = await SharedPreferences.getInstance();

    Partner? backendPartner;
    bool connected = false;

    try {
      // 1. Busca parceiro do backend (preferencial)
      backendPartner = await ConnectionService.getCurrentPartner();
      if (_isValidPartner(backendPartner)) {
        partner = backendPartner;
        connected = true;
      } else {
        // 2. Se não achou, tenta pelo coupleId
        final coupleId = await ConnectionService.getConnectedCoupleId();
        if (coupleId != null) {
          final realPartner = await ConnectionService.getPartnerByCoupleId(coupleId);
          if (_isValidPartner(realPartner)) {
            partner = realPartner;
            connected = true;
          }
        }
      }
    } catch (e) {
      print('Erro ao buscar conexão do backend: $e');
    }

    // 3. Se não achou no backend, tenta restaurar do local
    if (!connected) {
      final partnerJson = prefs.getString('partner');
      if (partnerJson != null) {
        try {
          final partnerMap = jsonDecode(partnerJson);
          partner = Partner.fromMap(partnerMap);
          connected = _isValidPartner(partner);
        } catch (e) {
          partner = null;
          connected = false;
        }
      } else {
        partner = null;
        connected = false;
      }
    }

    isConnected = connected;
    // Atualiza local sempre que houver conexão
    if (isConnected && partner != null) {
      await prefs.setString('partner', jsonEncode(partner!.toMap()));
    } else {
      await prefs.remove('partner');
    }
    await prefs.setBool('isConnected', isConnected);

    // Notifica listeners e força atualização dos providers dependentes
    notifyListeners();
    // Atualiza MemoriesProvider e PlannerProvider se existirem no contexto
    // (chame restoreConnection no initState das telas ou use um listener global)
  }

  Future<void> connect() async {
    try {
      final result = await ConnectionService.connect();
      if (_isValidPartner(result)) {
        partner = result;
        isConnected = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('partner', jsonEncode(partner!.toMap()));
        await prefs.setBool('isConnected', true);
      } else {
        isConnected = false;
      }
    } catch (e) {
      isConnected = false;
    }
    notifyListeners();
  }

  Future<void> disconnect() async {
    partner = null;
    isConnected = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('partner');
    await prefs.setBool('isConnected', false);
    notifyListeners();
  }

  void setSyncPlanner(bool value) {
    syncPlanner = value;
    notifyListeners();
  }

  Future<String?> sendConnectionRequest(String username) async {
    try {
      final result = await ConnectionService.sendConnectionRequest(username);
      if (_isValidPartner(result)) {
        partner = result;
        isConnected = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('partner', jsonEncode(partner!.toMap()));
        await prefs.setBool('isConnected', true);
        notifyListeners();
        return null;
      } else {
        return "Usuário não encontrado ou erro ao enviar convite.";
      }
    } catch (e) {
      return "Erro ao enviar convite.";
    }
  }

  bool _isValidPartner(Partner? partner) {
    return partner != null && partner.coupleId != null && partner.name.isNotEmpty && partner.username.isNotEmpty;
  }
}
