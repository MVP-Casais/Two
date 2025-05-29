import 'dart:io';
import 'package:flutter/material.dart';
import 'package:two/services/memories_service.dart';
import 'package:two/services/connection_service.dart';

class MemoryPost {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;

  MemoryPost({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
  });
}

class MemoriesProvider extends ChangeNotifier {
  List<MemoryPost> memories = [];

  Future<void> fetchMemories() async {
    final coupleId = await ConnectionService.getConnectedCoupleId();
    if (coupleId == null) {
      memories = [];
      notifyListeners();
      return;
    }
    final result = await MemoriesService.fetchMemories();
    memories = result;
    notifyListeners();
  }

  Future<bool> addMemory({
    required String title,
    required String description,
    required String imagePath,
  }) async {
    final result = await MemoriesService.addMemory(
      title: title,
      description: description,
      imageFile: File(imagePath),
    );
    if (result != null) {
      memories.insert(0, result);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> editMemory({
    required MemoryPost post,
    required String title,
    required String description,
  }) async {
    // O coupleId agora é buscado dentro do MemoriesService.editMemory
    final result = await MemoriesService.editMemory(
      id: post.id,
      title: title,
      description: description,
    );
    if (result != null) {
      final index = memories.indexWhere((m) => m.id == post.id);
      if (index != -1) {
        memories[index] = result;
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  Future<bool> deleteMemory({required MemoryPost post}) async {
    final success = await MemoriesService.deleteMemory(id: post.id);
    if (success) {
      memories.removeWhere((m) => m.id == post.id);
      notifyListeners();
      return true;
    }
    return false;
  }
}
