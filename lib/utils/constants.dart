/// Saklar data palsu.
/// true  = login memakai data mock (tidak butuh backend)
/// false = login memanggil API asli di [baseUrl]
const bool useMock = true;

/// Alamat backend. Tanyakan ke tim backend.
/// 10.0.2.2 = alamat "localhost" laptop jika dijalankan dari emulator Android.
/// Kalau memakai HP asli, ganti dengan IP laptop (misalnya http://192.168.1.10:3000/api).
const String baseUrl = 'http://10.0.2.2:3000/api';

const Duration apiTimeout = Duration(seconds: 15);

/// Akun percobaan untuk mode mock.
const String mockEmail = 'siswa@sekolah.sch.id';
const String mockPassword = 'siswa123';