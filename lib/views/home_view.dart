import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/login_colors.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/informasi_tes_viewmodel.dart';
import 'informasi_tes_view.dart';
import 'profile_view.dart';
import 'riwayat_view.dart';
import '../viewmodels/notif_viewmodel.dart';
import 'notif_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: LoginColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                if (vm.tabIndex == 0) _buildAppBar(),
                Expanded(
                  child: vm.tabIndex == 1
                      ? RiwayatView(onBack: () => vm.selectTab(0))
                      : vm.tabIndex == 2
                      ? const ProfilView()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileRow(vm),
                              const SizedBox(height: 24),
                              _buildAssessmentCard(vm),
                              const SizedBox(height: 24),
                              _buildHistory(vm),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(vm),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Image.asset(
              'assets/images/logo-peta-masa-depanku.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.explore,
                size: 32,
                color: LoginColors.link,
              ),
            ),
            const SizedBox(width: 30),
            Text(
              'Beranda',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                height: 26 / 18,
                fontWeight: FontWeight.w600,
                color: LoginColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(HomeViewModel vm) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: LoginColors.avatarBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 32, color: LoginColors.link),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: LoginColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: LoginColors.background, width: 1.5),
                ),
                child: const Icon(Icons.check, size: 10, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vm.greeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  height: 26 / 18,
                  fontWeight: FontWeight.w600,
                  color: LoginColors.textDark,
                ),
              ),
              Text(
                vm.studentInfo,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  height: 18 / 12,
                  color: LoginColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: LoginColors.iconButtonBg,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => NotifikasiViewModel(),
                  child: const NotifikasiView(),
                ),
              ),
            ),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.notifications_none_rounded,
                size: 20,
                color: LoginColors.textDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssessmentCard(HomeViewModel vm) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: double.infinity,
        color: LoginColors.buttonDark,
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            // Lingkaran cahaya biru di pojok kanan atas
            Positioned(
              top: -48,
              right: -48,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(
                  width: 176,
                  height: 176,
                  decoration: BoxDecoration(
                    color: LoginColors.accent.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const Positioned(
              right: 0,
              bottom: 56,
              child: Opacity(
                opacity: 0.2,
                child: Icon(Icons.explore_outlined, size: 120, color: LoginColors.accent),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: LoginColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: LoginColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Asesmen Tersedia',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: LoginColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      vm.assessmentDateText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        height: 14 / 10,
                        fontWeight: FontWeight.w700,
                        color: LoginColors.slate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Ayo Mulai Tes Minat & Bakat!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    height: 27.5 / 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Temukan potensi karier masa depan dan jurusan\nkuliah terbaik sesuai profil unikmu.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 18 / 12,
                    color: LoginColors.slate,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMeta(Icons.help_outline_rounded, '${vm.totalQuestions} Soal'),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('•', style: TextStyle(color: LoginColors.slate)),
                    ),
                    Flexible(
                      child: _buildMeta(
                        Icons.schedule_rounded,
                        'Estimasi ${vm.estimatedMinutes} Menit',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => InformasiTesViewModel(),
                          child: const InformasiTesView(),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LoginColors.accent,
                      foregroundColor: LoginColors.onAccent,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mulai Sekarang',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: LoginColors.onAccent,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 14, color: LoginColors.onAccent),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeta(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: LoginColors.accent),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistory(HomeViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Riwayat Tes Terbaru',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: LoginColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: LoginColors.card,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: LoginColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.psychology_alt_outlined,
                      size: 20,
                      color: LoginColors.link,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.lastTestTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: LoginColors.textDark,
                          ),
                        ),
                        Text(
                          'Selesai pada ${vm.lastTestDateText}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            height: 18 / 12,
                            color: LoginColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: LoginColors.divider,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${vm.matchPercent}% Cocok',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        height: 14 / 10,
                        fontWeight: FontWeight.w700,
                        color: LoginColors.buttonDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: LoginColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tipe Dominan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              height: 14 / 10,
                              fontWeight: FontWeight.w700,
                              color: LoginColors.textMuted,
                            ),
                          ),
                          Text(
                            vm.dominantType,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: LoginColors.link,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Container(
                        width: 96,
                        height: 8,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: LoginColors.avatarBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: vm.matchPercent.clamp(0, 100) / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: LoginColors.accent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(HomeViewModel vm) {
    const items = [
      (Icons.home_rounded, Icons.home_outlined, 'Beranda'),
      (Icons.history_rounded, Icons.history_rounded, 'Riwayat'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Profil'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: LoginColors.background,
        border: Border(
          top: BorderSide(color: LoginColors.divider.withValues(alpha: 0.6)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < items.length; i++)
                _buildNavItem(
                  icon: i == vm.tabIndex ? items[i].$1 : items[i].$2,
                  label: items[i].$3,
                  selected: i == vm.tabIndex,
                  onTap: () => vm.selectTab(i),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final color = selected ? LoginColors.link : LoginColors.textMuted;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 28,
              decoration: BoxDecoration(
                color: selected ? LoginColors.divider : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                height: 14 / 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}