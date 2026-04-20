import 'package:flutter/material.dart';
import 'package:gym_app/app/theme/app_theme.dart';
import 'package:gym_app/features/home/presentation/pages/home_page.dart';

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym App',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
