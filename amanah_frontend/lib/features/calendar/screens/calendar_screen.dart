// lib/features/calendar/screens/calendar_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import '../providers/calendar_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late HijriCalendar _displayedMonth;
  int? _selectedDay;

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  final List<String> _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    _displayedMonth = HijriCalendar.now();
    _selectedDay = _displayedMonth.hDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarProvider>().fetchEvents();
    });
  }

  void _prevMonth() {
    setState(() {
      if (_displayedMonth.hMonth == 1) {
        _displayedMonth = HijriCalendar()
          ..hYear = _displayedMonth.hYear - 1
          ..hMonth = 12
          ..hDay = 1;
      } else {
        _displayedMonth = HijriCalendar()
          ..hYear = _displayedMonth.hYear
          ..hMonth = _displayedMonth.hMonth - 1
          ..hDay = 1;
      }
      _selectedDay = null;
    });
  }

  void _nextMonth() {
    setState(() {
      if (_displayedMonth.hMonth == 12) {
        _displayedMonth = HijriCalendar()
          ..hYear = _displayedMonth.hYear + 1
          ..hMonth = 1
          ..hDay = 1;
      } else {
        _displayedMonth = HijriCalendar()
          ..hYear = _displayedMonth.hYear
          ..hMonth = _displayedMonth.hMonth + 1
          ..hDay = 1;
      }
      _selectedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Islamic Calendar',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                    const SizedBox(height: 4),
                    const Text('Let the Islamic calendar guide your days and بركات',
                        style: TextStyle(fontSize: 13, color: Color(0xFF6B8C7A))),
                    const SizedBox(height: 20),
                    _buildCalendarCard(),
                    const SizedBox(height: 24),
                    _buildUpcomingEvents(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF1A2E25)),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Calendar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
            ),
          ),
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(8)),
            child: const Center(child: Text('IA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
          ),
        ],
      ),
    );
  }

  // ── Calendar Card ─────────────────────────────────────────────────────────
  Widget _buildCalendarCard() {
    final daysInMonth = _daysInHijriMonth(_displayedMonth.hYear, _displayedMonth.hMonth);
    final firstDayWeekday = _getFirstDayWeekday(_displayedMonth.hYear, _displayedMonth.hMonth);
    final today = HijriCalendar.now();
    final isCurrentMonth = today.hYear == _displayedMonth.hYear && today.hMonth == _displayedMonth.hMonth;

    // Month + Gregorian label
    final monthName = _displayedMonth.longMonthName;
    final year = _displayedMonth.hYear;
    // Approximate Gregorian range
    final gregLabel = _getGregorianApprox(_displayedMonth.hYear, _displayedMonth.hMonth);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Month nav
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _prevMonth,
                child: Icon(Icons.chevron_left_rounded, color: Colors.grey.shade500),
              ),
              Column(
                children: [
                  Text(
                    '$monthName $year',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25)),
                  ),
                  Text(gregLabel, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                ],
              ),
              GestureDetector(
                onTap: _nextMonth,
                child: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade500),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays
                .map((d) => SizedBox(
                      width: 32,
                      child: Text(d,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade400)),
                    ))
                .toList(),
          ),

          const SizedBox(height: 8),

          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 44,
            ),
            itemCount: firstDayWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstDayWeekday) return const SizedBox();
              final day = index - firstDayWeekday + 1;
              final isToday = isCurrentMonth && day == today.hDay;
              final isSelected = day == _selectedDay;

              return GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _primaryGreen
                        : isToday
                            ? _primaryGreen.withValues(alpha: 0.1)
                            : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? _primaryGreen
                                  : const Color(0xFF1A2E25),
                        ),
                      ),
                      // Approximate Gregorian day below
                      Text(
                        '${_approxGregorianDay(day)}',
                        style: TextStyle(
                          fontSize: 9,
                          color: isSelected ? Colors.white.withValues(alpha: 0.7) : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Upcoming Events ───────────────────────────────────────────────────────
  Widget _buildUpcomingEvents() {
    return Consumer<CalendarProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Upcoming Events',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                GestureDetector(
                  onTap: () {},
                  child: const Text('See All', style: TextStyle(fontSize: 13, color: Color(0xFF2E7D5E), fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (provider.isLoading)
              const Center(child: CircularProgressIndicator(color: _primaryGreen))
            else if (provider.events.isEmpty)
              _buildDefaultEvents()
            else
              ...provider.events.map((e) => _EventTile(event: e)),

            const SizedBox(height: 16),
            _buildRamadanBanner(),
          ],
        );
      },
    );
  }

  // Default events (shown before API loads or as fallback)
  Widget _buildDefaultEvents() {
    final events = [
      {'icon': Icons.star_rounded, 'name': 'Ramadan Starts', 'date': 'Monday, 11 March 2024', 'days': 'In 0 Days', 'urgent': true},
      {'icon': Icons.nightlight_round, 'name': 'Laylat al-Qadr', 'date': 'Saturday, 6 April 2024', 'days': '26 Days', 'urgent': false},
      {'icon': Icons.celebration_rounded, 'name': 'Eid al-Fitr', 'date': 'Wednesday, 10 April 2024', 'days': '30 Days', 'urgent': false},
    ];
    return Column(children: events.map((e) => _DefaultEventTile(event: e)).toList());
  }

  Widget _buildRamadanBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E45), Color(0xFF2E7D5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ramadan Mubarak',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            '"The month of Ramadan is that in which was revealed the Quran..." (2:185)',
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85), height: 1.5),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: const Text('Learn More',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  int _daysInHijriMonth(int year, int month) {
    // Hijri months alternate 30/29 days, with adjustments
    if (month % 2 == 1) return 30;
    if (month == 12) {
      // Leap year check (simple approximation)
      return (year % 30 == 2 || year % 30 == 5 || year % 30 == 7 ||
              year % 30 == 10 || year % 30 == 13 || year % 30 == 16 ||
              year % 30 == 18 || year % 30 == 21 || year % 30 == 24 ||
              year % 30 == 26 || year % 30 == 29)
          ? 30
          : 29;
    }
    return 29;
  }

  int _getFirstDayWeekday(int hYear, int hMonth) {
    try {
      final h = HijriCalendar()
        ..hYear = hYear
        ..hMonth = hMonth
        ..hDay = 1;
      final greg = h.hijriToGregorian(hYear, hMonth, 1);
      return greg.weekday % 7; // Sunday = 0
    } catch (_) {
      return 0;
    }
  }

  String _getGregorianApprox(int hYear, int hMonth) {
    try {
      final h = HijriCalendar()
        ..hYear = hYear
        ..hMonth = hMonth
        ..hDay = 1;
      final greg = h.hijriToGregorian(hYear, hMonth, 1);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[greg.month - 1]} / ${months[(greg.month) % 12]} ${greg.year}';
    } catch (_) {
      return '';
    }
  }

  int _approxGregorianDay(int hijriDay) {
    try {
      final greg = _displayedMonth.hijriToGregorian(
        _displayedMonth.hYear, _displayedMonth.hMonth, hijriDay,
      );
      return greg.day;
    } catch (_) {
      return hijriDay;
    }
  }
}

// ── Event Tile (from API) ──────────────────────────────────────────────────
class _EventTile extends StatelessWidget {
  final Map<String, dynamic> event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.event_rounded, color: Color(0xFF1B5E45), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['name'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                Text(event['date'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
              ],
            ),
          ),
          if (event['days_until'] != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${event['days_until']} Days',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF1B5E45))),
            ),
        ],
      ),
    );
  }
}

// ── Default Event Tile (fallback) ─────────────────────────────────────────
class _DefaultEventTile extends StatelessWidget {
  final Map<String, dynamic> event;
  const _DefaultEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final isUrgent = event['urgent'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(event['icon'] as IconData? ?? Icons.event_rounded, color: const Color(0xFF1B5E45), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                Text(event['date'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isUrgent ? const Color(0xFF1B5E45) : const Color(0xFFE8F4EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              event['days'] as String,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isUrgent ? Colors.white : const Color(0xFF1B5E45)),
            ),
          ),
        ],
      ),
    );
  }
}