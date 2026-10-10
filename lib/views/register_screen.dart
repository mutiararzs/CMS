import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../widgets/app_header.dart';

/// Placeholder. Isi dengan form registrasi (FR-01.1) pada tahap berikutnya.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'DAFTAR AKUN', showBack: true),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Text(
                    'Form registrasi siswa belum dibuat.',
                    textAlign: TextAlign.center,
                    style: AppText.body(size: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}