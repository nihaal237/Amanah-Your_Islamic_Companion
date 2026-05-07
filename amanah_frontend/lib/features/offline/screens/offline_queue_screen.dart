// lib/features/offline/screens/offline_queue_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/offline_provider.dart';

class OfflineQueueScreen extends StatefulWidget {
  const OfflineQueueScreen({super.key});

  @override
  State<OfflineQueueScreen> createState() => _OfflineQueueScreenState();
}

class _OfflineQueueScreenState extends State<OfflineQueueScreen> {
  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OfflineProvider>().loadQueue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<OfflineProvider>(
                builder: (context, provider, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusCard(provider),
                        const SizedBox(height: 20),
                        _buildSyncButton(provider),
                        const SizedBox(height: 24),
                        _buildQueueList(provider),
                        if (provider.syncedItems.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildSyncedList(provider),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
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
              child: Text('Offline Sync',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
            ),
          ),
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(8)),
            child: const Center(
              child: Text('IA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Status Card ─────────────────────────────────────────────────────────
  Widget _buildStatusCard(OfflineProvider provider) {
    final isOnline = provider.isOnline;
    final pendingCount = provider.pendingQueue.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOnline
              ? [const Color(0xFF1B5E45), const Color(0xFF2E7D5E)]
              : [Colors.orange.shade700, Colors.orange.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isOnline ? const Color(0xFF1B5E45) : Colors.orange).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOnline ? 'You\'re Online' : 'You\'re Offline',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  Text(
                    isOnline
                        ? 'All actions sync in real-time'
                        : 'Actions are saved locally',
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statPill(Icons.pending_rounded, '$pendingCount', 'Pending'),
              const SizedBox(width: 10),
              _statPill(Icons.check_circle_rounded, '${provider.syncedItems.length}', 'Synced'),
              const SizedBox(width: 10),
              _statPill(Icons.error_outline_rounded, '${provider.failedItems.length}', 'Failed'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statPill(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text('$value $label',
              style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // ── Sync Button ──────────────────────────────────────────────────────────
  Widget _buildSyncButton(OfflineProvider provider) {
    final canSync = provider.isOnline && provider.pendingQueue.isNotEmpty && !provider.isSyncing;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: canSync ? () => provider.syncNow() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade200,
          disabledForegroundColor: Colors.grey.shade400,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: provider.isSyncing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  ),
                  SizedBox(width: 10),
                  Text('Syncing...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sync_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    provider.pendingQueue.isEmpty
                        ? 'Nothing to Sync'
                        : !provider.isOnline
                            ? 'Waiting for Connection...'
                            : 'Sync ${provider.pendingQueue.length} Pending Actions',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  // ── Pending Queue ─────────────────────────────────────────────────────────
  Widget _buildQueueList(OfflineProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Pending Queue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
            if (provider.pendingQueue.isNotEmpty)
              GestureDetector(
                onTap: () => _showClearDialog(provider),
                child: Text('Clear All',
                    style: TextStyle(fontSize: 12, color: Colors.red.shade400, fontWeight: FontWeight.w500)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (provider.pendingQueue.isEmpty)
          _emptyState(
            icon: Icons.check_circle_outline_rounded,
            title: 'Queue is empty',
            sub: 'All your actions have been synced to the server.',
            color: _primaryGreen,
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.pendingQueue.length,
              separatorBuilder: (_, i) => Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, i) => _QueueTile(
                item: provider.pendingQueue[i],
                status: _QueueStatus.pending,
                onRemove: () => provider.removeFromQueue(i),
              ),
            ),
          ),
      ],
    );
  }

  // ── Synced List ───────────────────────────────────────────────────────────
  Widget _buildSyncedList(OfflineProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recently Synced',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.syncedItems.length.clamp(0, 10),
            separatorBuilder: (_, i) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, i) => _QueueTile(
              item: provider.syncedItems[i],
              status: _QueueStatus.synced,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyState({required IconData icon, required String title, required String sub, required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color.withValues(alpha: 0.4)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
          const SizedBox(height: 4),
          Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
        ],
      ),
    );
  }

  void _showClearDialog(OfflineProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 24),
              ),
              const SizedBox(height: 14),
              const Text('Clear Queue?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 8),
              const Text(
                'This will permanently delete all pending offline actions. They will not be synced to the server.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF6B8C7A), height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    provider.clearQueue();
                    Navigator.of(ctx).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade500,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Clear All', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel', style: TextStyle(fontSize: 13, color: Color(0xFF6B8C7A))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Queue Tile ─────────────────────────────────────────────────────────────
enum _QueueStatus { pending, synced, failed }

class _QueueTile extends StatelessWidget {
  final OfflineAction item;
  final _QueueStatus status;
  final VoidCallback? onRemove;

  const _QueueTile({required this.item, required this.status, this.onRemove});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  IconData get _typeIcon {
    switch (item.type) {
      case 'prayer_log':   return Icons.mosque_rounded;
      case 'mood_log':     return Icons.sentiment_satisfied_rounded;
      case 'goal_complete':return Icons.flag_rounded;
      case 'bookmark':     return Icons.bookmark_rounded;
      case 'dhikr_log':    return Icons.rotate_right_rounded;
      default:             return Icons.sync_rounded;
    }
  }

  String get _typeLabel {
    switch (item.type) {
      case 'prayer_log':   return 'Prayer Logged';
      case 'mood_log':     return 'Mood Entry';
      case 'goal_complete':return 'Goal Completed';
      case 'bookmark':     return 'Ayah Bookmarked';
      case 'dhikr_log':    return 'Dhikr Session';
      default:             return item.type;
    }
  }

  Color get _statusColor {
    switch (status) {
      case _QueueStatus.pending: return Colors.orange;
      case _QueueStatus.synced:  return _primaryGreen;
      case _QueueStatus.failed:  return Colors.red;
    }
  }

  String get _statusLabel {
    switch (status) {
      case _QueueStatus.pending: return 'Pending';
      case _QueueStatus.synced:  return 'Synced';
      case _QueueStatus.failed:  return 'Failed';
    }
  }

  IconData get _statusIcon {
    switch (status) {
      case _QueueStatus.pending: return Icons.schedule_rounded;
      case _QueueStatus.synced:  return Icons.check_circle_rounded;
      case _QueueStatus.failed:  return Icons.error_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Type icon
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_typeIcon, size: 18, color: _statusColor),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_typeLabel,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                Text(
                  item.detail.isNotEmpty ? item.detail : _formatTime(item.loggedAt),
                  style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A)),
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(_statusIcon, size: 11, color: _statusColor),
                const SizedBox(width: 3),
                Text(_statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor)),
              ],
            ),
          ),
          // Remove button (pending only)
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.close_rounded, size: 16, color: Colors.grey.shade400),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return iso;
    }
  }
}