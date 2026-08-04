import 'package:flutter/material.dart';
import '../models/server_model.dart';
import '../models/message_model.dart';

class MockDiscordData {
  static final DiscordUser currentUser = DiscordUser(
    id: 'user_duck',
    name: 'Duck',
    avatarUrl: 'https://api.dicebear.com/7.x/bottts/png?seed=Duck',
    status: 'online',
  );

  static final DiscordUser laneUser = DiscordUser(
    id: 'user_lane',
    name: 'Lane',
    roleBadge: '⚔️ BOOT',
    roleColor: const Color(0xFFE91E63),
    avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
  );

  static final DiscordUser ottimyrUser = DiscordUser(
    id: 'user_ottimyr',
    name: 'Óttimyr',
    roleBadge: '💀 .gd',
    roleColor: const Color(0xFF9C27B0),
    avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
  );

  static final DiscordUser craftwarsAdmin = DiscordUser(
    id: 'user_craftwars',
    name: 'Craftwars Dev',
    roleBadge: '🛡️ ADMIN',
    roleColor: const Color(0xFF4CAF50),
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
  );

  static final List<DiscordServer> servers = [
    // 1. Boot.dev
    DiscordServer(
      id: 'boot_dev',
      name: 'Boot.dev - Learn to Code',
      iconText: 'BOOT',
      themeColor: const Color(0xFFF7F5F0),
      backgroundColor: const Color(0xFFF3EFE6),
      bannerImageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800',
      memberCount: 88612,
      boostCount: 53,
      categories: [
        ChannelCategory(
          name: 'info',
          channels: [
            DiscordChannel(
              id: 'bd_start',
              name: 'start-here',
              iconEmoji: '🐍',
              type: 'text',
            ),
            DiscordChannel(
              id: 'bd_announcements',
              name: 'announcements',
              iconEmoji: '📢',
              type: 'announcement',
              unreadCount: 3,
            ),
            DiscordChannel(
              id: 'bd_youtube',
              name: 'youtube',
              iconEmoji: '🎥',
              type: 'text',
            ),
          ],
        ),
        ChannelCategory(
          name: 'Welcome',
          channels: [
            DiscordChannel(
              id: 'bd_welcome',
              name: 'welcome',
              iconEmoji: '🎉',
              type: 'text',
            ),
            DiscordChannel(
              id: 'bd_introductions',
              name: 'introductions',
              iconEmoji: '👋',
              type: 'text',
            ),
            DiscordChannel(
              id: 'bd_checkin',
              name: 'checkin',
              iconEmoji: '⏰',
              type: 'text',
              unreadCount: 3,
            ),
            DiscordChannel(
              id: 'bd_stage',
              name: 'stage',
              iconEmoji: '🎙️',
              type: 'stage',
            ),
          ],
        ),
        ChannelCategory(
          name: 'lounges',
          channels: [
            DiscordChannel(
              id: 'bd_apprentice',
              name: 'apprentice',
              iconEmoji: '🧙',
              type: 'text',
            ),
            DiscordChannel(
              id: 'bd_starter',
              name: 'starter-lounge',
              iconEmoji: '🏠',
              type: 'text',
            ),
          ],
        ),
        ChannelCategory(
          name: 'help',
          channels: [
            DiscordChannel(
              id: 'bd_help_learning',
              name: 'help-learning',
              iconEmoji: '🐍',
              type: 'text',
            ),
          ],
        ),
      ],
    ),

    // 2. Official Balanced Craftwars
    DiscordServer(
      id: 'balanced_craftwars',
      name: 'Official Balanced Craftwars ...',
      iconText: 'BCW',
      themeColor: const Color(0xFFF5F2F9),
      backgroundColor: const Color(0xFFEEEAF4),
      bannerImageUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=800',
      memberCount: 37896,
      boostCount: 50,
      categories: [
        ChannelCategory(
          name: 'General',
          channels: [
            DiscordChannel(
              id: 'bcw_rules',
              name: 'rules',
              iconEmoji: '☑️',
              type: 'rules',
            ),
            DiscordChannel(
              id: 'bcw_roles',
              name: 'roles',
              iconEmoji: '#',
              type: 'text',
              unreadCount: 1,
            ),
          ],
        ),
        ChannelCategory(
          name: 'Important',
          channels: [
            DiscordChannel(
              id: 'bcw_announcements',
              name: 'announcements',
              iconEmoji: '📢',
              type: 'announcement',
              unreadCount: 8,
            ),
            DiscordChannel(
              id: 'bcw_side_announcements',
              name: 'side-announcements',
              iconEmoji: '📢',
              type: 'announcement',
            ),
            DiscordChannel(
              id: 'bcw_changelog',
              name: 'changelog',
              iconEmoji: '📢',
              type: 'announcement',
            ),
            DiscordChannel(
              id: 'bcw_stuff',
              name: 'bcw-stuff',
              iconEmoji: '📢',
              type: 'announcement',
              unreadCount: 1,
            ),
            DiscordChannel(
              id: 'bcw_poll',
              name: 'poll',
              iconEmoji: '#',
              type: 'text',
              isLocked: true,
            ),
            DiscordChannel(
              id: 'bcw_boosts',
              name: 'server-boosts',
              iconEmoji: '#',
              type: 'text',
              isLocked: true,
            ),
            DiscordChannel(
              id: 'bcw_mod_guidelines',
              name: 'mod-guidelines',
              iconEmoji: '#',
              type: 'text',
              isLocked: true,
            ),
          ],
        ),
      ],
    ),

    // 3. The Forge Official Community
    DiscordServer(
      id: 'the_forge',
      name: 'The Forge Official Community',
      iconText: 'FORGE',
      themeColor: const Color(0xFFF9F3F0),
      backgroundColor: const Color(0xFFF3ECE8),
      bannerImageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800',
      memberCount: 1523126,
      boostCount: 338,
      categories: [
        ChannelCategory(
          name: 'Verification',
          channels: [
            DiscordChannel(
              id: 'tf_welcome',
              name: 'welcome',
              iconEmoji: '#',
              type: 'text',
            ),
            DiscordChannel(
              id: 'tf_verification',
              name: 'verification',
              iconEmoji: '#',
              type: 'text',
            ),
          ],
        ),
        ChannelCategory(
          name: '✦ - Community Server',
          channels: [
            DiscordChannel(
              id: 'tf_rules',
              name: '✦ • rules',
              iconEmoji: '☑️',
              type: 'rules',
            ),
            DiscordChannel(
              id: 'tf_information',
              name: '✦ • information',
              iconEmoji: '#',
              type: 'text',
            ),
            DiscordChannel(
              id: 'tf_announcements',
              name: '✦ • announcements',
              iconEmoji: '📢',
              type: 'announcement',
            ),
            DiscordChannel(
              id: 'tf_side_announcements',
              name: '✦ • side-announcements',
              iconEmoji: '📢',
              type: 'announcement',
            ),
            DiscordChannel(
              id: 'tf_social_media',
              name: '✦ • social-media',
              iconEmoji: '📢',
              type: 'announcement',
              unreadCount: 4,
            ),
            DiscordChannel(
              id: 'tf_roles',
              name: '✦ • roles',
              iconEmoji: '#',
              type: 'text',
            ),
          ],
        ),
      ],
    ),

    // 4. The Sloth Realm
    DiscordServer(
      id: 'sloth_realm',
      name: 'The Sloth Realm!',
      iconText: 'SLOTH',
      themeColor: const Color(0xFFE8F5E9),
      backgroundColor: const Color(0xFFE0F2F1),
      bannerImageUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=800',
      memberCount: 42100,
      boostCount: 18,
      categories: [
        ChannelCategory(
          name: 'General Sloth',
          channels: [
            DiscordChannel(id: 'sr_general', name: 'general-chat', iconEmoji: '#'),
            DiscordChannel(id: 'sr_memes', name: 'sloth-memes', iconEmoji: '#', unreadCount: 1),
          ],
        )
      ],
    ),

    // 5. Tower Blitz
    DiscordServer(
      id: 'tower_blitz',
      name: 'Tower Blitz Official',
      iconText: 'TOWER',
      themeColor: const Color(0xFFFFF3E0),
      backgroundColor: const Color(0xFFFFE0B2),
      bannerImageUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800',
      memberCount: 95400,
      boostCount: 64,
      categories: [
        ChannelCategory(
          name: 'Tower Strategy',
          channels: [
            DiscordChannel(id: 'tb_updates', name: 'game-updates', iconEmoji: '📢', unreadCount: 31),
            DiscordChannel(id: 'tb_strategies', name: 'tactics', iconEmoji: '#'),
          ],
        )
      ],
    ),
  ];

  static Map<String, List<DiscordMessage>> channelMessages = {
    'bd_announcements': [
      DiscordMessage(
        id: 'msg_1',
        author: laneUser,
        timestamp: '03/14/2026 6:07 AM',
        content:
            'You can now generate a "share link" for coding lessons by clicking the share icon at the bottom of the lesson explanation. This is the preferred way to ask for help in the Discord, as it includes your code in the link when another student clicks it.',
        reactions: [
          EmojiReaction(emoji: '👍', count: 38),
          EmojiReaction(emoji: '🍺', count: 14),
          EmojiReaction(emoji: '🇵🇰', count: 4),
          EmojiReaction(emoji: '🇵🇸', count: 18),
          EmojiReaction(emoji: '🇧🇩', count: 7),
          EmojiReaction(emoji: '🇺🇦', count: 7),
          EmojiReaction(emoji: '🇳', count: 6),
          EmojiReaction(emoji: '🇴', count: 6),
          EmojiReaction(emoji: '🇼', count: 6),
          EmojiReaction(emoji: '🇪🇬', count: 2),
          EmojiReaction(emoji: '🇧🇷', count: 2),
          EmojiReaction(emoji: '🇮🇱', count: 4),
          EmojiReaction(emoji: '🔥', count: 5),
          EmojiReaction(emoji: '❤️', count: 1),
        ],
      ),
      DiscordMessage(
        id: 'msg_2',
        author: laneUser,
        timestamp: '03/16/2026 10:23 PM',
        dateHeader: 'March 16, 2026',
        content:
            'Good morning @notify-reminder !!! We\'ve been secretly working on a new logo for the last couple of months with a designer, and we\'re finally ready to launch it!!! Expect to see the site and various assets updating throughout the week',
        isMention: true,
        reactions: [
          EmojiReaction(emoji: '🚀', count: 42, isReacted: true),
          EmojiReaction(emoji: '🎉', count: 29),
          EmojiReaction(emoji: '🔥', count: 19),
        ],
      ),
    ],
    'bd_checkin': [
      DiscordMessage(
        id: 'msg_3',
        author: ottimyrUser,
        timestamp: '07/31/2026 5:14 PM',
        content:
            'Super random but this is huge for me: I managed to build full prediction smoothing for all client inputs in my multiplayer game! So I get instant movement locally while server rolls back smoothly if needed.\n\nAdditionally, I managed to build dummy clients for stress testing the network code under 300ms latency. Working like a charm!',
        reactions: [
          EmojiReaction(emoji: '🔥', count: 12),
          EmojiReaction(emoji: '💪', count: 8),
          EmojiReaction(emoji: '🚀', count: 15),
        ],
      ),
      DiscordMessage(
        id: 'msg_4',
        author: laneUser,
        timestamp: '07/31/2026 5:45 PM',
        content:
            'That\'s massive @Óttimyr! Prediction smoothing in client-side prediction is one of the hardest networking challenges in gamedev. Excellent work! 👏',
        reactions: [
          EmojiReaction(emoji: '🙌', count: 5),
        ],
      ),
    ],
    'bcw_rules': [
      DiscordMessage(
        id: 'msg_5',
        author: craftwarsAdmin,
        timestamp: '01/10/2026 12:00 PM',
        content:
            'Welcome to Official Balanced Craftwars!\n1. Be respectful to all members.\n2. No spamming or advertising.\n3. Keep topics relevant to their respective channels.\n4. Have fun crafting and battling!',
        reactions: [
          EmojiReaction(emoji: '✅', count: 1540),
          EmojiReaction(emoji: '⚔️', count: 890),
        ],
      )
    ],
  };
}
