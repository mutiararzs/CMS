import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/login_colors.dart';
import '../viewmodels/hasil_tes_viewmodel.dart';
import '../viewmodels/soal_tes_viewmodel.dart';
import 'hasil_tes_view.dart';

class SoalTesView extends StatelessWidget {
  const SoalTesView({super.key});

  static const _ink = Color(0xFF251838);
  static const _optionNumBg = Color(0xFFD5E3FD);
  static const _questionBg = Color(0xFFE6EEFF);
  static const _slate700 = Color(0xFF334155);
  static const _slate600 = Color(0xFF475569);
  static const _slate300 = Color(0xFFCBD5E1);
  static const _slate200 = Color(0xFFE2E8F0);
  static const _slate100 = Color(0xFFF1F5F9);
  static const _answered = Color(0xFFC9EE9E);
  static const _bulb = Color(0xFFFFE100);

  Future<bool> _confirmExit(BuildContext context) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari tes?'),
        content: const Text(
            'Jawaban yang sudah diisi akan hilang jika Anda keluar sekarang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjut Mengerjakan'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    return res ?? false;
  }

  Future<void> _onNext(BuildContext context) async {
    final vm = context.read<SoalTesViewModel>();
    if (!vm.isLast) {
      vm.next();
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    if (vm.unansweredCount > 0) {
      messenger.showSnackBar(
        SnackBar(
            content: Text(
                'Masih ada ${vm.unansweredCount} soal yang belum dijawab')),
      );
      return;
    }
    final ok = await vm.submit();
    if (!context.mounted || !ok) return;
    // Ganti seluruh alur tes dengan halaman hasil; tombol kembali menuju beranda.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => HasilTesViewModel(),
          child: const HasilTesView(),
        ),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SoalTesViewModel>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        if (await _confirmExit(context)) nav.pop();
      },
      child: Scaffold(
        backgroundColor: LoginColors.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  _buildAppBar(context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                    child: _buildNumberPanel(vm),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildQuestion(vm),
                          const SizedBox(height: 16),
                          _buildOptions(vm),
                          if (vm.isFirst) ...[
                            // tips hanya di soal nomor 1
                            const SizedBox(height: 16),
                            _buildTip(),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _buildBottomBar(context, vm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: IconButton(
                tooltip: 'Kembali',
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16, color: _ink),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Sesi Penilaian Aktif',
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

  Widget _buildQuestion(SoalTesViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _questionBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            color: _slate700,
            child: Text(
              'KATEGORI: ${vm.current.categoryLabel}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                height: 14 / 10,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            vm.current.text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              height: 24.75 / 18,
              fontWeight: FontWeight.w600,
              color: _ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(SoalTesViewModel vm) {
    return Column(
      children: [
        for (var i = 0; i < SoalTesViewModel.scaleLabels.length; i++) ...[
          _buildOption(
            value: i + 1,
            label: SoalTesViewModel.scaleLabels[i],
            selected: vm.currentAnswer == i + 1,
            onTap: () => vm.selectAnswer(i + 1),
          ),
          if (i < SoalTesViewModel.scaleLabels.length - 1)
            const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildOption({
    required int value,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? LoginColors.buttonDark : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _optionNumBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$value',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    height: 22 / 15,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected ? const Color(0xFFFFFBFF) : _ink,
                  ),
                ),
              ),
              if (selected)
                const Icon(Icons.check_rounded,
                    size: 16, color: Color(0xFFFFFBFF)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LoginColors.divider,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_rounded, size: 18, color: _bulb),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pilih jawaban secara jujur agar hasil akurat.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 18 / 13,
                fontWeight: FontWeight.w500,
                color: _ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPanel(SoalTesViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _slate200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nomor Soal',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _slate700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _slate100,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${vm.pageEnd - vm.pageStart} Soal',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    height: 15 / 10,
                    fontWeight: FontWeight.w500,
                    color: _slate600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = vm.pageStart; i < vm.pageEnd; i++) ...[
                if (i > vm.pageStart) const SizedBox(width: 4),
                Expanded(child: _buildNumberCell(vm, i)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberCell(SoalTesViewModel vm, int i) {
    final isCurrent = i == vm.index;
    final isAnswered = vm.isAnswered(i);
    final Color bg =
        isCurrent ? _slate300 : (isAnswered ? _answered : _slate100);
    final Color fg = (isCurrent || isAnswered) ? _ink : _slate700;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => vm.goTo(i),
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border:
              (isCurrent || isAnswered) ? null : Border.all(color: _slate300),
        ),
        child: Text(
          '${i + 1}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, SoalTesViewModel vm) {
    final label = vm.isLast ? 'KIRIM JAWABAN' : 'SELANJUTNYA';

    return Container(
      color: LoginColors.background,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _navButton(
              onPressed: vm.isFirst ? null : vm.previous,
              leading:
                  const Icon(Icons.arrow_back_rounded, size: 14, color: _ink),
              label: 'SEBELUMNYA',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _navButton(
              onPressed: vm.isSubmitting ? null : () => _onNext(context),
              label: label,
              trailing: vm.isSubmitting
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: _ink),
                    )
                  : Icon(
                      vm.isLast
                          ? Icons.send_rounded
                          : Icons.arrow_forward_rounded,
                      size: 14,
                      color: _ink,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton({
    required VoidCallback? onPressed,
    required String label,
    Widget? leading,
    Widget? trailing,
  }) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: Material(
        color: LoginColors.divider,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null) ...[leading, const SizedBox(width: 4)],
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: _ink,
                    color: _ink,
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 4), trailing],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
