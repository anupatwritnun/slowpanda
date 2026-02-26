import 'package:uuid/uuid.dart';

class Quote {
  final String id;
  final String text;
  final String author;
  final DateTime? savedAt;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    this.savedAt,
  });

  factory Quote.create({
    required String text,
    required String author,
  }) {
    return Quote(
      id: const Uuid().v4(),
      text: text,
      author: author,
    );
  }

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote.create(
      text: json['q'] ?? '',
      author: json['a'] ?? 'Unknown',
    );
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] as String,
      text: map['text'] as String,
      author: map['author'] as String,
      savedAt: map['savedAt'] != null
          ? DateTime.parse(map['savedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'savedAt': savedAt?.toIso8601String(),
    };
  }

  Quote copyWith({
    String? id,
    String? text,
    String? author,
    DateTime? savedAt,
  }) {
    return Quote(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  bool get isFavorited => savedAt != null;
}
