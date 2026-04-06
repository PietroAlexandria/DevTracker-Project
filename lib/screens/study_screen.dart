import 'package:flutter/material.dart';
import 'package:devtracker_app/screens/session_detail_screen.dart';

class StudySession {
  final String technology;
  final double hours;
  StudySession({required this.technology, required this.hours});
}

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final _techController = TextEditingController();
  final _hoursController = TextEditingController();
  final List<StudySession> _sessions = [];
  double _totalHours = 0;

  void _registerSession() {
    final tech = _techController.text.trim();
    final hoursText = _hoursController.text.trim();

    if (tech.isEmpty || hoursText.isEmpty) return;

    final hours = double.tryParse(hoursText);
    if (hours == null || hours <= 0) return;

    setState(() {
      _sessions.insert(0, StudySession(technology: tech, hours: hours));
      _totalHours += hours;
      _techController.clear();
      _hoursController.clear();
    });
  }

  @override
  void dispose() {
    _techController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Estudos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Totalizador
            Card(
              color: const Color(0xFF1744A0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          _totalHours % 1 == 0
                              ? _totalHours.toInt().toString()
                              : _totalHours.toString(),
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Total de Horas Estudadas',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Inputs
            TextField(
              controller: _techController,
              decoration: const InputDecoration(
                labelText: 'Tecnologia / Linguagem',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.code),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hoursController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Horas Estudadas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _registerSession,
                icon: const Icon(Icons.add),
                label: const Text('Registrar Sessão'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1744A0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Histórico
            Expanded(
              child: _sessions.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma sessão registrada ainda.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _sessions.length,
                      itemBuilder: (context, index) {
                        final session = _sessions[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.code, color: Color(0xFF1744A0)),
                            title: Text(session.technology),
                            trailing: Text(
                              '${session.hours}h',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SessionDetailScreen(
                                  technology: session.technology,
                                  hours: session.hours,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
