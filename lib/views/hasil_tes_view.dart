import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/login_colors.dart';
import '../viewmodels/hasil_tes_viewmodel.dart';

class HasilTesView extends StatelessWidget {
  /// true jika dibuka dari tab Riwayat: app bar berisi tombol kembali
  /// dengan judul "Riwayat Hasil", tanpa bottom nav.
  final bool fromHistory;

  const HasilTesView({super.key, this.fromHistory = false});

  static const _chipBg = Color(0xFFE6EEFF);
  static const _sectionBlue = Color(0xFFE6EEFF);
  static const _tagBg = Color(0xFFDDE9FF);
  static const _careerIconBg = Color(0xFFCAE6FF);
  static const _careerIconFg = Color(0xFF001E30);
  static const _majorIconBg = Color(0xFF8CCDFF);
  static const _majorIconFg = Color(0xFF004465);

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature belum tersedia')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HasilTesViewModel>();

    return Scaffold(
      backgroundColor: LoginColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                fromHistory ? _buildHistoryAppBar(context) : _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeading(vm),
                        const SizedBox(height: 16),
                        _buildDominantCard(vm),
                        const SizedBox(height: 16),
                        _buildInterpretation(vm),
                        const SizedBox(height: 16),
                        _buildCareers(vm),
                        const SizedBox(height: 16),
                        _buildMajors(context, vm),
                        if (!fromHistory) ...[
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context)
                                  .popUntil((r) => r.isFirst),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: LoginColors.buttonDark,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                'Kembali ke Beranda',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
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
            Expanded(
              child: Text(
                'Hasil',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  height: 26 / 18,
                  fontWeight: FontWeight.w600,
                  color: LoginColors.textDark,
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: LoginColors.avatarBg,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.person, size: 20, color: LoginColors.link),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryAppBar(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
              'Riwayat Hasil',
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

  Widget _buildHeading(HasilTesViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _chipBg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event_available_rounded,
                  size: 14, color: LoginColors.link),
              const SizedBox(width: 6),
              Text(
                'Selesai ${vm.completedDateText}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: LoginColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Hasil Asesmen Anda',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            height: 34 / 26,
            fontWeight: FontWeight.w700,
            color: LoginColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pemetaan komprehensif minat vokasional, potensi karir, dan rumpun studi akademik Anda.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 22 / 14,
            color: LoginColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildDominantCard(HasilTesViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LoginColors.divider,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: LoginColors.link,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                size: 18, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIPE DOMINAN ANDA',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    height: 14 / 10,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: LoginColors.textMuted,
                    color: LoginColors.textMuted,
                  ),
                ),
                Text(
                  '${vm.dominantCode} (${vm.dominantLabel})',
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
          const SizedBox(width: 8),
          const Icon(Icons.info_outline_rounded,
              size: 20, color: LoginColors.link),
        ],
      ),
    );
  }

  Widget _buildInterpretation(HasilTesViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _sectionBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_alt_rounded,
                  size: 18, color: LoginColors.link),
              const SizedBox(width: 4),
              Text(
                'INTERPRETASI PSIKOMETRIK',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  decorationColor: LoginColors.link,
                  color: LoginColors.link,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            vm.profileTitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: LoginColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            vm.profileDescription,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 22.75 / 14,
              color: LoginColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in vm.traits)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: LoginColors.background,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    t,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      height: 14 / 10,
                      fontWeight: FontWeight.w700,
                      color: LoginColors.textDark,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 18, color: iconFg),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: LoginColors.textDark,
                ),
              ),
              Text(
                subtitle,
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
        trailing,
      ],
    );
  }

  Widget _buildCareers(HasilTesViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LoginColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildSectionHeader(
            icon: Icons.work_outline_rounded,
            iconBg: _careerIconBg,
            iconFg: _careerIconFg,
            title: 'Top Karir Rekomendasi',
            subtitle: 'Kesesuaian jalur profesional masa depan',
            trailing: const Icon(Icons.trending_up_rounded,
                size: 18, color: LoginColors.textMuted),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < vm.careers.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _buildCareerCard(vm.careers[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildCareerCard(CareerRecommendation c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LoginColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: _chipBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(c.icon, size: 22, color: LoginColors.link),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: LoginColors.textDark,
                      ),
                    ),
                    Text(
                      c.subtitle,
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
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final t in c.tags)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _tagBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    t,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      height: 14 / 10,
                      fontWeight: FontWeight.w700,
                      color: LoginColors.textMuted,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMajors(BuildContext context, HasilTesViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _sectionBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildSectionHeader(
            icon: Icons.school_outlined,
            iconBg: _majorIconBg,
            iconFg: _majorIconFg,
            title: 'Top Jurusan Rekomendasi',
            subtitle: 'Program studi selaras dengan karakter Anda',
            trailing: Text(
              '${vm.majors.length}\nJurusan',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                height: 14 / 10,
                fontWeight: FontWeight.w700,
                color: LoginColors.link,
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < vm.majors.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _buildMajorRow(context, i + 1, vm.majors[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildMajorRow(BuildContext context, int rank, MajorRecommendation m) {
    return Material(
      color: LoginColors.background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _comingSoon(context, 'Detail jurusan'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: LoginColors.divider,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  rank.toString().padLeft(2, '0'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: LoginColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: LoginColors.textDark,
                      ),
                    ),
                    Text(
                      m.faculty,
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
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 10, color: LoginColors.link),
            ],
          ),
        ),
      ),
    );
  }
}
