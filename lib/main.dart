import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'views/login_view.dart';

void main() => runApp(const PetaMasaDepankuApp());

class PetaMasaDepankuApp extends StatelessWidget {
  const PetaMasaDepankuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peta Masa Depanku',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginView(),
    );
  }
}