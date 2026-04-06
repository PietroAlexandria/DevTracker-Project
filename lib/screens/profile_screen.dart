import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabeçalho com Stack: banner + foto sobreposta
            SizedBox(
              height: 160,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    color: const Color(0xFF1744A0),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: AssetImage('assets/images/profile_picture1.jpg'),
                        backgroundColor: const Color(0xFF1744A0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Nome e RA
            const Text(
              'Pietro de Alexandria Picoli',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'RA: 271418',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // Conquistas
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Conquistas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _AchievementCard(label: 'Foco', icon: Icons.center_focus_strong),
                  const SizedBox(width: 8),
                  _AchievementCard(label: 'Disciplina', icon: Icons.military_tech),
                  const SizedBox(width: 8),
                  _AchievementCard(label: 'Código Limpo', icon: Icons.cleaning_services),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String label;
  final IconData icon;

  const _AchievementCard({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: const Color(0xFF1744A0).withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF1744A0), size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
