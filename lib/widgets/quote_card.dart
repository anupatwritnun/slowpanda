import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../theme/app_theme.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final Color accentColor;
  final bool showWordAnimation;
  final int? animationIndex;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorited;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.accentColor,
    this.showWordAnimation = false,
    this.animationIndex,
    this.onTap,
    this.onFavorite,
    this.isFavorited = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large quote mark
            Opacity(
              opacity: 0.3,
              child: Text(
                '"',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 80,
                  color: accentColor,
                  height: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quote text with word animation
            if (showWordAnimation && animationIndex != null)
              _AnimatedQuoteText(
                text: quote.text,
                accentColor: accentColor,
                animationIndex: animationIndex!,
              )
            else
              Text(
                '"${quote.text}"',
                style: AppTextStyles.quoteDisplay,
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 32),

            // Divider
            Container(
              width: 32,
              height: 2,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),

            const SizedBox(height: 24),

            // Author
            Text(
              '— ${quote.author.toUpperCase()}',
              style: AppTextStyles.author.copyWith(
                color: accentColor,
              ),
              textAlign: TextAlign.center,
            ),

            // Favorite button (optional)
            if (onFavorite != null) ...[
              const SizedBox(height: 32),
              GestureDetector(
                onTap: onFavorite,
                child: AnimatedScale(
                  scale: isFavorited ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? AppColors.accentRed : accentColor,
                    size: 32,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnimatedQuoteText extends StatelessWidget {
  final String text;
  final Color accentColor;
  final int animationIndex;

  const _AnimatedQuoteText({
    required this.text,
    required this.accentColor,
    required this.animationIndex,
  });

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 8,
      children: List.generate(words.length, (index) {
        final isVisible = index < animationIndex;
        final isFirstWord = index == 0;

        return AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 25),
          child: AnimatedSlide(
            offset: Offset(0, isVisible ? 0 : 0.3),
            duration: const Duration(milliseconds: 25),
            curve: Curves.easeOut,
            child: Text(
              '${words[index]} ',
              style: AppTextStyles.quoteDisplay.copyWith(
                color: isFirstWord ? accentColor : AppColors.textPrimary,
                fontWeight: isFirstWord ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }
}
