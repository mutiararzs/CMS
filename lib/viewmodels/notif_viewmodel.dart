import 'package:flutter/material.dart';

enum NotifikasiKategori { asesmen, akademik }

class NotifikasiItem {
  final String id;
  final IconData icon;
  final String title;
  final String body;
  final DateTime createdAt;

  /// Label kecil di sebelah waktu, mis. "Asesmen Minat".
  final String tag;
  final NotifikasiKategori kategori;
  final bool isRead;

  const NotifikasiItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.tag,
    required this.kategori,
    this.isRead = false,
  });

  bool get isUnread => !isRead;

  NotifikasiItem copyWith({bool? isRead}) => NotifikasiItem(
        id: id,
        icon: icon,
        title: title,
        body: body,
        createdAt: createdAt,
        tag: tag,
        kategori: kategori,
        isRead: isRead ?? this.isRead,
      );

  String get timeText {
    final d = DateTime.now().difference(createdAt);
    if (d.inMinutes < 1) return 'Baru saja';
    if (d.inMinutes < 60) return '${d.inMinutes}m yang lalu';
    if (d.inHours < 24) return '${d.inHours}j yang lalu';
    return '${d.inDays} hari yang lalu';
  }
}

class NotifikasiViewModel extends ChangeNotifier {
  // TODO: ganti data dummy ini dengan data dari REST API (GET /notifications).
  List<NotifikasiItem> _items = _dummyItems();

  NotifikasiKategori? _filter; // null = Semua
  bool _disposed = false;

  static List<NotifikasiItem> _dummyItems() {
    final now = DateTime.now();
    return [
      NotifikasiItem(
        id: 'n1',
        icon: Icons.assignment_turned_in_outlined,
        title: 'Hasil Asesmen Siap!',
        body: 'Laporan analisis minat RIASEC kamu sudah dapat diunduh lengkap…',
        createdAt: now.subtract(const Duration(minutes: 10)),
        tag: 'Asesmen Minat',
        kategori: NotifikasiKategori.asesmen,
      ),
      NotifikasiItem(
        id: 'n2',
        icon: Icons.notifications_active_outlined,
        title: 'Pengingat Tes',
        body: 'Selesaikan Tes Nilai Kerja untuk melengkapi rekomendasi kariermu…',
        createdAt: now.subtract(const Duration(hours: 2)),
        tag: 'Batas Waktu',
        kategori: NotifikasiKategori.asesmen,
      ),
      NotifikasiItem(
        id: 'n3',
        icon: Icons.school_outlined,
        title: 'Rekomendasi Jurusan Baru',
        body: 'Jurusan Sains Data dan Kecerdasan Artifisial telah ditambahkan ke katalog',
        createdAt: now.subtract(const Duration(days: 3)),
        tag: 'Eksplorasi',
        kategori: NotifikasiKategori.akademik,
        isRead: true,
      ),
    ];
  }

  NotifikasiKategori? get filter => _filter;

  /// Jumlah belum dibaca di seluruh kategori (angka di chip "Semua").
  int get unreadCount => _items.where((e) => e.isUnread).length;
  bool get hasUnread => unreadCount > 0;

  List<NotifikasiItem> get _visible {
    final list = _filter == null
        ? List<NotifikasiItem>.of(_items)
        : _items.where((e) => e.kategori == _filter).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// "Hari ini" = kurang dari 24 jam terakhir.
  List<NotifikasiItem> get todayItems => _visible
      .where((e) => DateTime.now().difference(e.createdAt).inHours < 24)
      .toList();

  /// "Minggu ini" = 24 jam sampai 7 hari terakhir.
  List<NotifikasiItem> get weekItems => _visible.where((e) {
        final d = DateTime.now().difference(e.createdAt);
        return d.inHours >= 24 && d.inDays < 7;
      }).toList();

  int get todayUnreadCount => todayItems.where((e) => e.isUnread).length;
  bool get isEmpty => todayItems.isEmpty && weekItems.isEmpty;

  void setFilter(NotifikasiKategori? value) {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
  }

  void markRead(String id) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0 || _items[i].isRead) return;
    // TODO: PATCH /notifications/{id}/read
    _items[i] = _items[i].copyWith(isRead: true);
    notifyListeners();
  }

  void markAllRead() {
    if (!hasUnread) return;
    // TODO: PATCH /notifications/read-all
    _items = [for (final e in _items) e.copyWith(isRead: true)];
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}