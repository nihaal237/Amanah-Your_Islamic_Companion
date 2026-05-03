// lib/features/auth/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/api_constants.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _user != null;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  // ── Login ──────────────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await ApiService.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      final data = response.data;
      await StorageService.saveTokens(
        data['tokens']['access'],
        data['tokens']['refresh'],
      );
      _user = data['user'];
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_parseError(e));
      return false;
    }
  }

  // ── Register ───────────────────────────────────────────────────────────
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    String? city,
    String? age,
    String? gender,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await ApiService.post(
        ApiConstants.register,
        data: {
          'full_name': fullName,
          'email': email,
          'password': password,
          if (city != null && city.isNotEmpty) 'city': city,
          if (age != null && age.isNotEmpty) 'age': int.tryParse(age),
          if (gender != null && gender.isNotEmpty) 'gender': gender,
        },
      );
      final data = response.data;
      await StorageService.saveTokens(
        data['tokens']['access'],
        data['tokens']['refresh'],
      );
      _user = data['user'];
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_parseError(e));
      return false;
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────
  Future<void> logout() async {
    _setLoading(true);
    try {
      final refresh = await StorageService.getRefreshToken();
      if (refresh != null) {
        await ApiService.post(ApiConstants.logout, data: {'refresh': refresh});
      }
    } catch (_) {
      // Ignore errors — still clear local tokens
    }
    await StorageService.clearTokens();
    _user = null;
    _setLoading(false);
  }

  // ── Load profile (call on app start if token exists) ──────────────────
  Future<void> loadProfile() async {
    try {
      final token = await StorageService.getAccessToken();
      if (token == null) return;
      final response = await ApiService.get(ApiConstants.profile);
      _user = response.data;
      notifyListeners();
    } catch (_) {
      await StorageService.clearTokens();
    }
  }

  // ── Change Password ────────────────────────────────────────────────────
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await ApiService.post(
        ApiConstants.changePassword,
        data: {'old_password': oldPassword, 'new_password': newPassword},
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_parseError(e));
      return false;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────
  String _parseError(dynamic e) {
    try {
      final response = (e as dynamic).response;
      if (response != null) {
        final data = response.data;
        if (data is Map) {
          // Django REST returns errors as {"detail": "..."} or {"email": [...]}
          if (data.containsKey('detail')) return data['detail'].toString();
          final firstKey = data.keys.first;
          final firstVal = data[firstKey];
          if (firstVal is List) return firstVal.first.toString();
          return firstVal.toString();
        }
      }
    } catch (_) {}
    return 'Something went wrong. Please try again.';
  }
}