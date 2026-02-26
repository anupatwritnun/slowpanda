import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../theme/app_theme.dart';

class ShareCardStory extends StatelessWidget {
  final Quote quote;
  final bool isInstagram; // true for IG, false for FB

  const ShareCardStory({
    super.key,
    required this.quote,
    this.isInstagram = true,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = isInstagram
        ? AppColors.igStoryGradient
        : AppColors.fbStoryGradient;

    // Generate stops based on number of colors
    final stops = List.generate(
      gradientColors.length,
      (index) => index / (gradientColors.length - 1),
    );

    return Container(
      width: 360,
      height: 640,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: stops,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Large quote mark (smaller)
                Text(
                  '"',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 40,
                    color: Colors.white.withOpacity(0.3),
                    fontStyle: FontStyle.italic,
                    height: 0.8,
                  ),
                ),

                const SizedBox(height: 8),

                // Quote text - wrapped to allow multiple lines
                Flexible(
                  child: Text(
                    '"${quote.text}"',
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 16),

                // Divider
                Container(
                  width: 28,
                  height: 2,
                  color: Colors.white.withOpacity(0.6),
                ),

                const SizedBox(height: 12),

                // Author
                Text(
                  '— ${quote.author.toUpperCase()}',
                  style: TextStyle(
                    fontFamily: 'Courier New',
                    fontSize: 11,
                    letterSpacing: 2.0,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 36),

                // Watermark and credits at bottom
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'KALMFU PANDA',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 9,
                        letterSpacing: 3.0,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Find the way to Kalm Like Panda',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 7,
                        letterSpacing: 1.5,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Available on App Store',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 7,
                        letterSpacing: 1.5,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
