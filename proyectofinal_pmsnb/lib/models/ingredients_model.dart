class ingredientsModel {
  String? name;
  String? image;

  ingredientsModel({this.name, this.image});

  factory ingredientsModel.fromJson(Map<String, dynamic> map) {
    return ingredientsModel(name: map['name'], image: map['image']);
  }

  get http => null;
}
