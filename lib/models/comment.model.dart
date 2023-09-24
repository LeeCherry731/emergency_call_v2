class CommentModel {
  final String id;
  final String email;
  final String name;
  final String description;
  final String picture;
  final String createdAt;

  CommentModel({
    required this.id,
    required this.email,
    required this.name,
    required this.description,
    required this.picture,
    required this.createdAt,
  });

  String getDate() {
    final date = DateTime.parse(createdAt);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}:${date.second}";
  }
}
