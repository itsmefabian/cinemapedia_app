class Actor {
  final int id;
  final String name;
  final String photoPath;
  final String? character;

  new({
    required this.id,
    required this.name,
    required this.photoPath,
    this.character,
  });
}
