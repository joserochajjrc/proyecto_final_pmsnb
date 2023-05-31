class SubscriptionModel {
  bool? Cremas;
  bool? Ensaladas;
  bool? Guisos;
  bool? Panes;
  bool? Postres;

  SubscriptionModel({
    this.Cremas,
    this.Ensaladas,
    this.Guisos,
    this.Panes,
    this.Postres,
  });

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      Cremas: map['Cremas'],
      Ensaladas: map['Ensaladas'],
      Guisos: map['Guisos'],
      Panes: map['Panes'],
      Postres: map['Postres'],
    );
  }
}
