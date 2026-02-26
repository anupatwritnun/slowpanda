import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quote_model.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';
import 'share_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService.instance;
  late Future<List<Quote>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _favoritesService.getFavorites();
  }

  void _refreshFavorites() {
    setState(() {
      _favoritesFuture = _favoritesService.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SAVED QUOTES',
          style: AppTextStyles.uiLabelAccent.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Quote>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.accentGold,
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return _buildEmptyState();
          }

          final favorites = snapshot.data!;

          if (favorites.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final quote = favorites[index];
              return _buildQuoteCard(quote, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Panda logo
          SizedBox(
            width: 60,
            height: 60,
            child: CustomPaint(
              painter: _SimplePandaPainter(),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'nothing saved yet',
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'tap ♥ on a quote to save it',
            style: AppTextStyles.uiLabel.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(Quote quote, int index) {
    return Dismissible(
      key: Key(quote.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await _favoritesService.removeFavorite(quote.id);
        _refreshFavorites();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Quote removed from favorites'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'UNDO',
                textColor: AppColors.accentGold,
                onPressed: () async {
                  await _favoritesService.addFavorite(quote);
                  _refreshFavorites();
                },
              ),
            ),
          );
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.accentRed,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"${quote.text}"',
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '— ${quote.author.toUpperCase()}',
                    style: AppTextStyles.author.copyWith(
                      color: AppColors.accentGold,
                      fontSize: 11,
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Share button
                      IconButton(
                        icon: const Icon(Icons.share, size: 20),
                        color: AppColors.textSecondary,
                        onPressed: () {
                          ShareScreen.show(context, quote);
                        },
                      ),

                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: AppColors.textSecondary,
                        onPressed: () async {
                          await _favoritesService.removeFavorite(quote.id);
                          _refreshFavorites();

                          if (mounted) {
                            HapticFeedback.mediumImpact();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimplePandaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseSize = size.width;

    // Head
    final headPaint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: baseSize * 0.75,
        height: baseSize * 0.65,
      ),
      headPaint,
    );

    // Ears
    canvas.drawCircle(
      Offset(center.dx - baseSize * 0.28, center.dy - baseSize * 0.22),
      baseSize * 0.14,
      headPaint,
    );

    canvas.drawCircle(
      Offset(center.dx + baseSize * 0.28, center.dy - baseSize * 0.22),
      baseSize * 0.14,
      headPaint,
    );

    // Eye patches
    final eyePatchPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - baseSize * 0.12, center.dy - baseSize * 0.02),
        width: baseSize * 0.18,
        height: baseSize * 0.12,
      ),
      eyePatchPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + baseSize * 0.12, center.dy - baseSize * 0.02),
        width: baseSize * 0.18,
        height: baseSize * 0.12,
      ),
      eyePatchPaint,
    );

    // Sleepy eyes
    final eyePaint = Paint()
      ..color = AppColors.textPrimary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final leftEyePath = Path();
    leftEyePath.moveTo(center.dx - baseSize * 0.18, center.dy);
    leftEyePath.quadraticBezierTo(
      center.dx - baseSize * 0.12,
      center.dy + baseSize * 0.02,
      center.dx - baseSize * 0.06,
      center.dy,
    );
    canvas.drawPath(leftEyePath, eyePaint);

    final rightEyePath = Path();
    rightEyePath.moveTo(center.dx + baseSize * 0.06, center.dy);
    rightEyePath.quadraticBezierTo(
      center.dx + baseSize * 0.12,
      center.dy + baseSize * 0.02,
      center.dx + baseSize * 0.18,
      center.dy,
    );
    canvas.drawPath(rightEyePath, eyePaint);

    // Nose
    final nosePaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + baseSize * 0.1),
        width: baseSize * 0.08,
        height: baseSize * 0.05,
      ),
      nosePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
