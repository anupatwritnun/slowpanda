import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../theme/app_theme.dart';

class ShareCardAppleNotes extends StatelessWidget {
  final Quote quote;

  const ShareCardAppleNotes({
    super.key,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 500,
      decoration: BoxDecoration(
        // Cream color for Apple Notes style
        color: const Color(0xFFFDF6E3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quote mark (smaller)
          Text(
            '"',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 40,
              color: const Color(0xFF8B7355).withOpacity(0.2),
              height: 0.8,
            ),
          ),

          const SizedBox(height: 16),

          // Quote text - takes available space
          Text(
            '"${quote.text}"',
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: Color(0xFF3D3D3D),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 20),

          // Divider line
          Container(
            width: 32,
            height: 1,
            color: const Color(0xFF8B7355).withOpacity(0.3),
          ),

          const SizedBox(height: 16),

          // Author
          Text(
            '— ${quote.author}',
            style: const TextStyle(
              fontFamily: '.SF Pro Text',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B5B4F),
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Branding
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B7355),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'K',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'KalmFu Panda',
                    style: const TextStyle(
                      fontFamily: '.SF Pro Text',
                      fontSize: 10,
                      color: Color(0xFF8B7355),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Credit line
              Text(
                'Find the way to Kalm Like Panda',
                style: TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 7,
                  color: const Color(0xFF8B7355).withOpacity(0.7),
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Available on App Store',
                style: TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 7,
                  color: const Color(0xFF8B7355).withOpacity(0.7),
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
