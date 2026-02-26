/// App configuration constants
/// Centralized location for app-wide settings and URLs
class AppConfig {
  // App Information
  static const String appName = 'KalmFu Panda';
  static const String appHandle = '@kalmfupanda';
  static const String appTagline = 'Find the way to Kalm Like Panda';

  // Store URLs
  static const String appStoreUrl = 'https://apps.apple.com/app/kalmfupanda';
  static const String appStoreLink = 'Available on App Store';

  // Share Messages
  static const String shareCredit = '$appTagline 🐼';
  static const String shareStoreLink = '$appStoreLink: $appStoreUrl';

  // Settings
  static const int dailyQuoteCount = 5;
  static const Duration autoAdvanceDuration = Duration(seconds: 8);

  // Social Media
  static const String twitterIntent = 'https://twitter.com/intent/tweet';

  // API URLs
  static const String quotesApiUrl = 'https://zenquotes.io/api/random';
  static const int quotesApiBatchSize = 10; // Number of quotes to fetch per batch

  // Version
  static const String version = '1.0.0';
  static const int buildNumber = 1;
}
