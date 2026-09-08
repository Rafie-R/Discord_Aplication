import 'dart:async';
import 'dart:math' as math;
import 'package:discord/screens/discord_main_screen.dart';
import 'package:discord/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final AnimationController _floatController;
  late final AnimationController _progressController;

  // Animations
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _floatAnimation;

  // Status message state
  String _statusMessage = 'Connecting to Discord gateway...';
  Timer? _navigationTimer;
  Timer? _statusTimer1;
  Timer? _statusTimer2;

  @override
  void initState() {
    super.initState();

    // 1. Entrance Controller (Scale + Fade in)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.elasticOut,
      ),
    );

    // 2. Pulse Controller (Continuous glowing aura breathing)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // 3. Float Controller (Gentle Y-axis floating movement)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    // 4. Progress Bar Controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Start entrance & progress
    _entranceController.forward();
    _progressController.forward();

    // Multi-stage status message updates
    _statusTimer1 = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _statusMessage = 'Loading servers & channels...';
        });
      }
    });

    _statusTimer2 = Timer(const Duration(milliseconds: 2300), () {
      if (mounted) {
        setState(() {
          _statusMessage = 'Ready to talk & hang out!';
        });
      }
    });

    // Navigate to Login or Main Screen based on auth state
    _navigationTimer = Timer(const Duration(milliseconds: 3300), () {
      if (mounted) {
        final currentUser = FirebaseAuth.instance.currentUser;
        final Widget targetScreen = currentUser != null
            ? const DiscordMainScreen()
            : const LoginScreen();

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                targetScreen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.05, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 700),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _statusTimer1?.cancel();
    _statusTimer2?.cancel();
    _entranceController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const blurple = Color(0xFF5865F2);
    const deepDarkBg = Color(0xFF101114);
    const darkSurfaceBg = Color(0xFF1E1F22);

    return Scaffold(
      backgroundColor: deepDarkBg,
      body: Stack(
        children: [
          // Background Animated Mesh Glow & Particles
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Stack(
                children: [
                  // Center radial Blurple glow aura
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.15),
                          radius: 0.85 * _pulseAnimation.value,
                          colors: [
                            blurple.withValues(alpha: 0.35),
                            const Color(0xFF313338).withValues(alpha: 0.15),
                            deepDarkBg,
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Top right ambient light orb
                  Positioned(
                    top: -80,
                    right: -80,
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF7289DA).withValues(
                          alpha: 0.12 * _pulseAnimation.value,
                        ),
                      ),
                    ),
                  ),

                  // Bottom left accent orb
                  Positioned(
                    bottom: -100,
                    left: -100,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEB459E).withValues(
                          alpha: 0.08 * (2.0 - _pulseAnimation.value),
                        ),
                      ),
                    ),
                  ),

                  // Subtle subtle grid/particle canvas
                  CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: _BackgroundParticlePainter(
                      pulseValue: _pulseAnimation.value,
                    ),
                  ),
                ],
              );
            },
          ),

          // Main Foreground Content
          Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _pulseController,
                      _floatController,
                    ]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 1. Clyde Logo Glassmorphism Container with Dynamic Glow Aura
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    blurple,
                                    const Color(0xFF4752C4),
                                  ],
                                ),
                                boxShadow: [
                                  // Primary Blurple Glow
                                  BoxShadow(
                                    color: blurple.withValues(
                                      alpha: 0.55 * _pulseAnimation.value,
                                    ),
                                    blurRadius: 36 * _pulseAnimation.value,
                                    spreadRadius: 4 * _pulseAnimation.value,
                                    offset: const Offset(0, 8),
                                  ),
                                  // Outer Ambient Neon Glow
                                  BoxShadow(
                                    color: const Color(0xFF7289DA).withValues(
                                      alpha: 0.3 * _pulseAnimation.value,
                                    ),
                                    blurRadius: 60,
                                    spreadRadius: 10,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(22.0),
                                  child: SvgPicture.asset(
                                    'images/dc.svg',
                                    fit: BoxFit.contain,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 36),

                            // 2. Brand Title Text ("DISCORD")
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Colors.white,
                                  Color(0xFFE0E5FF),
                                  Color(0xFFB5C2FF),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds),
                              child: const Text(
                                'DISCORD',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 4.5,
                                  fontFamily: 'sans-serif',
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 3. Tagline ("Imagine a place...")
                            Text(
                              'Imagine a place...',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.7),
                                letterSpacing: 0.8,
                              ),
                            ),

                            const SizedBox(height: 48),

                            // 4. Custom Animated Progress Capsule & Status
                            Container(
                              width: 220,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: darkSurfaceBg.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Sleek Progress Track & Bar
                                  AnimatedBuilder(
                                    animation: _progressController,
                                    builder: (context, child) {
                                      return LayoutBuilder(
                                        builder: (context, constraints) {
                                          final totalWidth =
                                              constraints.maxWidth;
                                          final progressWidth =
                                              totalWidth *
                                                  _progressController.value;

                                          return Stack(
                                            children: [
                                              // Track background
                                              Container(
                                                height: 5,
                                                width: totalWidth,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                ),
                                              ),
                                              // Glowing Active Fill
                                              Container(
                                                height: 5,
                                                width: progressWidth,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      blurple,
                                                      Color(0xFF7289DA),
                                                      Color(0xFF00D166),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: blurple.withValues(
                                                        alpha: 0.8,
                                                      ),
                                                      blurRadius: 8,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  // Dynamic Status Message
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 350),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 0.2),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      _statusMessage,
                                      key: ValueKey<String>(_statusMessage),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withValues(
                                          alpha: 0.75,
                                        ),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for background ambient stars/particles effect
class _BackgroundParticlePainter extends CustomPainter {
  final double pulseValue;

  _BackgroundParticlePainter({required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12 * pulseValue)
      ..style = PaintingStyle.fill;

    // Deterministic particle coordinates for visual elegance
    final particles = [
      Offset(size.width * 0.15, size.height * 0.2),
      Offset(size.width * 0.82, size.height * 0.18),
      Offset(size.width * 0.25, size.height * 0.75),
      Offset(size.width * 0.88, size.height * 0.82),
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.1, size.height * 0.5),
      Offset(size.width * 0.9, size.height * 0.48),
    ];

    final sizes = [2.0, 3.0, 2.5, 1.8, 2.2, 3.2, 2.0];

    for (int i = 0; i < particles.length; i++) {
      final double radius = sizes[i] * (0.8 + 0.4 * math.sin(pulseValue * math.pi + i));
      canvas.drawCircle(particles[i], radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundParticlePainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue;
  }
}
