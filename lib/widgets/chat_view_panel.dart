import 'package:flutter/material.dart';
import '../models/server_model.dart';
import '../models/message_model.dart';
import 'reaction_chip.dart';

class ChatViewPanel extends StatefulWidget {
  final DiscordServer server;
  final DiscordChannel channel;
  final List<DiscordMessage> messages;
  final VoidCallback? onBackPressed;
  final ValueChanged<String> onSendMessage;
  final ValueChanged<DiscordMessage>? onDeleteMessage;
  final VoidCallback? onClearChannelHistory;
  final VoidCallback? onResetAllStorage;

  const ChatViewPanel({
    super.key,
    required this.server,
    required this.channel,
    required this.messages,
    this.onBackPressed,
    required this.onSendMessage,
    this.onDeleteMessage,
    this.onClearChannelHistory,
    this.onResetAllStorage,
  });

  @override
  State<ChatViewPanel> createState() => _ChatViewPanelState();
}

class _ChatViewPanelState extends State<ChatViewPanel> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showNewMessagesBanner = true;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 1. Top Bar Header
          SafeArea(
            bottom: false,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              child: Row(
                children: [
                  if (widget.onBackPressed != null) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF4F545C)),
                      onPressed: widget.onBackPressed,
                    ),
                  ],
                  Text(
                    widget.channel.iconEmoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.channel.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3338),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right,
                            size: 20, color: Color(0xFF747F8D)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Color(0xFF4F545C)),
                    onPressed: () {},
                  ),
                  // Header Popup Menu (Options: Clear Chat / Reset Storage)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Color(0xFF4F545C)),
                    onSelected: (value) {
                      if (value == 'clear_channel' && widget.onClearChannelHistory != null) {
                        widget.onClearChannelHistory!();
                      } else if (value == 'reset_storage' && widget.onResetAllStorage != null) {
                        widget.onResetAllStorage!();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'clear_channel',
                        child: Row(
                          children: [
                            Icon(Icons.cleaning_services, size: 18, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Clear Channel History'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'reset_storage',
                        child: Row(
                          children: [
                            Icon(Icons.delete_forever, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Reset All App Storage'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. New Messages Blue Alert Banner
          if (_showNewMessagesBanner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF5865F2),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      '25+ new messages since 6:07 AM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showNewMessagesBanner = false;
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),

          // 3. Chat Messages Timeline
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: widget.messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildChannelWelcomeHeader();
                    }
                    final msg = widget.messages[index - 1];
                    return _buildMessageItem(msg);
                  },
                ),

                // Floating Jump Down Button
                Positioned(
                  right: 16,
                  bottom: 70,
                  child: FloatingActionButton.small(
                    elevation: 3,
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4F545C),
                    onPressed: () {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: const Icon(Icons.arrow_downward, size: 18),
                  ),
                ),

                // Bottom Announcement Follow Banner overlay
                if (widget.channel.type == 'announcement')
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F3F5),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Follow to get this channel\'s updates in your own server.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F545C),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5865F2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Text(
                                'Follow',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 4. Message Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF2F3F5),
              border: Border(
                top: BorderSide(color: Colors.black12, width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE3E5E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Color(0xFF4F545C)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              onSubmitted: (_) => _handleSend(),
                              decoration: InputDecoration(
                                hintText: 'Message ${widget.channel.iconEmoji}${widget.channel.name}',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF747F8D),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          const Icon(Icons.sentiment_satisfied_alt,
                              color: Color(0xFF747F8D), size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send_rounded,
                        color: Color(0xFF5865F2)),
                    onPressed: _handleSend,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelWelcomeHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFE3E5E8),
            child: Text(
              widget.channel.iconEmoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Welcome to ${widget.channel.iconEmoji}${widget.channel.name}!',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3338),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This is the start of the ${widget.channel.name} channel in ${widget.server.name}.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF747F8D),
            ),
          ),
          const SizedBox(height: 16),
          _buildNewMessagesSeparator('NEW MESSAGES'),
        ],
      ),
    );
  }

  Widget _buildNewMessagesSeparator(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFF23F43), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFFF23F43),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFF23F43), thickness: 1)),
      ],
    );
  }

  Widget _buildDateSeparator(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Colors.black12)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              date,
              style: const TextStyle(
                color: Color(0xFF747F8D),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Expanded(child: Divider(color: Colors.black12)),
        ],
      ),
    );
  }

  Widget _buildMessageItem(DiscordMessage msg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (msg.dateHeader != null) _buildDateSeparator(msg.dateHeader!),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: msg.author.roleColor,
                child: ClipOval(
                  child: Image.network(
                    msg.author.avatarUrl,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: msg.author.id == 'user_duck'
                          ? const Text('🦆', style: TextStyle(fontSize: 20))
                          : Text(
                              msg.author.name.isNotEmpty
                                  ? msg.author.name[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author Header Row
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  msg.author.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF2E3338),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (msg.author.roleBadge.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: msg.author.roleColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    msg.author.roleBadge,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: msg.author.roleColor,
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(width: 8),
                              Text(
                                msg.timestamp,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF747F8D),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Delete Button Icon for individual message
                        if (widget.onDeleteMessage != null)
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                size: 16, color: Color(0xFF949BA4)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Delete message',
                            onPressed: () => _confirmDeleteMessage(context, msg),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Message Body Text (Supports Tag / Mention highlighting)
                    _buildFormattedText(msg.content, msg.isMention),

                    // Emoji Reactions Bar
                    if (msg.reactions.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        children: msg.reactions
                            .map((r) => ReactionChip(reaction: r))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDeleteMessage(BuildContext context, DiscordMessage msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Message', style: TextStyle(fontSize: 16)),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF23F43),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              if (widget.onDeleteMessage != null) {
                widget.onDeleteMessage!(msg);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedText(String text, bool isMention) {
    final spans = <InlineSpan>[];

    final words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (word.startsWith('@')) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFF5865F2).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                word,
                style: const TextStyle(
                  color: Color(0xFF5865F2),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
        spans.add(const TextSpan(text: ' '));
      } else if (word.startsWith('*') && word.endsWith('*') && word.length > 2) {
        spans.add(
          TextSpan(
            text: '${word.substring(1, word.length - 1)} ',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(0xFF2E3338),
              fontSize: 14,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              color: Color(0xFF2E3338),
              fontSize: 14,
              height: 1.3,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
