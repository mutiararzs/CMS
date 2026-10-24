import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/login_colors.dart';
import '../utils/validators.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/register_viewmodel.dart';
import '../viewmodels/riwayat_viewmodel.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_button.dart';
import 'home_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final vm = context.read<LoginViewModel>();
    final ok = await vm.login();
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => HomeViewModel()),
              ChangeNotifierProvider(create: (_) => RiwayatViewModel()),
              ChangeNotifierProvider(create: (_) => ProfileViewModel()),
            ],
            child: const HomeView(),
          ),
        ),
      );
    }
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature belum tersedia')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: LoginColors.background,
      body: Stack(
        children: [
          // Lingkaran cahaya biru di belakang logo
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
                      const SizedBox(height: 24),
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
        Image.asset(
          'assets/images/logo-peta-masa-depanku.png',
          width: 104,
          height: 104,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.explore,
            size: 104,
            color: LoginColors.link,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Selamat Datang Kembali',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.55,
            color: LoginColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Masuk untuk melanjutkan asesmen minat\n& bakat Anda',
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

  Widget _buildFormCard(LoginViewModel vm) {
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
              label: 'Email Siswa',
              hint: 'Masukkan email terdaftar',
              icon: Icons.mail_outline,
              controller: vm.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              label: 'Kata Sandi',
              hint: 'Minimal 8 karakter',
              icon: Icons.lock_outline,
              controller: vm.passwordController,
              obscureText: vm.obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: Validators.password,
              onFieldSubmitted: (_) => _submit(),
              suffix: IconButton(
                tooltip: vm.obscurePassword
                    ? 'Tampilkan kata sandi'
                    : 'Sembunyikan kata sandi',
                icon: Icon(
                  vm.obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: LoginColors.textMuted,
                ),
                onPressed: vm.togglePasswordVisibility,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => vm.toggleRememberMe(!vm.rememberMe),
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: Checkbox(
                          value: vm.rememberMe,
                          onChanged: vm.toggleRememberMe,
                          activeColor: LoginColors.link,
                          side: const BorderSide(color: LoginColors.checkboxBorder),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5)),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ingat Saya',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: LoginColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _comingSoon('Lupa kata sandi'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Lupa Kata Sandi?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: LoginColors.link,
                    ),
                  ),
                ),
              ],
            ),
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
            const SizedBox(height: 24),
            _buildSubmitButton(vm),
            const SizedBox(height: 28),
            _buildDivider(),
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
      ),
    );
  }

  Widget _buildSubmitButton(LoginViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: vm.isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.black54,
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
                    'Masuk',
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

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: LoginColors.divider, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'ATAU MASUK DENGAN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: LoginColors.dividerLabel,
            ),
          ),
        ),
        const Expanded(child: Divider(color: LoginColors.divider, thickness: 1)),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Belum punya akun?',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: LoginColors.textMuted),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => RegisterViewModel(),
                child: const RegisterView(),
              ),
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Daftar Sekarang',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: LoginColors.link,
            ),
          ),
        ),
      ],
    );
  }
}