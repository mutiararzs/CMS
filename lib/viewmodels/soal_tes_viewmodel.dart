import 'package:flutter/material.dart';

class RiasecQuestion {
  final String category; // R, I, A, S, E, C
  final String text;

  const RiasecQuestion(this.category, this.text);

  String get categoryLabel => switch (category) {
        'R' => 'REALISTIC (R)',
        'I' => 'INVESTIGATIVE (I)',
        'A' => 'ARTISTIC (A)',
        'S' => 'SOCIAL (S)',
        'E' => 'ENTERPRISING (E)',
        _ => 'CONVENTIONAL (C)',
      };
}

class SoalTesViewModel extends ChangeNotifier {
  // TODO: ganti bank soal ini dengan data dari REST API saat backend siap.
  static const scaleLabels = [
    'Sangat Tidak Suka',
    'Tidak Suka',
    'Netral / Ragu-ragu',
    'Suka',
    'Sangat Suka',
  ];

  static const pageSize = 10;

  static const _bank = <String, List<String>>{
    'I': [
      'Saya menikmati memecahkan masalah teka-teki logika, menganalisis struktur data sistem, atau meneliti mengapa sebuah program komputer mengalami bug.',
      'Saya penasaran dan suka mencari tahu penjelasan ilmiah di balik suatu fenomena.',
      'Saya senang melakukan percobaan atau eksperimen di laboratorium.',
      'Saya menikmati membaca artikel sains atau teknologi.',
      'Saya suka menganalisis data untuk menemukan pola.',
      'Saya senang mempelajari matematika dan memecahkan soal yang rumit.',
      'Saya tertarik meneliti penyebab suatu masalah secara mendalam.',
      'Saya lebih suka bekerja dengan ide dan teori daripada rutinitas.',
      'Saya menikmati belajar hal baru yang menantang pikiran.',
      'Saya senang merancang rencana riset atau penyelidikan sendiri.',
    ],
    'R': [
      'Saya menikmati memperbaiki atau merakit peralatan mekanik dan elektronik.',
      'Saya senang bekerja dengan alat-alat tangan dan mesin.',
      'Saya suka beraktivitas di luar ruangan seperti berkebun atau berkemah.',
      'Saya menikmati membangun sesuatu dengan tangan sendiri.',
      'Saya tertarik mengendarai atau mengoperasikan kendaraan dan mesin berat.',
      'Saya senang merawat hewan atau tanaman.',
      'Saya lebih suka pekerjaan yang hasilnya nyata dan bisa dilihat langsung.',
      'Saya menikmati kegiatan fisik seperti olahraga atau pekerjaan lapangan.',
      'Saya tertarik mempelajari cara kerja mesin dan peralatan teknik.',
      'Saya senang memasang instalasi seperti kabel, pipa, atau perabot.',
    ],
    'A': [
      'Saya menikmati menggambar, melukis, atau mendesain sesuatu.',
      'Saya senang menulis cerita, puisi, atau lirik lagu.',
      'Saya suka bermain atau menciptakan musik.',
      'Saya senang tampil di depan orang, seperti bermain drama atau menari.',
      'Saya tertarik pada fotografi, film, atau desain visual.',
      'Saya lebih suka pekerjaan yang memberi kebebasan berkreasi.',
      'Saya sering memiliki ide orisinal yang berbeda dari orang lain.',
      'Saya menikmati mengunjungi museum, galeri, atau pertunjukan seni.',
      'Saya peka terhadap keindahan warna, bentuk, dan suara.',
      'Saya senang mendekorasi ruangan atau menata penampilan dengan gaya sendiri.',
    ],
    'S': [
      'Saya senang membantu orang lain yang sedang kesulitan.',
      'Saya menikmati mengajar atau menjelaskan sesuatu kepada teman.',
      'Saya mudah mendengarkan dan memahami perasaan orang lain.',
      'Saya tertarik ikut kegiatan sosial atau menjadi relawan.',
      'Saya senang bekerja dalam tim dan membangun kerja sama.',
      'Saya suka menjadi tempat teman bercerita atau meminta saran.',
      'Saya tertarik pada pekerjaan di bidang pendidikan, kesehatan, atau konseling.',
      'Saya senang membantu menyelesaikan konflik antar teman dengan damai.',
      'Saya menikmati merawat dan mendampingi orang yang membutuhkan.',
      'Saya mudah akrab dengan orang baru.',
    ],
    'E': [
      'Saya suka memimpin kelompok atau mengorganisasi kegiatan.',
      'Saya senang meyakinkan orang lain untuk menyetujui ide saya.',
      'Saya tertarik memulai usaha atau bisnis sendiri.',
      'Saya berani mengambil risiko demi mencapai target.',
      'Saya menikmati berbicara di depan umum atau berdebat.',
      'Saya senang bernegosiasi dan mencari kesepakatan terbaik.',
      'Saya termotivasi oleh persaingan dan pencapaian.',
      'Saya suka mengambil keputusan penting untuk kelompok.',
      'Saya tertarik pada dunia penjualan, pemasaran, atau politik.',
      'Saya senang memengaruhi arah suatu proyek atau organisasi.',
    ],
    'C': [
      'Saya senang menyusun data atau dokumen secara rapi dan teratur.',
      'Saya suka mengikuti prosedur dan aturan yang jelas.',
      'Saya teliti memeriksa detail agar tidak ada kesalahan.',
      'Saya menikmati mencatat dan mengelola keuangan atau administrasi.',
      'Saya lebih nyaman dengan jadwal dan rencana yang terstruktur.',
      'Saya senang bekerja dengan angka, tabel, dan spreadsheet.',
      'Saya suka merapikan arsip, file, atau barang agar mudah ditemukan.',
      'Saya lebih suka tugas dengan instruksi yang jelas.',
      'Saya menikmati pekerjaan yang rutin dan dapat diprediksi.',
      'Saya merasa puas ketika pekerjaan selesai tepat waktu dan sesuai aturan.',
    ],
  };

  /// 60 soal: diselang-seling per kategori (I, R, A, S, E, C).
  late final List<RiasecQuestion> questions = [
    for (var i = 0; i < 10; i++)
      for (final c in const ['I', 'R', 'A', 'S', 'E', 'C'])
        RiasecQuestion(c, _bank[c]![i]),
  ];

  late final List<int?> _answers = List<int?>.filled(questions.length, null);
  int _index = 0;
  bool _isSubmitting = false;
  bool _disposed = false;

  int get total => questions.length;
  int get index => _index;
  RiasecQuestion get current => questions[_index];
  int? get currentAnswer => _answers[_index];
  bool get isFirst => _index == 0;
  bool get isLast => _index == total - 1;
  bool get isSubmitting => _isSubmitting;
  int get answeredCount => _answers.where((a) => a != null).length;
  int get unansweredCount => total - answeredCount;

  bool isAnswered(int i) => _answers[i] != null;

  /// Rentang nomor soal yang ditampilkan di panel "Nomor Soal".
  int get pageStart => (_index ~/ pageSize) * pageSize;
  int get pageEnd => (pageStart + pageSize).clamp(0, total);

  void selectAnswer(int value) {
    // TODO: simpan otomatis ke server (PUT /assessments/{id}/answers).
    _answers[_index] = value;
    notifyListeners();
  }

  void next() {
    if (isLast) return;
    _index++;
    notifyListeners();
  }

  void previous() {
    if (isFirst) return;
    _index--;
    notifyListeners();
  }

  void goTo(int i) {
    if (i < 0 || i >= total || i == _index) return;
    _index = i;
    notifyListeners();
  }

  /// Mengembalikan true jika seluruh jawaban berhasil dikirim.
  Future<bool> submit() async {
    if (_isSubmitting || unansweredCount > 0) return false;
    _isSubmitting = true;
    notifyListeners();
    try {
      // TODO: POST /assessments/riasec/submit via Dio.
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
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