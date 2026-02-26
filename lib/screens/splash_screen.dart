import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/panda_logo.dart';
import 'quote_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;

  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _taglineAnimation;

  @override
  void initState() {
    super.initState();

    // Force dark mode
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Tagline animation controller
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create animations
    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );

    _taglineAnimation = CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOut,
    );

    // Start animation sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Fade in logo
    await _logoController.forward();

    // Fade in wordmark
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      await _textController.forward();
    }

    // Fade in tagline
    await Future.delayed(const Duration(milliseconds: 50));
    if (mounted) {
      await _taglineController.forward();
    }

    // Navigate to quote screen
    await Future.delayed(const Duration(milliseconds: 1150));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const QuoteScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 380),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Panda Logo
            FadeTransition(
              opacity: _logoAnimation,
              child: ScaleTransition(
                scale: _logoAnimation,
                child: const PandaLogo(size: 120),
              ),
            ),

            const SizedBox(height: 32),

            // Wordmark
            FadeTransition(
              opacity: _textAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(_textAnimation),
                child: RichText(
                  text: TextSpan(
                    text: 'slow',
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 36,
                      color: AppColors.textPrimary,
                    ),
                    children: [
                      TextSpan(
                        text: 'panda',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 36,
                          color: AppColors.accentGold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Tagline
            FadeTransition(
              opacity: _taglineAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(_taglineAnimation),
                child: Text(
                  'words worth pausing for',
                  style: AppTextStyles.uiLabel.copyWith(
                    color: const Color(0xFF444444),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
