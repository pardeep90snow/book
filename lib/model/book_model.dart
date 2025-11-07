import 'dart:convert';

class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String? thumbnail;
  final String? description;
  final String? publisher;
  final String? publishedDate;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    this.thumbnail,
    this.description,
    this.publisher,
    this.publishedDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final bool hasVolumeInfo = json['volumeInfo'] != null;
    final Map<String, dynamic> volume = hasVolumeInfo
        ? (json['volumeInfo'] as Map<String, dynamic>)
        : json;

    final id =
        json['id']?.toString() ??
        json['bookId']?.toString() ??
        volume['id']?.toString() ??
        volume['title']?.toString() ??
        '';

    final title = volume['title']?.toString() ?? 'Untitled';

    final List<String> authors =
        (volume['authors'] as List?)
            ?.where((e) => e != null)
            .map((e) => e.toString())
            .toList() ??
        (json['authors'] as List?)?.map((e) => e.toString()).toList() ??
        <String>[];

    String? thumb;
    if (volume['imageLinks'] is Map) {
      final img = volume['imageLinks'] as Map<String, dynamic>;
      thumb = (img['thumbnail'] ?? img['smallThumbnail'])?.toString();
    } else if (json['thumbnail'] != null) {
      thumb = json['thumbnail']?.toString();
    }

    return Book(
      id: id,
      title: title,
      authors: authors,
      thumbnail: thumb,
      description: volume['description']?.toString() ?? json['description'],
      publisher: volume['publisher']?.toString() ?? json['publisher'],
      publishedDate:
          volume['publishedDate']?.toString() ?? json['publishedDate'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'authors': authors,
    'thumbnail': thumbnail,
    'description': description,
    'publisher': publisher,
    'publishedDate': publishedDate,
  };

  static List<Book> listFromJsonString(String jsonStr) {
    final List<dynamic> data = jsonDecode(jsonStr);
    return data.map((e) => Book.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJsonString(List<Book> books) {
    final list = books.map((b) => b.toJson()).toList();
    return jsonEncode(list);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
