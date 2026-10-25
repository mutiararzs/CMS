import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/login_colors.dart';
import '../viewmodels/notif_viewmodel.dart';

class NotifikasiView extends StatelessWidget {
  const NotifikasiView({super.key});

  static const _unreadIconBg = Color(0xFFCAE6FF);
  static const _dotMuted = Color(0xFFC5C6CD);

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature belum tersedia')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotifikasiViewModel>();

    return Scaffold(
      backgroundColor: LoginColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                _buildAppBar(context, vm),
                _buildFilters(vm),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (vm.isEmpty)
                          _buildEmpty()
                        else ...[
                          if (vm.todayItems.isNotEmpty)
                            _buildSection(
                              title: 'HARI INI',
                              trailing: vm.todayUnreadCount > 0
                                  ? Text(
                                      '${vm.todayUnreadCount} Baru',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        height: 14 / 10,
                                        fontWeight: FontWeight.w600,
                                        color: LoginColors.link,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              items: vm.todayItems,
                              vm: vm,
                            ),
                          if (vm.weekItems.isNotEmpty)
                            _buildSection(
                              title: 'MINGGU INI',
                              trailing: InkWell(
                                onTap: () => _comingSoon(context, 'Notifikasi terdahulu'),
                                child: Text(
                                  'Terdahulu',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    height: 14 / 10,
                                    fontWeight: FontWeight.w700,
                                    color: LoginColors.dividerLabel,
                                  ),
                                ),
                              ),
                              items: vm.weekItems,
                              vm: vm,
                            ),
                        ],
                        _buildFooter(),
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

  Widget _buildAppBar(BuildContext context, NotifikasiViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: LoginColors.iconButtonBg,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.maybePop(context),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14,
                  color: LoginColors.textDark,
                ),
              ),
            ),
          ),
          Text(
            'Notifikasi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              height: 26 / 18,
              fontWeight: FontWeight.w600,
              color: LoginColors.textDark,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: vm.hasUnread ? vm.markAllRead : null,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                'Tandai Dibaca',
                textAlign: TextAlign.right,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: vm.hasUnread ? LoginColors.link : LoginColors.dividerLabel,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(NotifikasiViewModel vm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 22),
      child: Row(
        children: [
          _buildChip(
            label: 'Semua',
            selected: vm.filter == null,
            badge: vm.unreadCount,
            onTap: () => vm.setFilter(null),
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Asesmen',
            selected: vm.filter == NotifikasiKategori.asesmen,
            onTap: () => vm.setFilter(NotifikasiKategori.asesmen),
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Akademik',
            selected: vm.filter == NotifikasiKategori.akademik,
            onTap: () => vm.setFilter(NotifikasiKategori.akademik),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return Material(
      color: selected ? LoginColors.buttonDark : LoginColors.iconButtonBg,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              if (badge > 0) ...[
                const SizedBox(width: 6),
                Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: LoginColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$badge',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: LoginColors.onAccent,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget trailing,
    required List<NotifikasiItem> items,
    required NotifikasiViewModel vm,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    height: 14 / 10,
                    fontWeight: FontWeight.w700,
                    color: LoginColors.dividerLabel,
                  ),
                ),
                trailing,
              ],
            ),
          ),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _buildCard(items[i], vm),
          ],
        ],
      ),
    );
  }

  Widget _buildCard(NotifikasiItem n, NotifikasiViewModel vm) {
    final unread = n.isUnread;

    return Material(
      color: unread ? LoginColors.card : Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // TODO: arahkan ke halaman terkait (mis. hasil tes) sesuai jenis notifikasi.
        onTap: () => vm.markRead(n.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: unread ? _unreadIconBg : LoginColors.iconButtonBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  n.icon,
                  size: 20,
                  color: unread ? LoginColors.link : LoginColors.textMuted,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: unread ? 16 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                          color: LoginColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        n.body,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          height: 22 / 14,
                          color: LoginColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 11,
                            color: LoginColors.dividerLabel,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            n.timeText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              height: 14 / 10,
                              fontWeight: FontWeight.w700,
                              color: LoginColors.dividerLabel,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: _dotMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              n.tag,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                height: 14 / 10,
                                fontWeight: unread ? FontWeight.w600 : FontWeight.w700,
                                color: unread ? LoginColors.link : LoginColors.dividerLabel,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (unread)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: LoginColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            size: 32,
            color: LoginColors.dividerLabel,
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada notifikasi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: LoginColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LoginColors.iconButtonBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 17, color: LoginColors.link),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Semua pemberitahuan penting telah ditampilkan',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: LoginColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}