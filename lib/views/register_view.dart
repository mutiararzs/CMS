import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/login_colors.dart';
import '../widgets/app_logo.dart';
import '../utils/validators.dart';
import '../viewmodels/register_viewmodel.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()
      ..onTap = () => _comingSoon('Ketentuan Layanan');
    _privacyTap = TapGestureRecognizer()
      ..onTap = () => _comingSoon('Kebijakan Privasi');
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature belum tersedia')),
    );
  }

  void _goToLogin() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  Future<void> _pickBirthDate() async {
    final vm = context.read<RegisterViewModel>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 16, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
      helpText: 'Pilih tanggal lahir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (picked != null) vm.setBirthDate(picked);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final vm = context.read<RegisterViewModel>();
    final ok = await vm.register();
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendaftaran berhasil. Silakan masuk.')),
      );
      _goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Scaffold(
      backgroundColor: LoginColors.background,
      body: Stack(
        children: [
          Positioned(
            top: 43,
            left: 105,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
              child: Container(
                width: 192,
                height: 192,
                decoration: const BoxDecoration(
                  color: LoginColors.glow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildFormCard(vm),
                      const SizedBox(height: 16),
                      _buildSocialCard(),
                      const SizedBox(height: 16),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AppLogo(size: 104),
        const SizedBox(height: 24),
        Text(
          'Buat Akun Baru',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            height: 34 / 26,
            fontWeight: FontWeight.w700,
            color: LoginColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Daftarkan diri Anda untuk menemukan potensi\nterbaik Anda',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 22 / 14,
            color: LoginColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(RegisterViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LoginColors.card,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Form(
        key: vm.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthTextField(
              label: 'Nama Lengkap',
              hint: 'cth. Arya Putra Pratama',
              icon: Icons.person_outline,
              controller: vm.fullNameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              validator: Validators.fullName,
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              labelIndent: 4,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              label: 'Tanggal Lahir',
              hint: 'dd/mm/yyyy',
              icon: Icons.calendar_today_outlined,
              controller: vm.birthDateController,
              readOnly: true,
              onTap: _pickBirthDate,
              validator: Validators.birthDate,
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              labelIndent: 4,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              label: 'Email Siswa',
              hint: 'nama@sekolah.sch.id',
              icon: Icons.mail_outline,
              controller: vm.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email,
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              labelIndent: 4,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              label: 'Kata Sandi',
              hint: 'Minimal 8 karakter',
              icon: Icons.lock_outline,
              controller: vm.passwordController,
              obscureText: vm.obscurePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: Validators.password,
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              labelIndent: 4,
              suffix: IconButton(
                tooltip: vm.obscurePassword
                    ? 'Tampilkan kata sandi'
                    : 'Sembunyikan kata sandi',
                icon: Icon(
                  vm.obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: LoginColors.dividerLabel,
                ),
                onPressed: vm.togglePasswordVisibility,
              ),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              label: 'Konfirmasi Kata Sandi',
              hint: 'Ulangi kata sandi',
              icon: Icons.lock_outline,
              controller: vm.confirmPasswordController,
              obscureText: vm.obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  Validators.confirmPassword(v, vm.passwordController.text),
              onFieldSubmitted: (_) => _submit(),
              borderRadius: 100,
              labelColor: LoginColors.textMuted,
              hintColor: LoginColors.dividerLabel,
              labelIndent: 4,
              suffix: IconButton(
                tooltip: vm.obscureConfirmPassword
                    ? 'Tampilkan kata sandi'
                    : 'Sembunyikan kata sandi',
                icon: Icon(
                  vm.obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: LoginColors.dividerLabel,
                ),
                onPressed: vm.toggleConfirmPasswordVisibility,
              ),
            ),
            const SizedBox(height: 16),
            _buildTerms(vm),
            if (vm.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                vm.errorMessage!,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: LoginColors.error,
                ),
              ),
            ],
            const SizedBox(height: 16),
            _buildSubmitButton(vm),
          ],
        ),
      ),
    );
  }

  Widget _buildTerms(RegisterViewModel vm) {
    final base = GoogleFonts.plusJakartaSans(
      fontSize: 12,
      height: 15 / 12,
      color: LoginColors.textMuted,
    );
    final link = base.copyWith(
      color: LoginColors.link,
      decoration: TextDecoration.underline,
      decorationColor: LoginColors.link,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.5),
                ),
                child: Checkbox(
                  value: vm.agreeTerms,
                  onChanged: vm.toggleAgreeTerms,
                  activeColor: LoginColors.link,
                  side: BorderSide(
                    color: vm.termsError
                        ? LoginColors.error
                        : LoginColors.checkboxBorder,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: base,
                  children: [
                    const TextSpan(text: 'Saya menyetujui '),
                    TextSpan(text: 'Ketentuan Layanan', style: link, recognizer: _termsTap),
                    const TextSpan(text: ' & '),
                    TextSpan(text: 'Kebijakan Privasi', style: link, recognizer: _privacyTap),
                    const TextSpan(text: ' asesmen.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (vm.termsError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 30),
            child: Text(
              'Kamu harus menyetujui ketentuan untuk melanjutkan.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: LoginColors.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton(RegisterViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: vm.isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: LoginColors.buttonDark,
          disabledBackgroundColor: LoginColors.buttonDark.withAlpha(150),
          foregroundColor: Colors.white,
          elevation: 3,
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
                    'Daftar Sekarang',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                ],
              ),
      ),
    );
  }

  Widget _buildSocialCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LoginColors.card,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Divider(color: LoginColors.divider, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'ATAU MASUK DENGAN',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    height: 14 / 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: LoginColors.dividerLabel,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: LoginColors.divider, thickness: 1)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SocialButton(
                  label: 'Google',
                  icon: Text(
                    'G',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF4285F4),
                    ),
                  ),
                  onPressed: () => _comingSoon('Masuk dengan Google'),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: SocialButton(
                  label: 'Apple',
                  icon: const Icon(Icons.apple, size: 20, color: Colors.black),
                  onPressed: () => _comingSoon('Masuk dengan Apple'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah punya akun?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 22 / 14,
            color: LoginColors.textMuted,
          ),
        ),
        TextButton(
          onPressed: _goToLogin,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Masuk',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: LoginColors.link,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right, size: 16, color: LoginColors.link),
            ],
          ),
        ),
      ],
    );
  }
}