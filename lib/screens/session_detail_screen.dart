import 'package:flutter/material.dart';

class SessionDetailScreen extends StatelessWidget {
  final String technology;
  final double hours;

  const SessionDetailScreen({
    super.key,
    required this.technology,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Sessão')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.code, size: 64, color: Color(0xFF1744A0)),
              const SizedBox(height: 24),
              Text(technology, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('${hours}h estudadas', style: const TextStyle(fontSize: 22, color: Colors.grey)),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
