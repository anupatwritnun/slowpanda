import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quote_model.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites';
  static FavoritesService? _instance;
  static FavoritesService get instance => _instance ??= FavoritesService._();
  FavoritesService._();

  final _controller = StreamController<List<Quote>>.broadcast();
  List<Quote>? _cachedFavorites;

  // Stream of favorites list
  Stream<List<Quote>> get favoritesStream => _controller.stream;

  // Get all favorites
  Future<List<Quote>> getFavorites() async {
    if (_cachedFavorites != null) {
      return _cachedFavorites!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson != null) {
        final List<dynamic> decoded = json.decode(favoritesJson);
        _cachedFavorites = decoded
            .map((item) => Quote.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        _cachedFavorites = [];
      }
    } catch (e) {
      _cachedFavorites = [];
    }

    return _cachedFavorites!;
  }

  // Add quote to favorites
  Future<void> addFavorite(Quote quote) async {
    final favorites = await getFavorites();

    // Check if already exists
    if (favorites.any((q) => q.id == quote.id)) {
      return;
    }

    final updatedQuote = quote.copyWith(savedAt: DateTime.now());
    favorites.add(updatedQuote);

    await _saveFavorites(favorites);
    _controller.add(favorites);
  }

  // Remove quote from favorites
  Future<void> removeFavorite(String quoteId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((q) => q.id == quoteId);

    await _saveFavorites(favorites);
    _controller.add(favorites);
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(Quote quote) async {
    final favorites = await getFavorites();
    final exists = favorites.any((q) => q.id == quote.id);

    if (exists) {
      await removeFavorite(quote.id);
      return false;
    } else {
      await addFavorite(quote);
      return true;
    }
  }

  // Check if quote is favorited
  Future<bool> isFavorited(String quoteId) async {
    final favorites = await getFavorites();
    return favorites.any((q) => q.id == quoteId);
  }

  // Get favorites count
  Future<int> getFavoritesCount() async {
    final favorites = await getFavorites();
    return favorites.length;
  }

  // Save favorites to local storage
  Future<void> _saveFavorites(List<Quote> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(
        favorites.map((q) => q.toMap()).toList(),
      );
      await prefs.setString(_favoritesKey, favoritesJson);
      _cachedFavorites = favorites;
    } catch (e) {
      // Handle error silently
    }
  }

  // Clear all favorites
  Future<void> clearFavorites() async {
    await _saveFavorites([]);
    _controller.add([]);
  }

  // Dispose
  void dispose() {
    _controller.close();
  }
}
