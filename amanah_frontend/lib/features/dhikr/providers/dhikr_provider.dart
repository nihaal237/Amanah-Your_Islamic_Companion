// lib/features/dhikr/providers/dhikr_provider.dart

import 'package:flutter/foundation.dart';

class DhikrItem {
  final String id;
  final String name;
  final String subtitle;
  final String arabicText;
  int count;
  final int target;
  final bool isCustom;

  DhikrItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.arabicText,
    this.count = 0,
    this.target = 33,
    this.isCustom = false,
  });
}

class DhikrProvider extends ChangeNotifier {
  final List<DhikrItem> _dhikrs = [
    DhikrItem(
      id: 'subhanallah',
      name: 'SubhanAllah',
      subtitle: 'Glory be to Allah',
      arabicText: 'سُبْحَانَ اللَّه',
      target: 33,
    ),
    DhikrItem(
      id: 'alhamdulillah',
      name: 'Alhamdulillah',
      subtitle: 'Praise be to Allah',
      arabicText: 'الْحَمْدُ لِلَّه',
      target: 33,
    ),
    DhikrItem(
      id: 'allahuakbar',
      name: 'Allahu Akbar',
      subtitle: 'Allah is the Greatest',
      arabicText: 'اللَّهُ أَكْبَر',
      target: 34,
    ),
  ];

  List<DhikrItem> get dhikrs => List.unmodifiable(_dhikrs);

  void increment(String id) {
    final idx = _dhikrs.indexWhere((d) => d.id == id);
    if (idx != -1) {
      _dhikrs[idx].count++;
      notifyListeners();
    }
  }

  void reset(String id) {
    final idx = _dhikrs.indexWhere((d) => d.id == id);
    if (idx != -1) {
      _dhikrs[idx].count = 0;
      notifyListeners();
    }
  }

  void addCustomDhikr({
    required String name,
    required String arabicText,
    required int target,
  }) {
    _dhikrs.add(DhikrItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      subtitle: 'Custom Dhikr',
      arabicText: arabicText,
      target: target,
      isCustom: true,
    ));
    notifyListeners();
  }

  void removeCustom(String id) {
    _dhikrs.removeWhere((d) => d.id == id && d.isCustom);
    notifyListeners();
  }
}