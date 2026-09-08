import 'package:discord/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization info: $e");
  }
  runApp(const DiscordApp());
}

class DiscordApp extends StatelessWidget {
  const DiscordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discord Mobile & Desktop Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5865F2),
          primary: const Color(0xFF5865F2),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F3F5),
      ),
      home: const SplashScreen(),
    );
  }
}
