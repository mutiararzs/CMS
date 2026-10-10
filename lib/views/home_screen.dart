import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/theme.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/app_header.dart';
import '../widgets/neo_button.dart';

/// Placeholder. Ganti dengan beranda sebenarnya (daftar paket tes, dll.).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().user;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'BERANDA'),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Halo, ${user?.nama ?? 'Siswa'}!',
                          textAlign: TextAlign.center,
                          style: AppText.mono(size: 20, letterSpacing: 1),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Login berhasil. Halaman beranda belum dibuat.',
                          textAlign: TextAlign.center,
                          style: AppText.body(size: 14, color: AppColors.brown),
                        ),
                        const SizedBox(height: 32),
                        NeoButton(
                          label: 'KELUAR',
                          icon: Icons.logout,
                          iconAtEnd: false,
                          color: AppColors.lavender,
                          textColor: AppColors.ink,
                          fontSize: 14,
                          onPressed: () =>
                              context.read<AuthViewModel>().logout(),
                        ),
                      ],
                    ),
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