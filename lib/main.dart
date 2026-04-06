import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'screens/study_screen.dart';

void main() => runApp(const DevTrackerApp());

class DevTrackerApp extends StatelessWidget {
  const DevTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevTracker',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1744A0))),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [ProfileScreen(), StudyScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Estudos'),
        ],
      ),
    );
  }
}
