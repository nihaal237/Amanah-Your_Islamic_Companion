// lib/features/community/screens/circle_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/community_provider.dart';

class CircleDetailScreen extends StatefulWidget {
  final String circleId;
  const CircleDetailScreen({super.key, required this.circleId});

  @override
  State<CircleDetailScreen> createState() => _CircleDetailScreenState();
}

class _CircleDetailScreenState extends State<CircleDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _joined = false;

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  // Sample posts
  final List<_Post> _posts = const [
    _Post(
      author: 'Omar Al-Faruq',
      authorInitials: 'OF',
      timeAgo: '2 hours ago',
      category: 'Reflection',
      arabic: 'فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ',
      text: 'Surah Ar-Rahman always reminds me of the infinite blessings we often overlook. Today, I\'m reflecting on the blessing of community and shared knowledge. What are you grateful for today?',
      likes: 124,
      comments: 31,
    ),
    _Post(
      author: 'Sara Ahmad',
      authorInitials: 'SA',
      timeAgo: '5 hours ago',
      category: 'Question',
      arabic: null,
      text: 'Weekly Tafsir Recommendation?\n\nAsalaam Alaikum everyone. I\'m looking for a beginner-friendly Tafsir book that focuses on the linguistic miracles of the Quran. Any suggestions?\n\n#Tafsir #Miracles',
      likes: 45,
      comments: 20,
    ),
    _Post(
      author: 'Ibrahim Khalil',
      authorInitials: 'IK',
      timeAgo: '1 day ago',
      category: 'Reflection',
      arabic: null,
      text: '"The morning hours are the best time for Quranic contemplation..."',
      likes: 89,
      comments: 14,
      hasImage: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityProvider>().fetchCirclePosts(widget.circleId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostSheet(context),
        backgroundColor: _primaryGreen,
        child: const Icon(Icons.edit_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildCircleInfo(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFeedTab(),
                  _buildResourcesTab(),
                  _buildEventsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
              child: Text('Quran Study Circle',
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

  Widget _buildCircleInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.menu_book_rounded, color: _primaryGreen, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Quran Study Circle',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(6)),
                          child: const Text('Joined', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _primaryGreen)),
                        ),
                      ],
                    ),
                    const Text('Active Community · 1.2k Members',
                        style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _joined = !_joined),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _joined ? const Color(0xFFE8F4EE) : _primaryGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _joined ? 'Leave' : 'Invite',
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: _joined ? _primaryGreen : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'A dedicated space for deep reflection (Tadabbur) on the meanings of the Holy Quran. Join us for weekly thematic studies and spiritual insights.',
            style: TextStyle(fontSize: 12, color: Color(0xFF6B8C7A), height: 1.4),
          ),
          const SizedBox(height: 10),
          // Member avatars
          Row(
            children: [
              SizedBox(
                width: 70, height: 24,
                child: Stack(
                  children: List.generate(3, (i) => Positioned(
                    left: i * 16.0,
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: [const Color(0xFF1B5E45), const Color(0xFF2E7D5E), const Color(0xFF81C784)][i],
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  )),
                ),
              ),
              const SizedBox(width: 4),
              Text('+1k', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0EBE5)),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(8)),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF6B8C7A),
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Feed'), Tab(text: 'Resources'), Tab(text: 'Events')],
        ),
      ),
    );
  }

  Widget _buildFeedTab() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: _posts.length,
      itemBuilder: (context, i) => _PostCard(post: _posts[i]),
    );
  }

  Widget _buildResourcesTab() {
    return const Center(
      child: Text('Resources coming soon', style: TextStyle(color: Color(0xFF6B8C7A))),
    );
  }

  Widget _buildEventsTab() {
    return const Center(
      child: Text('Events coming soon', style: TextStyle(color: Color(0xFF6B8C7A))),
    );
  }

  void _showCreatePostSheet(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('Share with the Circle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E25)),
              decoration: InputDecoration(
                hintText: 'Share a reflection, question, or resource...',
                hintStyle: const TextStyle(color: Color(0xFFADBFB5), fontSize: 13),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryGreen, width: 1.5)),
                filled: true, fillColor: const Color(0xFFF7FAF8),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CommunityProvider>().createPost(widget.circleId, controller.text.trim());
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Post to Circle', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Post Card ──────────────────────────────────────────────────────────────
class _PostCard extends StatefulWidget {
  final _Post post;
  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _liked = false;
  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: const Color(0xFFE8F4EE), shape: BoxShape.circle),
                child: Center(child: Text(widget.post.authorInitials,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _primaryGreen))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.post.author,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                    Text('${widget.post.timeAgo} · ${widget.post.category}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                  ],
                ),
              ),
              Icon(Icons.more_horiz_rounded, color: Colors.grey.shade400, size: 20),
            ],
          ),

          const SizedBox(height: 12),

          // Arabic if present
          if (widget.post.arabic != null) ...[
            Text(
              widget.post.arabic!,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25), height: 1.8),
            ),
            const SizedBox(height: 8),
          ],

          // Post text
          Text(widget.post.text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF3D5A4C), height: 1.5)),

          // Image placeholder
          if (widget.post.hasImage) ...[
            const SizedBox(height: 10),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E45),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(Icons.image_rounded, color: Colors.white.withValues(alpha: 0.5), size: 40)),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F5F2)),
          const SizedBox(height: 10),

          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _liked = !_liked),
                child: Row(
                  children: [
                    Icon(
                      _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 18,
                      color: _liked ? Colors.red : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text('${widget.post.likes + (_liked ? 1 : 0)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.comment_outlined, size: 16, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text('${widget.post.comments}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
              const Spacer(),
              Icon(Icons.share_outlined, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ],
      ),
    );
  }
}

class _Post {
  final String author, authorInitials, timeAgo, category, text;
  final String? arabic;
  final int likes, comments;
  final bool hasImage;
  const _Post({
    required this.author, required this.authorInitials, required this.timeAgo,
    required this.category, required this.text, this.arabic,
    required this.likes, required this.comments, this.hasImage = false,
  });
}