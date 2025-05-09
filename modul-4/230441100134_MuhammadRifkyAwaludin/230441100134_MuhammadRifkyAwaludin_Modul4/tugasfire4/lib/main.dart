import 'package:flutter/material.dart';
import 'screens/tugas_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan label DEBUG
      title: 'Tugas Kuliah',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TugasScreen(),
    );
  }
}
