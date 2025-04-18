import 'package:design_task/home_page.dart';
import 'package:design_task/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const TranslationTestApp());
}

class TranslationTestApp extends StatelessWidget {
  const TranslationTestApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) {
          return MaterialApp(
            title: 'Translation Test',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Euclid',
              colorScheme: ColorScheme.fromSeed(seedColor: Palette.primary),
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        });
  }
}
