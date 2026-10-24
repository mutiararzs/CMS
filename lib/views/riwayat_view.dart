import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/login_colors.dart';
import '../viewmodels/riwayat_viewmodel.dart';

/// Isi tab "Riwayat". Ditampilkan di dalam HomeView (tanpa Scaffold sendiri).
class RiwayatView extends StatefulWidget {
  final VoidCallback onBack;

  const RiwayatView({super.key, required this.onBack});

  @override
  State<RiwayatView> createState() => _RiwayatViewState();
}

class _RiwayatViewState extends State<RiwayatView> {
  static const _statusBg = Color(0xFFCAE6FF);

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature belum tersedia')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RiwayatViewModel>();
    final items = vm.visibleItems;

    return Column(
      children: [
        _buildAppBar(vm),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilters(vm),
                const SizedBox(height: 24),
                if (items.isEmpty)
                  _buildEmpty()
                else
                  for (final item in items) ...[
                    _buildCard(item),
                    const SizedBox(height: 16),
                  ],
                const SizedBox(height: 8),
                _buildTips(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(RiwayatViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRoundButton(
            icon: Icons.arrow_back_ios_new_rounded,
            size: 13,
            tooltip: 'Kembali',
            onTap: widget.onBack,
          ),
          Column(
            children: [
              Text(
                'Riwayat Asesmen',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  height: 26 / 18,
                  fontWeight: FontWeight.w600,
                  color: LoginColors.textDark,
                ),
              ),
              Text(
                '${vm.totalCount} Aktivitas Tercatat',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
                  color: LoginColors.textMuted,
                ),
              ),
            ],
          ),
          _buildRoundButton(
            icon: Icons.tune_rounded,
            size: 15,
            tooltip: 'Filter',
            onTap: () => _comingSoon('Filter lanjutan'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton({
    required IconData icon,
    required double size,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Material(
      color: LoginColors.card,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Tooltip(
            message: tooltip,
            child: Icon(icon, size: size, color: LoginColors.textDark),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(RiwayatViewModel vm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('Semua', vm.totalCount, vm.filter == null, () => vm.setFilter(null)),
          const SizedBox(width: 8),
          _buildChip(
            'Selesai',
            vm.doneCount,
            vm.filter == RiwayatStatus.selesai,
            () => vm.setFilter(RiwayatStatus.selesai),
          ),
          const SizedBox(width: 8),
          _buildChip(
            'Dalam Proses',
            vm.inProgressCount,
            vm.filter == RiwayatStatus.dalamProses,
            () => vm.setFilter(RiwayatStatus.dalamProses),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, int count, bool selected, VoidCallback onTap) {
    return Material(
      color: selected ? LoginColors.buttonDark : LoginColors.card,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : LoginColors.textMuted,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? LoginColors.accent : LoginColors.iconButtonBg,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    height: 14 / 10,
                    fontWeight: FontWeight.w700,
                    color: selected ? LoginColors.onAccent : LoginColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(RiwayatItem item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Container(
        color: LoginColors.card,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: LoginColors.link,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.dateText,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: LoginColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        _buildStatusBadge(item),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: LoginColors.divider,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(item.icon, size: 22, color: LoginColors.link),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                height: 26 / 18,
                                fontWeight: FontWeight.w600,
                                color: LoginColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.description,
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
                  _buildDetailBox(item),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => _comingSoon(item.isDone ? 'Detail hasil' : 'Lanjutkan tes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LoginColors.buttonDark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.isDone ? 'Lihat Hasil' : 'Lanjutkan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, size: 12, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Garis aksen di dasar kartu; pada tes yang belum selesai mengikuti progres.
            Container(
              height: 4,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              color: item.isDone ? LoginColors.accent : LoginColors.avatarBg,
              child: item.isDone
                  ? null
                  : FractionallySizedBox(
                      widthFactor: item.percent.clamp(0, 100) / 100,
                      child: Container(color: LoginColors.accent),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(RiwayatItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _statusBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.isDone ? Icons.check_circle_rounded : Icons.timelapse_rounded,
            size: 11.67,
            color: LoginColors.onAccent,
          ),
          const SizedBox(width: 4),
          Text(
            item.isDone ? 'Selesai' : 'Dalam Proses',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              height: 14 / 10,
              fontWeight: FontWeight.w700,
              color: LoginColors.onAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBox(RiwayatItem item) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: LoginColors.iconButtonBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.detailLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      height: 14 / 10,
                      fontWeight: FontWeight.w700,
                      color: LoginColors.textMuted,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: item.detailValue,
                          style: const TextStyle(color: LoginColors.textDark),
                        ),
                        TextSpan(
                          text: ' (${item.percent}%)',
                          style: const TextStyle(color: LoginColors.link),
                        ),
                      ],
                    ),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.pillIcon != null) ...[
                  Icon(item.pillIcon, size: 12, color: LoginColors.accent),
                  const SizedBox(width: 4),
                ],
                if (item.pillPrefix != null) ...[
                  Text(
                    item.pillPrefix!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      height: 14 / 10,
                      fontWeight: FontWeight.w700,
                      color: LoginColors.accent,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  item.pillText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: LoginColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          'Belum ada asesmen pada kategori ini',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: LoginColors.textMuted),
        ),
      ),
    );
  }

  Widget _buildTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LoginColors.iconButtonBg,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: _statusBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              size: 18,
              color: LoginColors.onAccent,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIPS EKSPLORASI',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    height: 14 / 10,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: LoginColors.link,
                    color: LoginColors.link,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Kombinasikan hasil RIASEC dan Nilai Kerja untuk rekomendasi jurusan kuliah yang paling presisi.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 18 / 12,
                    color: LoginColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}