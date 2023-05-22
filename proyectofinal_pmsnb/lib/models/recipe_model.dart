class RecipeModel {
  String? image;
  int? id;
  String? title;
  int? readyInMinutes;
  String? summary;
  List? ingredients;
  int? healthScore;
  String? calories;
  String? carbs;
  String? fat;
  String? protein;

  RecipeModel(
      {this.image,
      this.id,
      this.title,
      this.readyInMinutes,
      this.summary,
      this.ingredients,
      this.healthScore,
      this.calories,
      this.carbs,
      this.fat,
      this.protein});

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
        image: map['image'],
        id: map['id'],
        title: map['title'],
        readyInMinutes: map['readyInMinutes'],
        summary: map['summary'],
        ingredients: map['analyzedInstructions'],
        healthScore: map['healthScore'],
        calories: map['calories'],
        carbs: map['carbs'],
        fat: map['fat'],
        protein: map['protein']);
  }
}
