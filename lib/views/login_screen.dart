import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../utils/theme.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/app_header.dart';
import '../widgets/neo_button.dart';
import '../widgets/neo_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _remember = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Email wajib diisi.';
    final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
    if (!isValid) return 'Format email belum benar. Contoh: siswa@sekolah.sch.id';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi wajib diisi.';
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final auth = context.read<AuthViewModel>();
    auth.clearError();

    if (!_formKey.currentState!.validate()) return;

    await auth.login(
      email: _emailController.text,
      password: _passwordController.text,
      remember: _remember,
    );
    // Jika berhasil, _AuthGate di main.dart otomatis menampilkan HomeScreen.
    // Jika gagal, pesan error tampil lewat auth.errorMessage.
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature belum tersedia.')));
  }

  void _openRegister() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'LOGIN SISWA'),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(22, 21, 22, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      children: [
                        const _Logo(),
                        const SizedBox(height: 16),
                        Text(
                          'MASUK AKUN',
                          style: AppText.mono(
                            size: 24,
                            letterSpacing: 1.2,
                            height: 32 / 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Masuk untuk melanjutkan asesmen minat &\nbakatmu di zona arkade!',
                          textAlign: TextAlign.center,
                          style: AppText.body(
                            size: 13,
                            color: AppColors.brown,
                            height: 18 / 13,
                          ),
                        ),
                        const SizedBox(height: 36),
                        _buildFormCard(auth),
                        const SizedBox(height: 36),
                        _buildBottomSection(auth),
                        if (useMock) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Mode mock aktif. Coba: $mockEmail / $mockPassword',
                            textAlign: TextAlign.center,
                            style: AppText.body(
                              size: 11,
                              color: AppColors.brown,
                            ),
                          ),
                        ],
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

  Widget _buildFormCard(AuthViewModel auth) {
    final isLoading = auth.isLoading;

    return Form(
      key: _formKey,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: neoBox(color: AppColors.pink, shadow: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Email ----
                const _FieldLabel(icon: Icons.mail_outline, text: 'EMAIL'),
                const SizedBox(height: 6),
                NeoTextField(
                  controller: _emailController,
                  hint: 'siswa@sekolah.sch.id',
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),

                // ---- Kata sandi ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _FieldLabel(
                      icon: Icons.lock_outline,
                      text: 'KATA SANDI',
                    ),
                    InkWell(
                      onTap: () => _showComingSoon('Pemulihan kata sandi'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.help_outline,
                            size: 11,
                            color: AppColors.ink,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Lupa Sandi?',
                            style: AppText.mono(
                              size: 10,
                              letterSpacing: 0.4,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                NeoTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: _obscurePassword,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  onSubmitted: (_) => _submit(),
                  validator: _validatePassword,
                  suffix: Semantics(
                    button: true,
                    label: _obscurePassword
                        ? 'Tampilkan kata sandi'
                        : 'Sembunyikan kata sandi',
                    child: InkWell(
                      onTap: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.ink, width: 2),
                        ),
                        child: Text(
                          _obscurePassword ? 'SHOW' : 'HIDE',
                          style: AppText.mono(size: 10, letterSpacing: 0.4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---- Ingat saya ----
                Semantics(
                  checked: _remember,
                  label: 'Ingat data pemain di perangkat ini',
                  child: InkWell(
                    onTap: isLoading
                        ? null
                        : () => setState(() => _remember = !_remember),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(2.5),
                              border: _remember
                                  ? Border.all(color: AppColors.ink, width: 2)
                                  : null,
                            ),
                            child: _remember
                                ? const Icon(
                                    Icons.check,
                                    size: 11,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ingat data pemain di perangkat ini',
                              style: AppText.body(size: 13, height: 18 / 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ---- Pesan error dari server ----
                if (auth.errorMessage != null) ...[
                  Semantics(
                    liveRegion: true,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.red, width: 2),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 18,
                            color: AppColors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              auth.errorMessage!,
                              style: AppText.body(
                                size: 13,
                                color: AppColors.red,
                                weight: FontWeight.w700,
                                height: 18 / 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // ---- Tombol masuk ----
                NeoButton(
                  label: 'MASUK SEKARANG',
                  icon: Icons.arrow_forward,
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
          Positioned(
            top: -10,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              color: AppColors.ink,
              child: Text(
                'PLAYER 1 LOGIN',
                style: AppText.mono(
                  size: 10,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  height: 14 / 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(AuthViewModel auth) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            Text(
              'Belum punya akun asesmen?',
              style: AppText.body(size: 15, height: 22 / 15),
            ),
            InkWell(
              onTap: auth.isLoading ? null : _openRegister,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Daftar Sekarang',
                  style: AppText.mono(
                    size: 14,
                    color: AppColors.red,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Container(height: 2, color: AppColors.ink)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OPSI LAIN',
                style: AppText.mono(size: 10, letterSpacing: 0.4),
              ),
            ),
            Expanded(child: Container(height: 2, color: AppColors.ink)),
          ],
        ),
        const SizedBox(height: 16),
        NeoButton(
          label: 'MASUK DENGAN AKUN SEKOLAH (SSO)',
          icon: Icons.school_outlined,
          iconAtEnd: false,
          color: AppColors.lavender,
          textColor: AppColors.ink,
          fontSize: 12,
          letterSpacing: 0.6,
          verticalPadding: 12,
          onPressed:
              auth.isLoading ? null : () => _showComingSoon('Login SSO sekolah'),
        ),
      ],
    );
  }
}

/// Label kecil dengan ikon di atas kolom input.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.ink),
        const SizedBox(width: 6),
        Text(text, style: AppText.mono(size: 12, letterSpacing: 0.48)),
      ],
    );
  }
}

/// Logo kotak miring dengan lencana "XP+".
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    const degree = math.pi / 180;

    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Transform.rotate(
            angle: -2 * degree,
            child: Container(
              width: 64,
              height: 64,
              decoration: neoBox(color: AppColors.lavender, shadow: 4),
              child: Transform.rotate(
                angle: 2 * degree,
                child: const Icon(
                  Icons.sports_esports,
                  size: 30,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
          Positioned(
            top: -7,
            right: -11,
            child: Transform.rotate(
              angle: 6 * degree,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: neoBox(color: AppColors.amber, shadow: 2),
                child: Text(
                  'XP+',
                  style: AppText.mono(
                    size: 10,
                    letterSpacing: 0.4,
                    height: 14 / 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}