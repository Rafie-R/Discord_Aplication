import 'package:flutter/material.dart';
import '../data/mock_discord_data.dart';
import '../models/server_model.dart';
import '../models/message_model.dart';
import '../services/storage_service.dart';
import '../widgets/server_sidebar.dart';
import '../widgets/channel_list_panel.dart';
import '../widgets/chat_view_panel.dart';

class DiscordMainScreen extends StatefulWidget {
  const DiscordMainScreen({super.key});

  @override
  State<DiscordMainScreen> createState() => _DiscordMainScreenState();
}

class _DiscordMainScreenState extends State<DiscordMainScreen> {
  late DiscordServer _selectedServer;
  late DiscordChannel _selectedChannel;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _selectedServer = MockDiscordData.servers.first;
    _selectedChannel = _selectedServer.categories.first.channels.firstWhere(
      (c) => c.id == 'bd_announcements',
      orElse: () => _selectedServer.categories.first.channels.first,
    );
    if (_selectedChannel.unreadCount > 0) {
      _selectedChannel.unreadCount = 0;
    }
    _loadAllPersistedMessages();
  }

  Future<void> _loadAllPersistedMessages() async {
    for (var server in MockDiscordData.servers) {
      for (var cat in server.categories) {
        for (var channel in cat.channels) {
          final savedMessages = await StorageService.loadChannelMessages(channel.id);
          if (savedMessages != null && savedMessages.isNotEmpty) {
            setState(() {
              MockDiscordData.channelMessages[channel.id] = savedMessages;
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onServerSelected(DiscordServer server) {
    setState(() {
      _selectedServer = server;
      _selectedChannel = server.categories.first.channels.first;
      if (_selectedChannel.unreadCount > 0) {
        _selectedChannel.unreadCount = 0;
      }
    });
  }

  void _onChannelSelected(DiscordChannel channel) {
    setState(() {
      _selectedChannel = channel;
      if (channel.unreadCount > 0) {
        channel.unreadCount = 0;
      }
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleSendMessage(String text) async {
    final channelId = _selectedChannel.id;
    final messages = MockDiscordData.channelMessages[channelId] ??= [];
    final newMessage = DiscordMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      author: MockDiscordData.currentUser,
      content: text,
      timestamp: 'Just now',
    );

    setState(() {
      messages.add(newMessage);
    });

    // Save to local storage for persistent reload across F5 / refreshes!
    await StorageService.saveChannelMessages(channelId, messages);
  }

  @override
  Widget build(BuildContext context) {
    final messages = MockDiscordData.channelMessages[_selectedChannel.id] ?? [];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth >= 800;

          if (isWideScreen) {
            return Row(
              children: [
                ServerSidebar(
                  servers: MockDiscordData.servers,
                  selectedServer: _selectedServer,
                  onServerSelected: _onServerSelected,
                  user: MockDiscordData.currentUser,
                ),
                SizedBox(
                  width: 260,
                  child: ChannelListPanel(
                    server: _selectedServer,
                    selectedChannel: _selectedChannel,
                    onChannelSelected: _onChannelSelected,
                    currentUser: MockDiscordData.currentUser,
                  ),
                ),
                Expanded(
                  child: ChatViewPanel(
                    server: _selectedServer,
                    channel: _selectedChannel,
                    messages: messages,
                    onSendMessage: _handleSendMessage,
                  ),
                ),
              ],
            );
          } else {
            return PageView(
              controller: _pageController,
              children: [
                Row(
                  children: [
                    ServerSidebar(
                      servers: MockDiscordData.servers,
                      selectedServer: _selectedServer,
                      onServerSelected: _onServerSelected,
                      user: MockDiscordData.currentUser,
                    ),
                    Expanded(
                      child: ChannelListPanel(
                        server: _selectedServer,
                        selectedChannel: _selectedChannel,
                        onChannelSelected: _onChannelSelected,
                        currentUser: MockDiscordData.currentUser,
                      ),
                    ),
                  ],
                ),
                ChatViewPanel(
                  server: _selectedServer,
                  channel: _selectedChannel,
                  messages: messages,
                  onBackPressed: () {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  onSendMessage: _handleSendMessage,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
