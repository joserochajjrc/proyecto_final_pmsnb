class RecipeModel {
  String? image;
  int? id;
  String? title;
  int? readyInMinutes;
  String? summary;
  List? ingredients;

  RecipeModel(
      {this.image,
      this.id,
      this.title,
      this.readyInMinutes,
      this.summary,
      this.ingredients});

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
        image: map['image'],
        id: map['id'],
        title: map['title'],
        readyInMinutes: map['readyInMinutes'],
        summary: map['summary'],
        ingredients: map['ingredients']);
  }
}
