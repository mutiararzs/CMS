import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/login_colors.dart';
import '../viewmodels/informasi_tes_viewmodel.dart';
import '../viewmodels/soal_tes_viewmodel.dart';
import 'soal_tes_view.dart';

class InformasiTesView extends StatelessWidget {
  const InformasiTesView({super.key});

  static const _tipBg = Color(0xFFDDE9FF);

  Future<void> _start(BuildContext context) async {
    final vm = context.read<InformasiTesViewModel>();
    final ok = await vm.startTest();
    if (!context.mounted || !ok) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => SoalTesViewModel(),
          child: const SoalTesView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InformasiTesViewModel>();

    return Scaffold(
      backgroundColor: LoginColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(vm),
                        const SizedBox(height: 24),
                        _buildSummary(vm),
                        const SizedBox(height: 24),
                        _buildInstructions(vm),
                        const SizedBox(height: 24),
                        _buildDimensionCard(vm),
                        const SizedBox(height: 24),
                        _buildStartButton(context, vm),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Material(
              color: LoginColors.card,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.maybePop(context),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 13,
                    color: LoginColors.textDark,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Text(
              'Informasi Tes',
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

  Widget _buildHeader(InformasiTesViewModel vm) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: double.infinity,
        color: LoginColors.card,
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            // Cahaya biru lembut di pojok kanan atas (sesuai desain)
            Positioned(
              top: -56,
              right: -56,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: LoginColors.accent.withValues(alpha: 0.28),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: LoginColors.divider,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: LoginColors.link,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        vm.badge,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: LoginColors.link,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  vm.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    height: 30 / 22,
                    fontWeight: FontWeight.w700,
                    color: LoginColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vm.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 22.75 / 14,
                    color: LoginColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(InformasiTesViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'RINGKASAN TES',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: LoginColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.45,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [for (final s in vm.stats) _buildStatCard(s)],
        ),
      ],
    );
  }

  Widget _buildStatCard(TestStat s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: LoginColors.accent,
              shape: BoxShape.circle,
            ),
            child: Icon(s.icon, size: 16, color: LoginColors.link),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  s.value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    height: 26 / 18,
                    fontWeight: FontWeight.w700,
                    color: LoginColors.textDark,
                  ),
                ),
              ),
              Text(
                s.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  height: 18 / 12,
                  color: LoginColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(InformasiTesViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LoginColors.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: LoginColors.buttonDark,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.checklist_rounded, size: 15, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                'Petunjuk Pengerjaan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: LoginColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final text in vm.instructions) ...[
            _buildInstructionItem(text),
            const SizedBox(height: 12),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _tipBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 18, height: 27 / 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tips: ${vm.tip}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 18 / 12,
                      fontWeight: FontWeight.w600,
                      color: LoginColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: LoginColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, size: 12, color: LoginColors.link),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 22 / 14,
                color: LoginColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDimensionCard(InformasiTesViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: LoginColors.accent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.hexagon_outlined, size: 25, color: LoginColors.link),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.dimensionTitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: LoginColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  vm.dimensionSubtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 18 / 12,
                    color: LoginColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, InformasiTesViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: vm.isStarting ? null : () => _start(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: LoginColors.buttonDark,
          foregroundColor: Colors.white,
          disabledBackgroundColor: LoginColors.buttonDark.withValues(alpha: 0.6),
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: vm.isStarting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mulai Kerjakan Soal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 13, color: Colors.white),
                ],
              ),
      ),
    );
  }
}