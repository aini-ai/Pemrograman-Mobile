class Note {
  int? id;
  String title;
  String content;
  String category;
  DateTime createdAt;
  bool isFavorite;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
