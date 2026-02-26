import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../theme/app_theme.dart';

class ShareCardTwitter extends StatelessWidget {
  final Quote quote;

  const ShareCardTwitter({
    super.key,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        border: Border.all(
          color: const Color(0xFF2f3336),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile row
          Row(
            children: [
              // Avatar - using Logo.png
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Name and handle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KalmFu Panda',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '@kalmfupanda',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quote text
          Expanded(
            child: Text(
              '"${quote.text}"',
              style: const TextStyle(
                fontSize: 18,
                height: 1.65,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Author line
          Text(
            '— ${quote.author}',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // Bottom bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _formatTime(DateTime.now()),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('·', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(width: 4),
                  const Text(
                    'KalmFu Panda',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1d9bf0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Credit line
              Text(
                'Find the way to Kalm Like Panda · Available on App Store',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

