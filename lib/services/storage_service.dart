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
}
