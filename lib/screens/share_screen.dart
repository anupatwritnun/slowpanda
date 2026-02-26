import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/quote_model.dart';
import '../widgets/share_card_story.dart';
import '../widgets/share_card_apple_notes.dart';
import '../widgets/share_card_twitter.dart';
import '../theme/app_theme.dart';
import '../config/app_config.dart';

enum ShareCardType { colorful, appleNotes, twitter }

class ShareScreen extends StatefulWidget {
  final Quote quote;

  const ShareScreen({
    super.key,
    required this.quote,
  });

  static Future<void> show(BuildContext context, Quote quote) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => ShareScreen(quote: quote),
    );
  }

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  ShareCardType _selectedCard = ShareCardType.colorful;
  late PageController _pageController;

  final List<ShareCardType> _cardTypes = ShareCardType.values;

  int get _currentIndex => _cardTypes.indexOf(_selectedCard);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SHARE',
                      style: AppTextStyles.uiLabelAccent.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Swipe to preview styles',
                      style: AppTextStyles.uiLabel.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card preview with PageView for swipe
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedCard = _cardTypes[index];
                });
              },
              itemCount: _cardTypes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: RepaintBoundary(
                    key: ValueKey('card_$index'),
                    child: _buildCard(_cardTypes[index]),
                  ),
                );
              },
            ),
          ),

          // Dot indicators
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _cardTypes.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 24 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppColors.accentGold
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),

          // Share section label
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.share_rounded,
                  size: 16,
                  color: AppColors.textSecondary.withOpacity(0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  'SHARE TO',
                  style: AppTextStyles.uiLabel.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.6),
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Share buttons - logos centered together, no background
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildShareButton(
                  iconPath: 'assets/images/fb_logo.svg',
                  onTap: () => _shareToFacebook(),
                ),
                const SizedBox(width: 20),
                _buildShareButton(
                  iconPath: 'assets/images/ig_logo.svg',
                  onTap: () => _shareToInstagram(),
                ),
                const SizedBox(width: 20),
                _buildShareButton(
                  iconPath: 'assets/images/x_logo.svg',
                  onTap: () => _shareToTwitter(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCard(ShareCardType type) {
    switch (type) {
      case ShareCardType.colorful:
        return ShareCardStory(quote: widget.quote, isInstagram: true);
      case ShareCardType.appleNotes:
        return ShareCardAppleNotes(quote: widget.quote);
      case ShareCardType.twitter:
        return ShareCardTwitter(quote: widget.quote);
    }
  }

  Widget _buildShareButton({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        iconPath,
        width: 40,
        height: 40,
      ),
    );
  }

  Future<void> _shareToFacebook() async {
    final image = await _captureImage();
    if (image != null) {
      await Share.shareXFiles(
        [XFile(image)],
        text: '"${widget.quote.text}" — ${widget.quote.author}\n\n${AppConfig.shareCredit} - ${AppConfig.appStoreLink}',
      );
    }
  }

  Future<void> _shareToInstagram() async {
    final image = await _captureImage();
    if (image != null) {
      await Share.shareXFiles(
        [XFile(image)],
        text: '"${widget.quote.text}" — ${widget.quote.author}\n\n${AppConfig.shareCredit} - ${AppConfig.appStoreLink}',
      );
    }
  }

  Future<void> _shareToTwitter() async {
    final tweetText = '"${widget.quote.text}" — ${widget.quote.author}\n\n${AppConfig.shareCredit}\n${AppConfig.appStoreLink}: ${AppConfig.appStoreUrl}';
    final encodedTweet = Uri.encodeComponent(tweetText);
    final twitterUrl = '${AppConfig.twitterIntent}?text=$encodedTweet';

    if (await canLaunchUrl(Uri.parse(twitterUrl))) {
      await launchUrl(
        Uri.parse(twitterUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      final image = await _captureImage();
      if (image != null) {
        await Share.shareXFiles(
          [XFile(image)],
          text: tweetText,
        );
      }
    }
  }

  Future<String?> _captureImage() async {
    try {
      // Find the RepaintBoundary for the current card
      final context = _findCardContext();
      if (context == null) return null;

      final RenderRepaintBoundary boundary =
          context.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/kalmfupanda_share.png');
      await file.writeAsBytes(pngBytes);
      return file.path;
    } catch (e) {
      return null;
    }
  }

  BuildContext? _findCardContext() {
    switch (_selectedCard) {
      case ShareCardType.colorful:
        return _colorfulKey.currentContext;
      case ShareCardType.appleNotes:
        return _appleNotesKey.currentContext;
      case ShareCardType.twitter:
        return _twitterKey.currentContext;
    }
  }

  // Need to add GlobalKey fields
  final GlobalKey _colorfulKey = GlobalKey();
  final GlobalKey _appleNotesKey = GlobalKey();
  final GlobalKey _twitterKey = GlobalKey();
}
