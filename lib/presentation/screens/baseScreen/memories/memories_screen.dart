import 'package:flutter/material.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Memórias", style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
