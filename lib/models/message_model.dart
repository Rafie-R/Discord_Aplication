import 'package:flutter/material.dart';

class EmojiReaction {
  final String emoji;
  int count;
  bool isReacted;

  EmojiReaction({
    required this.emoji,
    required this.count,
    this.isReacted = false,
  });

  Map<String, dynamic> toJson() => {
        'emoji': emoji,
        'count': count,
        'isReacted': isReacted,
      };

  factory EmojiReaction.fromJson(Map<String, dynamic> json) => EmojiReaction(
        emoji: json['emoji'] ?? '👍',
        count: json['count'] ?? 1,
        isReacted: json['isReacted'] ?? false,
      );
}

class ShopItem {
  final String id;
  final String title;
  final String category;
  final String price;
  final String iconEmoji;
  final Color color;

  ShopItem({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.iconEmoji,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'price': price,
        'iconEmoji': iconEmoji,
        'color': color.toARGB32(),
      };

  factory ShopItem.fromJson(Map<String, dynamic> json) => ShopItem(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        category: json['category'] ?? '',
        price: json['price'] ?? '',
        iconEmoji: json['iconEmoji'] ?? '✨',
        color: Color(json['color'] ?? 0xFF5865F2),
      );
}

class DiscordUser {
  String id;
  String name;
  String avatarUrl;
  String roleBadge;
  Color roleColor;
  String status;
  String handle;
  String customStatus;
  String memberSince;
  int orbsBalance;
  String note;
  List<ShopItem> wishlist;
  List<DiscordUser> friends;

  DiscordUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.roleBadge = '',
    this.roleColor = const Color(0xFF5865F2),
    this.status = 'online',
    this.handle = 'gamerducky_ • Prime (R)',
    this.customStatus = 'What\'s on your mind?',
    this.memberSince = 'Jan 25, 2022',
    this.orbsBalance = 1250,
    this.note = '',
    List<ShopItem>? wishlist,
    List<DiscordUser>? friends,
  })  : wishlist = wishlist ?? [],
        friends = friends ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatarUrl': avatarUrl,
        'roleBadge': roleBadge,
        'roleColor': roleColor.toARGB32(),
        'status': status,
        'handle': handle,
        'customStatus': customStatus,
        'memberSince': memberSince,
        'orbsBalance': orbsBalance,
        'note': note,
        'wishlist': wishlist.map((item) => item.toJson()).toList(),
        'friends': friends.map((f) => f.toJson()).toList(),
      };

  factory DiscordUser.fromJson(Map<String, dynamic> json) => DiscordUser(
        id: json['id'] ?? 'user_duck',
        name: json['name'] ?? 'Duck',
        avatarUrl: json['avatarUrl'] ?? '',
        roleBadge: json['roleBadge'] ?? '',
        roleColor: Color(json['roleColor'] ?? 0xFF5865F2),
        status: json['status'] ?? 'online',
        handle: json['handle'] ?? 'gamerducky_ • Prime (R)',
        customStatus: json['customStatus'] ?? 'What\'s on your mind?',
        memberSince: json['memberSince'] ?? 'Jan 25, 2022',
        orbsBalance: json['orbsBalance'] ?? 1250,
        note: json['note'] ?? '',
        wishlist: (json['wishlist'] as List?)
                ?.map((item) => ShopItem.fromJson(item))
                .toList() ??
            [],
        friends: (json['friends'] as List?)
                ?.map((f) => DiscordUser.fromJson(f))
                .toList() ??
            [],
      );
}

class DiscordMessage {
  final String id;
  final DiscordUser author;
  final String content;
  final String timestamp;
  final String? dateHeader;
  final List<EmojiReaction> reactions;
  final bool isMention;

  DiscordMessage({
    required this.id,
    required this.author,
    required this.content,
    required this.timestamp,
    this.dateHeader,
    this.reactions = const [],
    this.isMention = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author.toJson(),
        'content': content,
        'timestamp': timestamp,
        'dateHeader': dateHeader,
        'reactions': reactions.map((r) => r.toJson()).toList(),
        'isMention': isMention,
      };

  factory DiscordMessage.fromJson(Map<String, dynamic> json) => DiscordMessage(
        id: json['id'] ?? '',
        author: DiscordUser.fromJson(json['author'] ?? {}),
        content: json['content'] ?? '',
        timestamp: json['timestamp'] ?? '',
        dateHeader: json['dateHeader'],
        reactions: (json['reactions'] as List?)
                ?.map((r) => EmojiReaction.fromJson(r))
                .toList() ??
            [],
        isMention: json['isMention'] ?? false,
      );
}
