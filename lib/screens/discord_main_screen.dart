import 'package:flutter/material.dart';
import '../data/mock_discord_data.dart';
import '../models/server_model.dart';
import '../models/message_model.dart';
import '../services/storage_service.dart';
import '../widgets/server_sidebar.dart';
import '../widgets/channel_list_panel.dart';
import '../widgets/chat_view_panel.dart';
import 'user_profile_screen.dart';

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
    _loadAllPersistedData();
  }

  Future<void> _loadAllPersistedData() async {
    // Load User Profile
    final savedUser = await StorageService.loadUserProfile();
    if (savedUser != null) {
      setState(() {
        MockDiscordData.currentUser.id = savedUser.id;
        MockDiscordData.currentUser.name = savedUser.name;
        MockDiscordData.currentUser.avatarUrl = savedUser.avatarUrl;
        MockDiscordData.currentUser.status = savedUser.status;
        MockDiscordData.currentUser.handle = savedUser.handle;
        MockDiscordData.currentUser.customStatus = savedUser.customStatus;
        MockDiscordData.currentUser.memberSince = savedUser.memberSince;
        MockDiscordData.currentUser.orbsBalance = savedUser.orbsBalance;
        MockDiscordData.currentUser.note = savedUser.note;
        MockDiscordData.currentUser.wishlist = savedUser.wishlist;
        MockDiscordData.currentUser.friends = savedUser.friends;
      });
    }

    // Load Channel Messages
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

  void _openUserProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          user: MockDiscordData.currentUser,
          onUserUpdated: (updatedUser) {
            setState(() {
              MockDiscordData.currentUser = updatedUser;
            });
          },
        ),
      ),
    );
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

    await StorageService.saveChannelMessages(channelId, messages);
  }

  void _handleDeleteMessage(DiscordMessage msg) async {
    final channelId = _selectedChannel.id;
    final messages = MockDiscordData.channelMessages[channelId];
    if (messages != null) {
      setState(() {
        messages.removeWhere((m) => m.id == msg.id);
      });
      await StorageService.saveChannelMessages(channelId, messages);
    }
  }

  void _handleClearChannelHistory() async {
    final channelId = _selectedChannel.id;
    setState(() {
      MockDiscordData.channelMessages[channelId] = [];
    });
    await StorageService.clearChannelMessages(channelId);
  }

  void _handleResetAllStorage() async {
    await StorageService.clearAllStorage();
    if (!mounted) return;
    setState(() {
      MockDiscordData.channelMessages.clear();
      MockDiscordData.currentUser.customStatus = "What's on your mind?";
      MockDiscordData.currentUser.status = "online";
      MockDiscordData.currentUser.note = "";
      MockDiscordData.currentUser.wishlist.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All local storage cleared successfully!')),
    );
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
                  onUserProfileTap: _openUserProfile,
                ),
                SizedBox(
                  width: 260,
                  child: ChannelListPanel(
                    server: _selectedServer,
                    selectedChannel: _selectedChannel,
                    onChannelSelected: _onChannelSelected,
                    currentUser: MockDiscordData.currentUser,
                    onUserProfileTap: _openUserProfile,
                  ),
                ),
                Expanded(
                  child: ChatViewPanel(
                    server: _selectedServer,
                    channel: _selectedChannel,
                    messages: messages,
                    onSendMessage: _handleSendMessage,
                    onDeleteMessage: _handleDeleteMessage,
                    onClearChannelHistory: _handleClearChannelHistory,
                    onResetAllStorage: _handleResetAllStorage,
                    onUserProfileTap: _openUserProfile,
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
                      onUserProfileTap: _openUserProfile,
                    ),
                    Expanded(
                      child: ChannelListPanel(
                        server: _selectedServer,
                        selectedChannel: _selectedChannel,
                        onChannelSelected: _onChannelSelected,
                        currentUser: MockDiscordData.currentUser,
                        onUserProfileTap: _openUserProfile,
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
                  onDeleteMessage: _handleDeleteMessage,
                  onClearChannelHistory: _handleClearChannelHistory,
                  onResetAllStorage: _handleResetAllStorage,
                  onUserProfileTap: _openUserProfile,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
