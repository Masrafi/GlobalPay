final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, price, title, description, time, rating, image,
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String price = 'price';
  static final String title = 'title';
  static final String rating = 'rating';
  static final String image = 'image';
  static final String description = 'description';
  static final String time = 'time';
}

class Note {
  final int? id;
  final bool isImportant;
  final String price;
  final String title;
  final String description;
  final DateTime createdTime;
  final String rating;
  final String image;

  const Note({
    this.id,
    required this.isImportant,
    required this.price,
    required this.image,
    required this.description,
    required this.createdTime,
    required this.title,
    required this.rating,
  });

  Note copy({
    int? id,
    bool? isImportant,
    String? price,
    String? title,
    String? rating,
    String? image,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        price: price ?? this.price,
        image: title ?? this.image,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
        title: title ?? this.title,
        rating: title ?? this.rating,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        isImportant: json[NoteFields.isImportant] == 1,
        price: json[NoteFields.price] as String,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        createdTime: DateTime.parse(json[NoteFields.time] as String),
        rating: json[NoteFields.rating] as String,
        image: json[NoteFields.image] as String,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.price: price,
        NoteFields.description: description,
        NoteFields.time: createdTime.toIso8601String(),
        NoteFields.rating: rating,
        NoteFields.image: image,
      };
}
