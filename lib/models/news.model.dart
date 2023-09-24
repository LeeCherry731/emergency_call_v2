class NewsModel {
  final String id;
  final String email;
  final String name;
  final String title;
  final String phone;
  final String image;
  final String description;
  final String createdAt;
  final String updatedAt;

  NewsModel(
      {required this.id,
      required this.email,
      required this.name,
      required this.title,
      required this.phone,
      required this.image,
      required this.description,
      required this.createdAt,
      required this.updatedAt});
}
