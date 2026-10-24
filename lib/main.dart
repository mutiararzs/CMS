import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/login_colors.dart';
import 'viewmodels/login_viewmodel.dart';
import 'views/login_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        // Tambahkan provider lain (mis. AuthViewModel) di sini.
      ],
      child: const MinbakApp(),
    ),
  );
}

class MinbakApp extends StatelessWidget {
  const MinbakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PIVOT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: LoginColors.link,
        ),
      ),
      home: const LoginView(),
    );
  }
}