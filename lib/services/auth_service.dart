import '../models/login_request.dart';
import '../models/register_request.dart';

/// Service mock. Ganti isinya dengan pemanggilan API sungguhan nanti
/// (mis. dengan package `dio` / `http`).
class AuthService {
  Future<bool> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> register(RegisterRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> loginWithSocial(String providerName) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}