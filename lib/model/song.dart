import 'dart:convert';

class Song {
  String music;
  String name;
  String title;
  String url;
  String collection; // New field for collection name

  Song({
    required this.music,
    required this.name,
    required this.title,
    required this.url,
    required this.collection, // Added collection field
  });

  Song copyWith({
    String? music,
    String? name,
    String? title,
    String? url,
    String? collection, // Added collection field
  }) {
    return Song(
      music: music ?? this.music,
      name: name ?? this.name,
      title: title ?? this.title,
      url: url ?? this.url,
      collection: collection ?? this.collection, // Added collection field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'music': music,
      'name': name,
      'title': title,
      'url': url,
      'collection': collection, // Added collection field
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      music: map['music'] ?? '',
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      collection: map['collection'] ?? '', // Added collection field
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Song(music: $music, name: $name, title: $title, url: $url, collection: $collection)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Song &&
        other.music == music &&
        other.name == name &&
        other.title == title &&
        other.url == url &&
        other.collection == collection; // Added collection field
  }

  @override
  int get hashCode {
    return music.hashCode ^
    name.hashCode ^
    title.hashCode ^
    url.hashCode ^
    collection.hashCode; // Added collection field
  }
}
