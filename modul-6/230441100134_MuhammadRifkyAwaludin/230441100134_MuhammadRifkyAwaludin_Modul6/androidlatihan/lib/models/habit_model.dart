class Habit {
  final int? id;
  final String tittle;
  final String description;
  final String date;
  final String location;
  final String imagePath;

  Habit({
    this.id,
    required this.tittle,
    required this.description,
    required this.date,
    required this.location,
    required this.imagePath,
  });

  // Tambahkan metode fromMap dan toMap jika perlu untuk SQLite, misalnya:
  factory Habit.fromMap(Map<String, dynamic> json) => Habit(
        id: json['id'],
        tittle: json['tittle'],
        description: json['description'],
        date: json['date'],
        location: json['location'],
        imagePath: json['imagePath'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tittle': tittle,
      'description': description,
      'date': date,
      'location': location,
      'imagePath': imagePath,
    };
  }
}
