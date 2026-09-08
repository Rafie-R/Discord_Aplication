import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/storage_service.dart';

class UserProfileScreen extends StatefulWidget {
  final DiscordUser user;
  final ValueChanged<DiscordUser>? onUserUpdated;

  const UserProfileScreen({
    super.key,
    required this.user,
    this.onUserUpdated,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _noteController;

  late DiscordUser _currentUser;

  // Mock Shop items available for adding to wishlist
  final List<ShopItem> _availableShopItems = [
    ShopItem(
      id: 'item_1',
      title: 'Neon Cyberpunk Aura',
      category: 'Avatar Decoration',
      price: '\$2.99',
      iconEmoji: '⚡',
      color: const Color(0xFF00E5FF),
    ),
    ShopItem(
      id: 'item_2',
      title: 'Sakura Petals Fall',
      category: 'Profile Effect',
      price: '\$3.49',
      iconEmoji: '🌸',
      color: const Color(0xFFFF4081),
    ),
    ShopItem(
      id: 'item_3',
      title: 'Pixel Gamer Frame',
      category: 'Avatar Frame',
      price: '\$1.99',
      iconEmoji: '👾',
      color: const Color(0xFF76FF03),
    ),
    ShopItem(
      id: 'item_4',
      title: 'Cosmic Galaxy Background',
      category: 'Profile Theme',
      price: '\$4.99',
      iconEmoji: '🌌',
      color: const Color(0xFF7C4DFF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _tabController = TabController(length: 2, vsync: this);
    _noteController = TextEditingController(text: _currentUser.note);

    // Default sample friends if empty
    if (_currentUser.friends.isEmpty) {
      _currentUser.friends = [
        DiscordUser(
          id: 'user_lane',
          name: 'Lane',
          avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
          roleBadge: '⚔️ BOOT',
          roleColor: const Color(0xFFE91E63),
          status: 'online',
        ),
        DiscordUser(
          id: 'user_ottimyr',
          name: 'Óttimyr',
          avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
          roleBadge: '💀 .gd',
          roleColor: const Color(0xFF9C27B0),
          status: 'idle',
        ),
        DiscordUser(
          id: 'user_craftwars',
          name: 'Craftwars Dev',
          avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
          roleBadge: '🛡️ ADMIN',
          roleColor: const Color(0xFF4CAF50),
          status: 'dnd',
        ),
      ];
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _notifyUpdate() {
    StorageService.saveUserProfile(_currentUser);
    if (widget.onUserUpdated != null) {
      widget.onUserUpdated!(_currentUser);
    }
    setState(() {});
  }

  // Color helper for status indicator
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return const Color(0xFF23A55A);
      case 'idle':
        return const Color(0xFFF0B232);
      case 'dnd':
        return const Color(0xFFF23F43);
      case 'invisible':
      case 'offline':
      default:
        return const Color(0xFF80848E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Header Banner with Black background & Avatar
                    _buildHeaderBanner(context),

                    const SizedBox(height: 12),

                    // User Name & Tag Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _currentUser.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E3338),
                                ),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    color: Color(0xFF4F545C), size: 24),
                                onPressed: _showEditProfileDialog,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _currentUser.handle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4F545C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Edit Profile Primary Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _showEditProfileDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5865F2),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tab Bar: Main vs Wishlist
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black12, width: 1),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: const Color(0xFF5865F2),
                        unselectedLabelColor: const Color(0xFF747F8D),
                        indicatorColor: const Color(0xFF5865F2),
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        tabs: const [
                          Tab(text: 'Main'),
                          Tab(text: 'Wishlist'),
                        ],
                      ),
                    ),

                    // Tab Contents (Main vs Wishlist)
                    SizedBox(
                      height: 480,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildMainTabContent(),
                          _buildWishlistTabContent(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Floating Action Navigation Dock
            _buildBottomFloatingDock(context),
          ],
        ),
      ),
    );
  }

  // Header Banner Component
  Widget _buildHeaderBanner(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Black Top Header Box
        Container(
          height: 110,
          width: double.infinity,
          color: Colors.black,
        ),

        // Close Button X (with counter 60 badge) on Top Left
        Positioned(
          top: 12,
          left: 12,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.close, color: Colors.white, size: 18),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF23F43),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '60',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        // Avatar + Status Indicator + Status Pill Row
        Positioned(
          top: 50,
          left: 16,
          right: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Large Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5865F2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF2F3F5), width: 4),
                    ),
                    child: ClipOval(
                      child: _currentUser.avatarUrl.isNotEmpty
                          ? Image.network(
                              _currentUser.avatarUrl,
                              width: 86,
                              height: 86,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Text('🦆', style: TextStyle(fontSize: 48))),
                            )
                          : const Center(child: Text('🦆', style: TextStyle(fontSize: 48))),
                    ),
                  ),
                  // Green Status Dot
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _getStatusColor(_currentUser.status),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF2F3F5), width: 3),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Status Bubble Pill: "+ What's on your mind?"
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: _showStatusEditorDialog,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add, size: 16, color: Color(0xFF4F545C)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _currentUser.customStatus.isNotEmpty
                                  ? _currentUser.customStatus
                                  : "What's on your mind?",
                              style: TextStyle(
                                fontSize: 13,
                                color: _currentUser.customStatus.isNotEmpty
                                    ? const Color(0xFF2E3338)
                                    : const Color(0xFF747F8D),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 50),
      ],
    );
  }

  // Main Tab Content View
  Widget _buildMainTabContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 1. Orbs Balance Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Orbs Balance',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3338),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '💎 ${_currentUser.orbsBalance} Orbs available',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF747F8D),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showOrbsDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0E0E0),
                    foregroundColor: const Color(0xFF2E3338),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  icon: const Icon(Icons.stars_rounded, size: 18, color: Color(0xFF5865F2)),
                  label: const Text(
                    'Try Orbs',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 2. Member Since Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Member Since',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3338),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.discord, color: Color(0xFF5865F2), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _currentUser.memberSince,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F545C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 3. Friends List Card
          InkWell(
            onTap: _showFriendsDialog,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    'Friends',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3338),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5865F2).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_currentUser.friends.length}',
                      style: const TextStyle(
                        color: Color(0xFF5865F2),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Color(0xFF747F8D)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 4. Note Card (only visible to you)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Note (only visible to you)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3338),
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.edit_note, size: 18, color: Color(0xFF747F8D)),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  onChanged: (val) {
                    _currentUser.note = val;
                    _notifyUpdate();
                  },
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Click to add a personal note...',
                    hintStyle: TextStyle(fontSize: 13, color: Color(0xFF949BA4)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF2E3338)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Wishlist Tab Content View (Screenshot 2)
  Widget _buildWishlistTabContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentUser.wishlist.isEmpty) ...[
            const Text(
              'No hearts yet 💔',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3338),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse the Shop and heart the items you love to add them here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF747F8D),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showShopDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2E3338),
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 0,
              ),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'Add Item',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ] else ...[
            // Wishlisted Items Grid/List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saved Items (${_currentUser.wishlist.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _showShopDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add More'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _currentUser.wishlist.length,
                itemBuilder: (context, index) {
                  final item = _currentUser.wishlist[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.color.withValues(alpha: 0.2),
                        child: Text(item.iconEmoji, style: const TextStyle(fontSize: 20)),
                      ),
                      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('${item.category} • ${item.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.pink),
                        onPressed: () {
                          _currentUser.wishlist.removeAt(index);
                          _notifyUpdate();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );
  }

  // Bottom Floating Navigation Dock (Quests, Shop, Nitro, Settings)
  Widget _buildBottomFloatingDock(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDockItem(
            icon: Icons.stars_outlined,
            label: 'Quests',
            onTap: _showQuestsDialog,
          ),
          _buildDockItem(
            icon: Icons.storefront_outlined,
            label: 'Shop',
            onTap: _showShopDialog,
          ),
          _buildDockItem(
            icon: Icons.speed,
            label: 'Nitro',
            onTap: _showNitroDialog,
          ),
          _buildDockItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: _showSettingsDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildDockItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: const Color(0xFF2E3338)),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E3338),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Dialogs & Modals ----------------

  // 1. Custom Status Editor Dialog
  void _showStatusEditorDialog() {
    final textController = TextEditingController(text: _currentUser.customStatus);
    String selectedStatus = _currentUser.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Set Custom Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                  prefixIcon: Icon(Icons.edit),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Online Status State',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['online', 'idle', 'dnd', 'invisible'].map((st) {
                  final isSel = selectedStatus == st;
                  return ChoiceChip(
                    label: Text(st.toUpperCase()),
                    selected: isSel,
                    selectedColor: _getStatusColor(st).withValues(alpha: 0.2),
                    onSelected: (_) {
                      setModalState(() {
                        selectedStatus = st;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentUser.customStatus = textController.text.trim();
                    _currentUser.status = selectedStatus;
                  });
                  _notifyUpdate();
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5865F2),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                ),
                child: const Text('Save Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Edit Profile Modal
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _currentUser.name);
    final handleController = TextEditingController(text: _currentUser.handle);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('✏️ Edit Profile Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: handleController,
              decoration: const InputDecoration(
                labelText: 'User Tag / Handle',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentUser.name = nameController.text.trim();
                  _currentUser.handle = handleController.text.trim();
                });
                _notifyUpdate();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5865F2),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Orbs Modal Dialog
  void _showOrbsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Text('💎 Discord Orbs', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You currently have ${_currentUser.orbsBalance} Orbs!',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use Orbs to unlock custom avatar decorations, soundboard effects, and exclusive role badges.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF747F8D), fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentUser.orbsBalance += 100;
                  });
                  _notifyUpdate();
                  setDialogState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('+100 Orbs claimed successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF23A55A), foregroundColor: Colors.white),
                icon: const Icon(Icons.add),
                label: const Text('Claim Daily +100 Orbs'),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Friends Management Modal
  void _showFriendsDialog() {
    final addFriendController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.group, color: Color(0xFF5865F2)),
                  const SizedBox(width: 10),
                  Text('Friends List (${_currentUser.friends.length})',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: addFriendController,
                      decoration: const InputDecoration(
                        hintText: 'Enter username to add...',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final username = addFriendController.text.trim();
                      if (username.isNotEmpty) {
                        setState(() {
                          _currentUser.friends.add(
                            DiscordUser(
                              id: 'user_${DateTime.now().millisecondsSinceEpoch}',
                              name: username,
                              avatarUrl: 'https://api.dicebear.com/7.x/bottts/png?seed=$username',
                              status: 'online',
                            ),
                          );
                        });
                        _notifyUpdate();
                        addFriendController.clear();
                        setModalState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5865F2), foregroundColor: Colors.white),
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  itemCount: _currentUser.friends.length,
                  itemBuilder: (context, index) {
                    final friend = _currentUser.friends[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        child: Text(friend.name.isNotEmpty ? friend.name[0].toUpperCase() : 'F'),
                      ),
                      title: Text(friend.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(friend.status.toUpperCase(),
                          style: TextStyle(color: _getStatusColor(friend.status), fontSize: 11)),
                      trailing: IconButton(
                        icon: const Icon(Icons.person_remove, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _currentUser.friends.removeAt(index);
                          });
                          _notifyUpdate();
                          setModalState(() {});
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. Quests Modal
  void _showQuestsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.stars, color: Color(0xFF5865F2), size: 26),
                SizedBox(width: 10),
                Text('🎯 Discord Quests & Rewards',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFFE3F2FD), child: Text('🎮')),
              title: const Text('Stream a game for 15 mins', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Reward: Special Cyber Avatar Frame'),
              trailing: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Claim'),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFFF3E5F5), child: Text('💬')),
              title: const Text('Send 5 messages in server', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Reward: 50 Orbs'),
              trailing: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Claim'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 6. Shop Modal
  void _showShopDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(Icons.storefront, color: Color(0xFF5865F2), size: 26),
                  SizedBox(width: 10),
                  Text('🛍️ Avatar Shop',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 320,
                child: ListView.builder(
                  itemCount: _availableShopItems.length,
                  itemBuilder: (context, index) {
                    final item = _availableShopItems[index];
                    final isWishlisted = _currentUser.wishlist.any((w) => w.id == item.id);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.color.withValues(alpha: 0.2),
                          child: Text(item.iconEmoji, style: const TextStyle(fontSize: 20)),
                        ),
                        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${item.category} • ${item.price}'),
                        trailing: IconButton(
                          icon: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: isWishlisted ? Colors.pink : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isWishlisted) {
                                _currentUser.wishlist.removeWhere((w) => w.id == item.id);
                              } else {
                                _currentUser.wishlist.add(item);
                              }
                            });
                            _notifyUpdate();
                            setModalState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 7. Nitro Modal
  void _showNitroDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚡ Discord Nitro Boost', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              'Unlock HD Streaming, 500MB File Uploads, Custom Emojis everywhere, and 2 Free Server Boosts!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF4F545C)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5865F2),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text('Subscribe for \$9.99/mo'),
            ),
          ],
        ),
      ),
    );
  }

  // 8. Settings Modal
  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.settings, color: Color(0xFF5865F2)),
                SizedBox(width: 10),
                Text('⚙️ User & App Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('Dark Theme Mode'),
            ),
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('Push Notifications'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(ctx);
                final nav = Navigator.of(ctx);
                await StorageService.clearAllStorage();
                nav.pop();
                messenger.showSnackBar(
                  const SnackBar(content: Text('App storage & cache cleared!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF23F43),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
              ),
              icon: const Icon(Icons.delete_forever),
              label: const Text('Clear Storage & Reset App'),
            ),
          ],
        ),
      ),
    );
  }
}
