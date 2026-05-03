// lib/features/community/providers/community_provider.dart

import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class CommunityProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _circles = [];
  List<Map<String, dynamic>> _myCircles = [];
  List<Map<String, dynamic>> _posts = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get circles => _circles;
  List<Map<String, dynamic>> get myCircles => _myCircles;
  List<Map<String, dynamic>> get posts => _posts;

  Future<void> fetchCircles() async {
    _isLoading = true;
    notifyListeners();
    try {
      final resp = await ApiService.get(ApiConstants.circles);
      final data = resp.data;
      if (data is List) {
        _circles = data.cast<Map<String, dynamic>>();
      } else if (data is Map && data.containsKey('results')) {
        _circles = (data['results'] as List).cast<Map<String, dynamic>>();
      }
      // Filter joined circles
      _myCircles = _circles.where((c) => c['is_member'] == true).toList();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> joinCircle(String circleId) async {
    try {
      await ApiService.post('${ApiConstants.circles}$circleId/join/');
      await fetchCircles();
    } catch (_) {}
  }

  Future<void> fetchCirclePosts(String circleId) async {
    try {
      final resp = await ApiService.get('${ApiConstants.circles}$circleId/posts/');
      final data = resp.data;
      if (data is List) {
        _posts = data.cast<Map<String, dynamic>>();
      } else if (data is Map && data.containsKey('results')) {
        _posts = (data['results'] as List).cast<Map<String, dynamic>>();
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> createPost(String circleId, String content) async {
    if (content.isEmpty) return;
    try {
      final resp = await ApiService.post(
        '${ApiConstants.circles}$circleId/posts/',
        data: {'content': content},
      );
      _posts.insert(0, resp.data as Map<String, dynamic>);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> reactToPost(String postId) async {
    try {
      await ApiService.post('${ApiConstants.posts}$postId/react/');
    } catch (_) {}
  }

  Future<void> deletePost(String postId) async {
    try {
      await ApiService.delete('${ApiConstants.posts}$postId/');
      _posts.removeWhere((p) => p['id'].toString() == postId);
      notifyListeners();
    } catch (_) {}
  }
}