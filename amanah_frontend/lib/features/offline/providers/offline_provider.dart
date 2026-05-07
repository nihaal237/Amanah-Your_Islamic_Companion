// lib/features/offline/providers/offline_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';

// ── Model ──────────────────────────────────────────────────────────────────
class OfflineAction {
  final String id;
  final String type;
  final String detail;
  final String loggedAt;
  final Map<String, dynamic> payload;

  const OfflineAction({
    required this.id,
    required this.type,
    required this.detail,
    required this.loggedAt,
    required this.payload,
  });

  factory OfflineAction.fromJson(Map<String, dynamic> json) {
    return OfflineAction(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
      loggedAt: json['loggedAt'] as String? ?? DateTime.now().toIso8601String(),
      payload: (json['payload'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'detail': detail,
        'loggedAt': loggedAt,
        'payload': payload,
      };

  OfflineAction copyWith({
    String? id,
    String? type,
    String? detail,
    String? loggedAt,
    Map<String, dynamic>? payload,
  }) {
    return OfflineAction(
      id: id ?? this.id,
      type: type ?? this.type,
      detail: detail ?? this.detail,
      loggedAt: loggedAt ?? this.loggedAt,
      payload: payload ?? this.payload,
    );
  }
}

// ── Provider ───────────────────────────────────────────────────────────────
class OfflineProvider extends ChangeNotifier {
  static const String _pendingKey = 'offline_pending_queue';
  static const String _syncedKey = 'offline_synced_items';
  static const String _failedKey = 'offline_failed_items';

  // State
  List<OfflineAction> _pendingQueue = [];
  List<OfflineAction> _syncedItems = [];
  List<OfflineAction> _failedItems = [];
  bool _isOnline = true;
  bool _isSyncing = false;

  // Connectivity subscription
  late final Connectivity _connectivity;

  // Public getters
  List<OfflineAction> get pendingQueue => List.unmodifiable(_pendingQueue);
  List<OfflineAction> get syncedItems => List.unmodifiable(_syncedItems);
  List<OfflineAction> get failedItems => List.unmodifiable(_failedItems);
  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;

  OfflineProvider() {
    _connectivity = Connectivity();
    _initConnectivity();
    _listenToConnectivity();
  }

  // ── Initialisation ─────────────────────────────────────────────────────

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isOnline = result != ConnectivityResult.none;
      notifyListeners();
    } catch (e) {
      debugPrint('OfflineProvider: connectivity check failed – $e');
    }
  }

  void _listenToConnectivity() {
    _connectivity.onConnectivityChanged.listen((result) {
      final wasOffline = !_isOnline;
      _isOnline = result != ConnectivityResult.none;
      notifyListeners();

      // Auto-sync when coming back online
      if (wasOffline && _isOnline && _pendingQueue.isNotEmpty) {
        syncNow();
      }
    });
  }

  // ── Persistence ────────────────────────────────────────────────────────

  Future<void> loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _pendingQueue = _decodeList(prefs.getString(_pendingKey));
      _syncedItems = _decodeList(prefs.getString(_syncedKey));
      _failedItems = _decodeList(prefs.getString(_failedKey));

      notifyListeners();
    } catch (e) {
      debugPrint('OfflineProvider: loadQueue error – $e');
    }
  }

  Future<void> _persistAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString(_pendingKey, _encodeList(_pendingQueue)),
        prefs.setString(_syncedKey, _encodeList(_syncedItems)),
        prefs.setString(_failedKey, _encodeList(_failedItems)),
      ]);
    } catch (e) {
      debugPrint('OfflineProvider: persist error – $e');
    }
  }

  List<OfflineAction> _decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => OfflineAction.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  String _encodeList(List<OfflineAction> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  // ── Queue Management ───────────────────────────────────────────────────

  /// Add a new action to the pending queue.
  Future<void> enqueue(OfflineAction action) async {
    _pendingQueue.add(action);
    notifyListeners();
    await _persistAll();

    // If online, attempt an immediate sync
    if (_isOnline) syncNow();
  }

  /// Remove a single pending item by its list index.
  Future<void> removeFromQueue(int index) async {
    if (index < 0 || index >= _pendingQueue.length) return;
    _pendingQueue.removeAt(index);
    notifyListeners();
    await _persistAll();
  }

  /// Clear the entire pending queue without syncing.
  Future<void> clearQueue() async {
    _pendingQueue.clear();
    notifyListeners();
    await _persistAll();
  }

  // ── Sync ───────────────────────────────────────────────────────────────

  Future<void> syncNow() async {
    if (_isSyncing || !_isOnline || _pendingQueue.isEmpty) return;

    _isSyncing = true;
    notifyListeners();

    final toProcess = List<OfflineAction>.from(_pendingQueue);

    for (final action in toProcess) {
      final success = await _dispatchAction(action);
      _pendingQueue.remove(action);

      if (success) {
        // Keep only the 50 most recent synced items
        _syncedItems.insert(0, action);
        if (_syncedItems.length > 50) _syncedItems = _syncedItems.sublist(0, 50);
      } else {
        _failedItems.insert(0, action);
      }

      notifyListeners();
    }

    _isSyncing = false;
    notifyListeners();
    await _persistAll();
  }

  /// Retry all failed items by moving them back to the pending queue.
  Future<void> retryFailed() async {
    if (_failedItems.isEmpty) return;
    _pendingQueue.addAll(_failedItems);
    _failedItems.clear();
    notifyListeners();
    await _persistAll();
    if (_isOnline) syncNow();
  }

  /// Remove a single failed item by its list index.
  Future<void> removeFailedItem(int index) async {
    if (index < 0 || index >= _failedItems.length) return;
    _failedItems.removeAt(index);
    notifyListeners();
    await _persistAll();
  }

  // ── Dispatch ───────────────────────────────────────────────────────────
  // Replace the body of this method with your actual API calls.
  Future<bool> _dispatchAction(OfflineAction action) async {
    try {
      switch (action.type) {
        case 'prayer_log':
          return await _syncPrayerLog(action);
        case 'mood_log':
          return await _syncMoodLog(action);
        case 'goal_complete':
          return await _syncGoalComplete(action);
        case 'bookmark':
          return await _syncBookmark(action);
        case 'dhikr_log':
          return await _syncDhikrLog(action);
        default:
          debugPrint('OfflineProvider: unknown action type "${action.type}"');
          return false;
      }
    } catch (e) {
      debugPrint('OfflineProvider: dispatch error for ${action.type} – $e');
      return false;
    }
  }

  // ── Per-type sync stubs (replace with real API calls) ──────────────────

  Future<bool> _syncPrayerLog(OfflineAction action) async {
    // TODO: POST to your prayer-log endpoint
    // Example:
    // final response = await http.post(
    //   Uri.parse('https://api.yourapp.com/prayer-logs'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(action.payload),
    // );
    // return response.statusCode == 200 || response.statusCode == 201;
    await Future.delayed(const Duration(milliseconds: 300)); // simulate network
    return true;
  }

  Future<bool> _syncMoodLog(OfflineAction action) async {
    // TODO: POST to your mood-log endpoint
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  Future<bool> _syncGoalComplete(OfflineAction action) async {
    // TODO: PATCH goal completion on server
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  Future<bool> _syncBookmark(OfflineAction action) async {
    // TODO: POST bookmark to server
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  Future<bool> _syncDhikrLog(OfflineAction action) async {
    // TODO: POST dhikr session to server
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  // ── Convenience factory helpers ────────────────────────────────────────

  static OfflineAction createPrayerLog({
    required String prayerName,
    required String time,
    Map<String, dynamic> extra = const {},
  }) {
    return OfflineAction(
      id: 'prayer_${DateTime.now().millisecondsSinceEpoch}',
      type: 'prayer_log',
      detail: '$prayerName at $time',
      loggedAt: DateTime.now().toIso8601String(),
      payload: {'prayer': prayerName, 'time': time, ...extra},
    );
  }

  static OfflineAction createMoodLog({
    required String mood,
    String note = '',
  }) {
    return OfflineAction(
      id: 'mood_${DateTime.now().millisecondsSinceEpoch}',
      type: 'mood_log',
      detail: mood,
      loggedAt: DateTime.now().toIso8601String(),
      payload: {'mood': mood, 'note': note},
    );
  }

  static OfflineAction createGoalComplete({
    required String goalId,
    required String goalTitle,
  }) {
    return OfflineAction(
      id: 'goal_${DateTime.now().millisecondsSinceEpoch}',
      type: 'goal_complete',
      detail: goalTitle,
      loggedAt: DateTime.now().toIso8601String(),
      payload: {'goalId': goalId, 'title': goalTitle},
    );
  }

  static OfflineAction createBookmark({
    required String surah,
    required int ayah,
  }) {
    return OfflineAction(
      id: 'bookmark_${DateTime.now().millisecondsSinceEpoch}',
      type: 'bookmark',
      detail: '$surah : $ayah',
      loggedAt: DateTime.now().toIso8601String(),
      payload: {'surah': surah, 'ayah': ayah},
    );
  }

  static OfflineAction createDhikrLog({
    required String dhikr,
    required int count,
  }) {
    return OfflineAction(
      id: 'dhikr_${DateTime.now().millisecondsSinceEpoch}',
      type: 'dhikr_log',
      detail: '$dhikr × $count',
      loggedAt: DateTime.now().toIso8601String(),
      payload: {'dhikr': dhikr, 'count': count},
    );
  }

  @override
  void dispose() {
    // connectivity_plus stream closes automatically; nothing extra needed
    super.dispose();
  }
}