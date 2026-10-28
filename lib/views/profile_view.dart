import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/login_colors.dart';
import '../widgets/app_logo.dart';
import '../viewmodels/infoprib_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import 'infoprib_view.dart';
import 'login_view.dart';

/// Isi tab "Profil". Ditampilkan di dalam HomeView (tanpa Scaffold sendiri).
class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  static const _chipBlue = Color(0xFFCAE6FF);
  static const _chipBlueText = Color(0xFF004B70);
  static const _logoutBg = Color(0xFFFFDAD6);
  static const _logoutText = Color(0xFF93000A);

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature belum tersedia')),
    );
  }

  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: LoginColors.background,
        title: Text(
          'Keluar dari akun?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: LoginColors.textDark,
          ),
        ),
        content: Text(
          'Kamu perlu masuk lagi untuk melanjutkan asesmen.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: LoginColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar', style: TextStyle(color: _logoutText)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    // TODO: hapus token/sesi login saat backend siap.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileCard(vm),
                const SizedBox(height: 16),
                _buildLastTestCard(vm),
                const SizedBox(height: 16),
                _buildSettings(),
                const SizedBox(height: 24),
                _buildLogout(vm),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppLogo(size: 32),
                const SizedBox(width: 8),
                Text(
                  'Profil',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    height: 26 / 18,
                    fontWeight: FontWeight.w600,
                    color: LoginColors.textDark,
                  ),
                ),
              ],
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: LoginColors.avatarBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 18, color: LoginColors.link),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(ProfileViewModel vm) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          _buildAvatar(),
          const SizedBox(height: 16),
          Text(
            vm.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              height: 30 / 22,
              fontWeight: FontWeight.w700,
              color: LoginColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            vm.studentInfo,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: LoginColors.link,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFC5C6CD),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  vm.school,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 18 / 12,
                    color: LoginColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            runSpacing: 4,
            children: [
              _buildBadge(
                icon: Icons.verified_outlined,
                label: 'Akun Terverifikasi',
                bg: LoginColors.avatarBg,
                textColor: LoginColors.textDark,
              ),
              _buildBadge(
                icon: Icons.bolt_rounded,
                label: '${vm.completedCount} Asesmen Selesai',
                bg: _chipBlue,
                textColor: _chipBlueText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: 144,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Cahaya biru di belakang avatar
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              width: 144,
              height: 144,
              decoration: BoxDecoration(
                color: LoginColors.accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 112,
            height: 112,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: LoginColors.iconButtonBg,
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: LoginColors.avatarBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 64, color: LoginColors.link),
            ),
          ),
          Positioned(
            right: 144 / 2 - 56 - 4,
            bottom: 0,
            child: Material(
              color: LoginColors.accent,
              shape: const CircleBorder(
                side: BorderSide(color: Colors.white, width: 2),
              ),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _comingSoon('Ubah foto profil'),
                child: const SizedBox(
                  width: 28,
                  height: 28,
                  child: Icon(Icons.photo_camera_outlined, size: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color bg,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.33, color: LoginColors.link),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastTestCard(ProfileViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LoginColors.card,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_rounded, size: 16, color: LoginColors.link),
                    const SizedBox(width: 8),
                    Text(
                      'Tes Terakhir Diambil',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: LoginColors.textDark,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: LoginColors.divider,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Terbaru',
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
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: LoginColors.link,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.psychology_alt_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vm.lastTestTitle,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                height: 20 / 16,
                                fontWeight: FontWeight.w600,
                                color: LoginColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 11,
                                  color: LoginColors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  vm.lastTestDate,
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      vm.lastTestLevel,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: LoginColors.link,
                      ),
                    ),
                    Text(
                      vm.lastTestType,
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
          ),
          const SizedBox(height: 4),
          Material(
            color: LoginColors.avatarBg,
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => _comingSoon('Ringkasan hasil'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lihat Ringkasan Hasil',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: LoginColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 12, color: LoginColors.textDark),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'PENGATURAN PROFIL',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: LoginColors.textMuted,
              color: LoginColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 4),
        _buildSettingItem(
          icon: Icons.person_outline_rounded,
          title: 'Informasi Pribadi',
          subtitle: 'Biodata diri',
          radius: const BorderRadius.vertical(
            top: Radius.circular(24),
            bottom: Radius.circular(8),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => InformasiPribadiViewModel(),
                child: const InformasiPribadiView(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        _buildSettingItem(
          icon: Icons.lock_outline_rounded,
          title: 'Ubah Kata Sandi & Keamanan',
          subtitle: 'PIN asesmen & otentikasi akun',
          radius: const BorderRadius.vertical(
            top: Radius.circular(8),
            bottom: Radius.circular(24),
          ),
          onTap: () => _comingSoon('Keamanan akun'),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required BorderRadius radius,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: LoginColors.iconButtonBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: LoginColors.textDark),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 2),
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
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: LoginColors.dividerLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogout(ProfileViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Material(
              color: _logoutBg,
              shape: const StadiumBorder(),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: _confirmLogout,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, size: 15, color: _logoutText),
                      const SizedBox(width: 8),
                      Text(
                        'Keluar dari Akun',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _logoutText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vm.appVersion,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 18 / 12,
              color: LoginColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}