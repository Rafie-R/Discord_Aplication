import 'package:flutter/material.dart';

class DiscordChannel {
  final String id;
  final String name;
  final String type; // 'text', 'announcement', 'rules', 'stage'
  final String iconEmoji;
  int unreadCount;
  final bool isLocked;

  DiscordChannel({
    required this.id,
    required this.name,
    this.type = 'text',
    this.iconEmoji = '#',
    this.unreadCount = 0,
    this.isLocked = false,
  });
}

class ChannelCategory {
  final String name;
  final List<DiscordChannel> channels;
  bool isExpanded;

  ChannelCategory({
    required this.name,
    required this.channels,
    this.isExpanded = true,
  });
}

class DiscordServer {
  final String id;
  final String name;
  final String iconText;
  final Color themeColor;
  final Color backgroundColor;
  final String bannerImageUrl;
  final int memberCount;
  final String serverType; // e.g. "Community"
  final int boostCount;
  final List<ChannelCategory> categories;

  int get totalUnreadCount => categories.fold(
        0,
        (sum, cat) =>
            sum + cat.channels.fold(0, (cSum, c) => cSum + c.unreadCount),
      );

  DiscordServer({
    required this.id,
    required this.name,
    required this.iconText,
    required this.themeColor,
    this.backgroundColor = const Color(0xFFF2F3F5),
    required this.bannerImageUrl,
    required this.memberCount,
    this.serverType = 'Community',
    required this.boostCount,
    required this.categories,
  });
}
