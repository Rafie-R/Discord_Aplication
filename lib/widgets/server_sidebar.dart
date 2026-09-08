import 'package:flutter/material.dart';
import '../models/server_model.dart';
import '../models/message_model.dart';

class ServerSidebar extends StatelessWidget {
  final List<DiscordServer> servers;
  final DiscordServer selectedServer;
  final ValueChanged<DiscordServer> onServerSelected;
  final DiscordUser user;
  final VoidCallback? onUserProfileTap;

  const ServerSidebar({
    super.key,
    required this.servers,
    required this.selectedServer,
    required this.onServerSelected,
    required this.user,
    this.onUserProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: const Color(0xFFE3E5E8),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Direct Messages Icon
          _buildSidebarButton(
            isSelected: false,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.chat_bubble_rounded,
                color: Color(0xFF4F545C),
                size: 24,
              ),
            ),
            onTap: () {},
          ),

          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 32,
            color: Colors.black12,
          ),
          const SizedBox(height: 8),

          // Server Icons List
          Expanded(
            child: ListView.builder(
              itemCount: servers.length,
              itemBuilder: (context, index) {
                final server = servers[index];
                final isSelected = server.id == selectedServer.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: _buildServerIcon(server, isSelected),
                );
              },
            ),
          ),

          // Bottom User Profile Bar Icon
          InkWell(
            onTap: onUserProfileTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5865F2),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: user.avatarUrl.isNotEmpty
                          ? Image.network(
                              user.avatarUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Text('🦆', style: TextStyle(fontSize: 22))),
                            )
                          : const Center(child: Text('🦆', style: TextStyle(fontSize: 22))),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF23A55A),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE3E5E8), width: 2),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildServerIcon(DiscordServer server, bool isSelected) {
    return InkWell(
      onTap: () => onServerSelected(server),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left selection indicator pill
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: 0,
            child: Container(
              width: 4,
              height: isSelected ? 36 : 12,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF23A55A) : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),

          // Server Icon Container
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isSelected ? 16 : 24),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          server.bannerImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: server.themeColor),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.35),
                          alignment: Alignment.center,
                          child: Text(
                            server.iconText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Unread Count Red Badge (Top-Right or Bottom-Right)
              if (server.totalUnreadCount > 0)
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF23F43),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE3E5E8), width: 2),
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${server.totalUnreadCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarButton({
    required bool isSelected,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: 0,
            child: Container(
              width: 4,
              height: isSelected ? 36 : 0,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
