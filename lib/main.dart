import 'package:design_task/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TranslationTestApp());
}

class TranslationTestApp extends StatelessWidget {
  const TranslationTestApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moniepoint Translation Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Euclid',
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffaf957e)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
