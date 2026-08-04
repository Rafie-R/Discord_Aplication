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

class DiscordUser {
  final String id;
  final String name;
  final String avatarUrl;
  final String roleBadge;
  final Color roleColor;
  final String status;

  DiscordUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.roleBadge = '',
    this.roleColor = const Color(0xFF5865F2),
    this.status = 'online',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatarUrl': avatarUrl,
        'roleBadge': roleBadge,
        'roleColor': roleColor.toARGB32(),
        'status': status,
      };

  factory DiscordUser.fromJson(Map<String, dynamic> json) => DiscordUser(
        id: json['id'] ?? 'user_duck',
        name: json['name'] ?? 'Duck',
        avatarUrl: json['avatarUrl'] ?? '',
        roleBadge: json['roleBadge'] ?? '',
        roleColor: Color(json['roleColor'] ?? 0xFF5865F2),
        status: json['status'] ?? 'online',
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
