import 'package:flutter/material.dart';

class InformasiPribadiViewModel extends ChangeNotifier {
  // TODO: ganti data awal dan proses simpan dengan REST API saat backend siap.
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController(text: 'Rizky Pratama');
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController(text: '+62 812-3456-7890');
  final schoolController = TextEditingController(text: 'SMA Negeri 70 Jakarta');
  final levelController = TextEditingController(text: 'SMA');
  final classController = TextEditingController(text: '12 IPA 1');
  final cityController = TextEditingController(text: 'Tangerang');

  static const levelOptions = ['SMA', 'SMK', 'MA'];
  static final classOptions = [
    for (final grade in [10, 11, 12])
      for (final program in ['IPA', 'IPS'])
        '$grade $program'
  ];

  DateTime? _birthDate = DateTime(2007, 5, 15);
  bool _isLoading = false;
  bool _disposed = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get birthDate => _birthDate;

  InformasiPribadiViewModel() {
    birthDateController.text = _formatDate(_birthDate!);
  }

  void setBirthDate(DateTime date) {
    _birthDate = date;
    birthDateController.text = _formatDate(date);
    notifyListeners();
  }

  void setLevel(String value) {
    levelController.text = value;
    notifyListeners();
  }

  void setClass(String value) {
    classController.text = value;
    notifyListeners();
  }

  /// Mengembalikan true jika data berhasil disimpan.
  Future<bool> save() async {
    if (_isLoading) return false;
    if (!(formKey.currentState?.validate() ?? false)) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: PUT /profile via Dio.
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    } catch (_) {
      _errorMessage = 'Gagal menyimpan. Periksa koneksi internet lalu coba lagi.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    fullNameController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    schoolController.dispose();
    levelController.dispose();
    classController.dispose();
    cityController.dispose();
    super.dispose();
  }
}