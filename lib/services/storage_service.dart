import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_model.dart';

class StorageService {
  static const String _messagesKeyPrefix = 'discord_messages_';

  // Save messages for a specific channel to SharedPreferences
  static Future<void> saveChannelMessages(
      String channelId, List<DiscordMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = messages.map((m) => m.toJson()).toList();
      await prefs.setString(_messagesKeyPrefix + channelId, jsonEncode(jsonList));
    } catch (e) {
      // Fallback
    }
  }

  // Load messages for a channel from SharedPreferences
  static Future<List<DiscordMessage>?> loadChannelMessages(
      String channelId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(_messagesKeyPrefix + channelId);
      if (rawJson != null && rawJson.isNotEmpty) {
        final List decoded = jsonDecode(rawJson);
        return decoded.map((m) => DiscordMessage.fromJson(m)).toList();
      }
    } catch (e) {
      // Fallback
    }
    return null;
  }

  // Clear messages for a specific channel
  static Future<void> clearChannelMessages(String channelId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_messagesKeyPrefix + channelId);
    } catch (e) {
      // Fallback
    }
  }

  // Clear all persistent storage (reset app data)
  static Future<void> clearAllStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      // Fallback
    }
  }

  // Save current user profile data
  static Future<void> saveUserProfile(DiscordUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('discord_user_profile', jsonEncode(user.toJson()));
    } catch (e) {
      // Fallback
    }
  }

  // Load current user profile data
  static Future<DiscordUser?> loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('discord_user_profile');
      if (raw != null && raw.isNotEmpty) {
        return DiscordUser.fromJson(jsonDecode(raw));
      }
    } catch (e) {
      // Fallback
    }
    return null;
  }
}
