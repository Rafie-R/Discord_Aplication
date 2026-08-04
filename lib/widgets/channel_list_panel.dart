import 'package:flutter/material.dart';
import '../models/server_model.dart';
import '../models/message_model.dart';

class ChannelListPanel extends StatefulWidget {
  final DiscordServer server;
  final DiscordChannel selectedChannel;
  final ValueChanged<DiscordChannel> onChannelSelected;
  final DiscordUser currentUser;

  const ChannelListPanel({
    super.key,
    required this.server,
    required this.selectedChannel,
    required this.onChannelSelected,
    required this.currentUser,
  });

  @override
  State<ChannelListPanel> createState() => _ChannelListPanelState();
}

class _ChannelListPanelState extends State<ChannelListPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.server.backgroundColor,
      child: Column(
        children: [
          // Expanded Scrollable Content
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Server Header Banner
                Stack(
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Image.network(
                        widget.server.bannerImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: widget.server.themeColor),
                      ),
                    ),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            widget.server.backgroundColor.withValues(alpha: 0.9),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Server Title & Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.server.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E3338),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.settings_outlined,
                            size: 18,
                            color: Color(0xFF747F8D),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            size: 20,
                            color: Color(0xFF747F8D),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_formatNumber(widget.server.memberCount)} Members  •  ${widget.server.serverType}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF747F8D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Search Input Box
                      InkWell(
                        onTap: () => _showSearchDialog(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search, size: 18, color: Color(0xFF747F8D)),
                              SizedBox(width: 6),
                              Text(
                                'Search',
                                style: TextStyle(
                                  color: Color(0xFF747F8D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Boost Goal Bar
                      InkWell(
                        onTap: () => _showBoostDialog(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E5F5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Text('Boost Goal 🚀',
                                  style: TextStyle(
                                      fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${widget.server.boostCount} Boosts >',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF9C27B0)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Quick Server Options: Server Guide
                      InkWell(
                        onTap: () => _showServerGuideDialog(context),
                        borderRadius: BorderRadius.circular(6),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.explore_outlined,
                                  size: 18, color: Color(0xFF4F545C)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Server Guide',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E3338),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Quick Server Options: Channels & Roles
                      InkWell(
                        onTap: () => _showChannelsRolesDialog(context),
                        borderRadius: BorderRadius.circular(6),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.tune,
                                  size: 18, color: Color(0xFF4F545C)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Channels & Roles',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E3338),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Colors.black12),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                // Channel Categories & Channel Items
                ...widget.server.categories.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Header
                      InkWell(
                        onTap: () {
                          setState(() {
                            category.isExpanded = !category.isExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF747F8D),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                category.isExpanded
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_right,
                                size: 16,
                                color: const Color(0xFF747F8D),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Channels under Category
                      if (category.isExpanded)
                        ...category.channels.map((channel) {
                          final isSelected =
                              channel.id == widget.selectedChannel.id;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2.0),
                            child: InkWell(
                              onTap: () => widget.onChannelSelected(channel),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black.withValues(alpha: 0.08)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      channel.iconEmoji,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isSelected || channel.unreadCount > 0
                                            ? const Color(0xFF2E3338)
                                            : const Color(0xFF747F8D),
                                        fontWeight: isSelected || channel.unreadCount > 0
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        channel.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isSelected || channel.unreadCount > 0
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isSelected || channel.unreadCount > 0
                                              ? const Color(0xFF2E3338)
                                              : const Color(0xFF4F545C),
                                        ),
                                      ),
                                    ),
                                    if (channel.isLocked)
                                      const Icon(
                                        Icons.lock_outline,
                                        size: 14,
                                        color: Color(0xFF747F8D),
                                      ),
                                    if (channel.unreadCount > 0)
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF23F43),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${channel.unreadCount}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      const SizedBox(height: 8),
                    ],
                  );
                }),
              ],
            ),
          ),

          // Bottom Floating User Bar (Duck v, Online)
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5865F2),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: widget.currentUser.avatarUrl.isNotEmpty
                            ? Image.network(
                                widget.currentUser.avatarUrl,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Text('🦆', style: TextStyle(fontSize: 18))),
                              )
                            : const Center(child: Text('🦆', style: TextStyle(fontSize: 18))),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF23A55A),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.currentUser.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF2E3338),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down,
                              size: 16, color: Color(0xFF747F8D)),
                        ],
                      ),
                      const Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF747F8D),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 20),
                  color: const Color(0xFF4F545C),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return (number / 1000).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }
    return '$number';
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFF5865F2)),
            const SizedBox(width: 8),
            Text('Search in ${widget.server.name}', style: const TextStyle(fontSize: 16)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search messages, channels, or members...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBoostDialog(BuildContext context) {
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
            const Text('🚀 Server Boost Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              '${widget.server.name} has ${widget.server.boostCount} boosts!\nLevel 3 Perks unlocked: 384Kbps Audio, 100MB Uploads, Custom Banner.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF4F545C)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
              ),
              icon: const Icon(Icons.bolt),
              label: const Text('Boost This Server'),
            ),
          ],
        ),
      ),
    );
  }

  void _showServerGuideDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.explore, color: Color(0xFF5865F2), size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Server Guide - ${widget.server.name}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Welcome! Follow these 3 simple steps to get started:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildGuideStep('1', 'Read Rules', 'Check out the #rules channel to understand community guidelines.'),
            _buildGuideStep('2', 'Pick Roles', 'Visit #roles to customize your profile badges and notifications.'),
            _buildGuideStep('3', 'Say Hello', 'Introduce yourself in #welcome or #introductions!'),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5865F2), foregroundColor: Colors.white),
                child: const Text('Got it!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideStep(String step, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFF5865F2),
            child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(desc, style: const TextStyle(color: Color(0xFF747F8D), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChannelsRolesDialog(BuildContext context) {
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
                Icon(Icons.tune, color: Color(0xFF5865F2)),
                SizedBox(width: 10),
                Text('Channels & Roles Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('Show Announcement Channels'),
            ),
            CheckboxListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('Enable Mention Notifications'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5865F2),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
