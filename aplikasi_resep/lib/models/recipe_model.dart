class Recipe {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final double rating;
  final String? area;
  final List<String>? tags;
  final String? youtubeUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    this.rating = 4.5,
    this.area,
    this.tags,
    this.youtubeUrl,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'instructions': instructions,
      'rating': rating,
      'area': area,
      'tags': tags,
      'youtubeUrl': youtubeUrl,
    };
  }

  // Create from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: json['instructions'] ?? '',
      rating: (json['rating'] ?? 4.5).toDouble(),
      area: json['area'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      youtubeUrl: json['youtubeUrl'],
    );
  }
}
