import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';
import '../config/app_config.dart';

class QuoteService {
  // Quotable API - Free, no key required
  static const String _quotableApiUrl = 'https://api.quotable.io/quotes';
  static const int _apiFetchLimit = 50;

  // Fallback quotes when API fails - curated collection of wisdom
  static const List<Map<String, String>> fallbackQuotes = [
    // Wisdom & Success
    {'q': 'The only way to do great work is to love what you do.', 'a': 'Steve Jobs'},
    {'q': 'In the middle of every difficulty lies opportunity.', 'a': 'Albert Einstein'},
    {'q': 'The future belongs to those who believe in the beauty of their dreams.', 'a': 'Eleanor Roosevelt'},
    {'q': 'Success is not final, failure is not fatal: it is the courage to continue that counts.', 'a': 'Winston Churchill'},
    {'q': 'The best time to plant a tree was 20 years ago. The second best time is now.', 'a': 'Chinese Proverb'},

    // Mindfulness & Calm
    {'q': 'It does not matter how slowly you go as long as you do not stop.', 'a': 'Confucius'},
    {'q': 'Peace comes from within. Do not seek it without.', 'a': 'Buddha'},
    {'q': 'The present moment is filled with joy and happiness. If you are attentive, you will see it.', 'a': 'Thich Nhat Hanh'},
    {'q': 'Breath is the bridge which connects life to consciousness.', 'a': 'Thich Nhat Hanh'},
    {'q': 'Nature does not hurry, yet everything is accomplished.', 'a': 'Lao Tzu'},

    // Life & Perspective
    {'q': 'Life is what happens when you\'re busy making other plans.', 'a': 'John Lennon'},
    {'q': 'The journey of a thousand miles begins with a single step.', 'a': 'Lao Tzu'},
    {'q': 'Be yourself; everyone else is already taken.', 'a': 'Oscar Wilde'},
    {'q': 'In the end, it\'s not the years in your life that count. It\'s the life in your years.', 'a': 'Abraham Lincoln'},
    {'q': 'Life is really simple, but we insist on making it complicated.', 'a': 'Confucius'},

    // Creativity & Inspiration
    {'q': 'Creativity is intelligence having fun.', 'a': 'Albert Einstein'},
    {'q': 'The only way to do great work is to love what you do.', 'a': 'Steve Jobs'},
    {'q': 'Imagination is more important than knowledge.', 'a': 'Albert Einstein'},
    {'q': 'Every child is an artist. The problem is how to remain an artist once we grow up.', 'a': 'Pablo Picasso'},
    {'q': 'Do what you can, with what you have, where you are.', 'a': 'Theodore Roosevelt'},

    // Resilience & Strength
    {'q': 'That which does not kill us makes us stronger.', 'a': 'Friedrich Nietzsche'},
    {'q': 'Fall seven times, stand up eight.', 'a': 'Japanese Proverb'},
    {'q': 'After darkness, there is always light.', 'a': 'Japanese Proverb'},
    {'q': 'The greatest glory in living lies not in never falling, but in rising every time we fall.', 'a': 'Nelson Mandela'},
    {'q': 'This too shall pass.', 'a': 'Persian Proverb'},

    // Kindness & Love
    {'q': 'No act of kindness, no matter how small, is ever wasted.', 'a': 'Aesop'},
    {'q': 'The best way to find yourself is to lose yourself in the service of others.', 'a': 'Mahatma Gandhi'},
    {'q': 'Love and compassion are necessities, not luxuries. Without them, humanity cannot survive.', 'a': 'Dalai Lama'},
    {'q': 'We make a living by what we get, but we make a life by what we give.', 'a': 'Winston Churchill'},
    {'q': 'Kindness is a language which the deaf can hear and the blind can see.', 'a': 'Mark Twain'},
  ];

  final List<Quote> _quotes = [];

  // Initialize - try to fetch from API first, fallback to local quotes
  Future<void> initialize() async {
    if (_quotes.isEmpty) {
      final success = await _fetchQuotesFromApi();
      if (!success) {
        _loadRandomQuotes();
      }
    }
  }

  // Fetch quotes from Quotable API
  Future<bool> _fetchQuotesFromApi() async {
    try {
      final response = await http.get(
        Uri.parse('$_quotableApiUrl?limit=$_apiFetchLimit'),
      ).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Handle both list and paginated response formats
        List<dynamic> quotesList;
        if (jsonData is Map && jsonData.containsKey('results')) {
          quotesList = jsonData['results'] as List;
        } else if (jsonData is List) {
          quotesList = jsonData;
        } else {
          return false;
        }

        // Parse quotes and add random selection
        final random = Random();
        final availableIndices = List.generate(
          quotesList.length,
          (i) => i,
        );

        // Shuffle and pick quotes
        availableIndices.shuffle(random);

        int quotesNeeded = AppConfig.dailyQuoteCount;
        for (int i = 0; i < availableIndices.length && quotesNeeded > 0; i++) {
          final quoteData = quotesList[availableIndices[i]];
          final content = quoteData['content']?.toString().trim();
          final author = quoteData['author']?.toString().trim();
          final id = quoteData['_id']?.toString();

          // Filter out very short or empty quotes
          if (content != null &&
              content.length > 20 &&
              author != null &&
              author.isNotEmpty &&
              id != null) {
            _quotes.add(Quote(
              id: id,
              text: content,
              author: author,
            ));
            quotesNeeded--;
          }
        }

        return _quotes.isNotEmpty;
      }
      return false;
    } catch (e) {
      // API fetch failed - will use fallback quotes
      return false;
    }
  }

  // Load random quotes from fallback list
  void _loadRandomQuotes() {
    final random = Random();
    final availableIndices = List.generate(
      fallbackQuotes.length,
      (i) => i.toString(),
    ).toSet();

    // Load quotes based on AppConfig.dailyQuoteCount
    int quotesNeeded = AppConfig.dailyQuoteCount;
    while (quotesNeeded > 0 && availableIndices.isNotEmpty) {
      final indexList = availableIndices.toList();
      final randomIndex = random.nextInt(indexList.length);
      final quoteIndex = int.parse(indexList[randomIndex]);

      _quotes.add(Quote(
        id: 'quote_$quoteIndex',
        text: fallbackQuotes[quoteIndex]['q']!,
        author: fallbackQuotes[quoteIndex]['a']!,
      ));

      availableIndices.remove(indexList[randomIndex]);
      quotesNeeded--;
    }
  }

  // Get next quote (cycles through loaded quotes)
  Quote? getNextQuote() {
    if (_quotes.isEmpty) {
      return null;
    }
    final quote = _quotes.removeAt(0);
    _quotes.add(quote);
    return quote;
  }

  // Get a random quote from fallback (for variety)
  Quote? getRandomQuote() {
    final random = Random();
    final index = random.nextInt(fallbackQuotes.length);
    return Quote(
      id: 'quote_$index',
      text: fallbackQuotes[index]['q']!,
      author: fallbackQuotes[index]['a']!,
    );
  }

  // Get all quotes
  List<Quote> getAllQuotes() {
    return List.from(_quotes);
  }

  // Get cached quotes count
  int get quotesCount => _quotes.length;
}
