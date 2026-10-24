import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/login_colors.dart';
import '../utils/validators.dart';
import '../viewmodels/infoprib_viewmodel.dart';
import '../widgets/auth_text_field.dart';

class InformasiPribadiView extends StatefulWidget {
  const InformasiPribadiView({super.key});

  @override
  State<InformasiPribadiView> createState() => _InformasiPribadiViewState();
}

class _InformasiPribadiViewState extends State<InformasiPribadiView> {
  static const _chipBlue = Color(0xFFCAE6FF);
  static const _chipBlueText = Color(0xFF001E30);

  Future<void> _pickBirthDate() async {
    final vm = context.read<InformasiPribadiViewModel>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: vm.birthDate ?? DateTime(now.year - 16, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
      helpText: 'Pilih tanggal lahir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (picked != null) vm.setBirthDate(picked);
  }

  Future<String?> _pickOption(String title, List<String> options, String current) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: LoginColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: LoginColors.textDark,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final o in options)
                      ListTile(
                        title: Text(
                          o,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: o == current ? FontWeight.w700 : FontWeight.w400,
                            color: o == current ? LoginColors.link : LoginColors.textDark,
                          ),
                        ),
                        trailing: o == current
                            ? const Icon(Icons.check, size: 18, color: LoginColors.link)
                            : null,
                        onTap: () => Navigator.pop(ctx, o),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickLevel() async {
    final vm = context.read<InformasiPribadiViewModel>();
    final v = await _pickOption('Pilih Jenjang', InformasiPribadiViewModel.levelOptions,
        vm.levelController.text);
    if (v != null) vm.setLevel(v);
  }

  Future<void> _pickClass() async {
    final vm = context.read<InformasiPribadiViewModel>();
    final v = await _pickOption('Pilih Kelas', InformasiPribadiViewModel.classOptions,
        vm.classController.text);
    if (v != null) vm.setClass(v);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final vm = context.read<InformasiPribadiViewModel>();
    final ok = await vm.save();
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informasi pribadi berhasil disimpan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InformasiPribadiViewModel>();

    return Scaffold(
      backgroundColor: LoginColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeading(),
                        const SizedBox(height: 24),
                        _buildForm(vm),
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Kembali',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: LoginColors.textDark,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Informasi Pribadi',
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

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _chipBlue,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user_outlined, size: 12, color: _chipBlueText),
              const SizedBox(width: 4),
              Text(
                'Verifikasi Profil Resmi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
                  color: _chipBlueText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Lengkapi Identitas Diri',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            height: 34 / 26,
            fontWeight: FontWeight.w700,
            color: LoginColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Informasi ini akan dicantumkan secara resmi dalam\nLaporan Hasil Asesmen PDF milikmu.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 22 / 14,
            color: LoginColors.textMuted,
          ),
        ),
      ],
    );
  }

  /// Satu bidang isian di dalam kartu biru muda.
  Widget _buildFieldCard(Widget field) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LoginColors.card,
        borderRadius: BorderRadius.circular(32),
      ),
      child: field,
    );
  }

  Widget _buildForm(InformasiPribadiViewModel vm) {
    const chevron = Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: LoginColors.link);

    return Form(
      key: vm.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFieldCard(
            AuthTextField(
              label: 'Nama Lengkap',
              hint: 'Masukkan nama lengkap',
              icon: Icons.person_outline,
              controller: vm.fullNameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              validator: Validators.fullName,
            ),
          ),
          const SizedBox(height: 16),
          _buildFieldCard(
            AuthTextField(
              label: 'Tanggal Lahir',
              hint: 'Pilih tanggal lahir',
              icon: Icons.calendar_today_outlined,
              controller: vm.birthDateController,
              readOnly: true,
              onTap: _pickBirthDate,
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              validator: Validators.birthDate,
            ),
          ),
          const SizedBox(height: 16),
          _buildFieldCard(
            // Ikon centang muncul saat nomor sudah valid.
            ListenableBuilder(
              listenable: vm.phoneController,
              builder: (_, __) => AuthTextField(
                label: 'Nomor WhatsApp Siswa',
                hint: '+62 8xx-xxxx-xxxx',
                icon: Icons.phone_outlined,
                controller: vm.phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                borderRadius: 100,
                labelColor: LoginColors.textMuted,
                hintColor: LoginColors.dividerLabel,
                validator: Validators.phone,
                suffix: Validators.phone(vm.phoneController.text) == null
                    ? const Icon(Icons.check_circle_outline, size: 15, color: LoginColors.link)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildFieldCard(
            AuthTextField(
              label: 'Asal Sekolah',
              hint: 'contoh: SMA Negeri 70 Jakarta',
              icon: Icons.school_outlined,
              controller: vm.schoolController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              validator: (v) => Validators.notEmpty(v, 'Asal sekolah'),
            ),
          ),
          const SizedBox(height: 16),
          _buildFieldCard(
            AuthTextField(
              label: 'Jenjang',
              hint: 'Pilih jenjang',
              icon: Icons.account_balance_outlined,
              controller: vm.levelController,
              readOnly: true,
              onTap: _pickLevel,
              suffix: chevron,
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              validator: (v) => Validators.notEmpty(v, 'Jenjang'),
            ),
          ),
          const SizedBox(height: 16),
          _buildFieldCard(
            AuthTextField(
              label: 'Kelas',
              hint: 'Pilih kelas',
              icon: Icons.class_outlined,
              controller: vm.classController,
              readOnly: true,
              onTap: _pickClass,
              suffix: chevron,
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              validator: (v) => Validators.notEmpty(v, 'Kelas'),
            ),
          ),
          const SizedBox(height: 16),
          _buildFieldCard(
            AuthTextField(
              label: 'Kota / Kabupaten',
              hint: 'contoh: Tangerang',
              icon: Icons.location_on_outlined,
              controller: vm.cityController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              validator: (v) => Validators.notEmpty(v, 'Kota / Kabupaten'),
              onFieldSubmitted: (_) => _submit(),
            ),
          ),
          if (vm.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              vm.errorMessage!,
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: LoginColors.error),
            ),
          ],
          const SizedBox(height: 32),
          _buildSubmitButton(vm),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 11, color: LoginColors.textMuted),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Data terlindungi dengan enkripsi 256-bit standar nasional',
                  textAlign: TextAlign.center,
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

  Widget _buildSubmitButton(InformasiPribadiViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: vm.isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: LoginColors.buttonDark,
          disabledBackgroundColor: LoginColors.buttonDark.withValues(alpha: 0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: vm.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Simpan & Selesai',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                ],
              ),
      ),
    );
  }
}