import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../theme/app_theme.dart';

class ShareCardBold extends StatelessWidget {
  final Quote quote;

  const ShareCardBold({
    super.key,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    final words = quote.text.split(' ');
    final firstWord = words.isNotEmpty ? words[0] : '';
    final restOfQuote = words.skip(1).join(' ');

    return Container(
      width: 400,
      height: 400,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Quote text
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '"$firstWord ',
                  style: const TextStyle(
                    fontFamily: '.SF Pro Display',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentGold,
                    height: 1.4,
                  ),
                ),
                TextSpan(
                  text: '$restOfQuote"',
                  style: const TextStyle(
                    fontFamily: '.SF Pro Display',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Divider
          Container(
            width: 32,
            height: 2,
            color: AppColors.accentGold,
          ),

          const SizedBox(height: 24),

          // Author
          Text(
            '— ${quote.author.toUpperCase()}',
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 12,
              letterSpacing: 2.0,
              color: AppColors.textSecondary,
            ),
          ),

          const Spacer(),

          // Watermark
          Text(
            'KALMFU PANDA',
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 9,
              letterSpacing: 3.0,
              color: const Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 8),

          // Credit line
          Text(
            'Find the way to Kalm Like Panda',
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 7,
              letterSpacing: 1.5,
              color: const Color(0xFF333333).withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Available on App Store',
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 7,
              letterSpacing: 1.5,
              color: const Color(0xFF333333).withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
