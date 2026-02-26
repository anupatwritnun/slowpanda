import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quote_model.dart';
import '../services/quote_service.dart';
import '../theme/app_theme.dart';
import '../widgets/quote_card.dart';
import '../config/app_config.dart';
import 'share_screen.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen>
    with TickerProviderStateMixin {
  late QuoteService _quoteService;

  // Quotes management
  final List<Quote> _quotes = [];
  int _currentQuoteIndex = 0;
  bool _isLoading = true;

  // Page controller for swipe
  late PageController _pageController;

  // Auto-advance timer
  Timer? _autoAdvanceTimer;

  // UI state
  bool _isShareSheetOpen = false;
  bool _showCopyFeedback = false;

  @override
  void initState() {
    super.initState();

    _quoteService = QuoteService();
    _pageController = PageController();

    // Load quotes
    _initializeQuotes();
  }

  Future<void> _initializeQuotes() async {
    await _quoteService.initialize();

    // Load initial quotes
    for (int i = 0; i < AppConfig.dailyQuoteCount; i++) {
      final quote = _quoteService.getNextQuote();
      if (quote != null) {
        _quotes.add(quote);
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Start auto-advance timer
      _startAutoAdvanceTimer();
    }
  }

  void _startAutoAdvanceTimer() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer.periodic(AppConfig.autoAdvanceDuration, (timer) {
      if (!_isShareSheetOpen && mounted) {
        _nextQuote();
      }
    });
  }

  void _resetAutoAdvanceTimer() {
    _autoAdvanceTimer?.cancel();
    _startAutoAdvanceTimer();
  }

  void _nextQuote() {
    if (_quotes.isEmpty) return;

    setState(() {
      _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
    });

    // Animate to the next page
    _pageController.animateToPage(
      _currentQuoteIndex,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    _resetAutoAdvanceTimer();
  }

  Future<void> _copyToClipboard() async {
    final quote = _quotes[_currentQuoteIndex];
    await Clipboard.setData(
      ClipboardData(text: '"${quote.text}" — ${quote.author}'),
    );

    HapticFeedback.mediumImpact();

    setState(() => _showCopyFeedback = true);

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() => _showCopyFeedback = false);
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showCopyFeedback = false);
      }
    });
  }

  Color get _currentAccentColor {
    return AppTheme.getAccentColor(_currentQuoteIndex);
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.accentGold,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Top accent bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                height: 3,
                color: _currentAccentColor,
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title and counter
                    Column(
                      children: [
                        Text(
                          'DAILY WISDOM',
                          style: AppTextStyles.uiLabelAccent.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(_currentQuoteIndex + 1).toString().padLeft(2, '0')} / ${_quotes.length.toString().padLeft(2, '0')}',
                          style: AppTextStyles.uiLabelAccent.copyWith(
                            color: _currentAccentColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quote display
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentQuoteIndex = index;
                    });
                    _resetAutoAdvanceTimer();
                  },
                  itemCount: _quotes.length,
                  itemBuilder: (context, index) {
                    return QuoteCard(
                      quote: _quotes[index],
                      accentColor: AppTheme.getAccentColor(index),
                      showWordAnimation: true,
                      animationIndex: _quotes[index].text.split(' ').length,
                    );
                  },
                ),
              ),

              // Bottom controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Share button
                        OutlinedButton.icon(
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('SHARE'),
                          onPressed: () async {
                            _isShareSheetOpen = true;
                            _autoAdvanceTimer?.cancel();
                            await ShareScreen.show(
                              context,
                              _quotes[_currentQuoteIndex],
                            );
                            _isShareSheetOpen = false;
                            _startAutoAdvanceTimer();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _currentAccentColor,
                            side: BorderSide(color: _currentAccentColor),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Copy button
                        OutlinedButton(
                          onPressed: _copyToClipboard,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _currentAccentColor,
                            side: BorderSide(color: _currentAccentColor),
                            minimumSize: const Size(48, 48),
                            padding: EdgeInsets.zero,
                          ),
                          child: _showCopyFeedback
                              ? Icon(
                                  Icons.check,
                                  color: _currentAccentColor,
                                )
                              : Icon(
                                  Icons.copy_all,
                                  color: _currentAccentColor,
                                ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Progress dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _quotes.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentQuoteIndex == index ? 24 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentQuoteIndex == index
                                ? _currentAccentColor
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Auto-advance hint
                    Text(
                      'auto-advances every ${AppConfig.autoAdvanceDuration.inSeconds}s',
                      style: AppTextStyles.uiLabel.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Copy feedback flash overlay
          if (_showCopyFeedback)
            AnimatedOpacity(
              opacity: _showCopyFeedback ? 0.08 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                color: _currentAccentColor,
              ),
            ),
        ],
      ),
    );
  }
}
