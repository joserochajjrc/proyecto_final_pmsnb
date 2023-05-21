class UserModel{
  String? idUser;
  String? imageUser;
  String? nameUser;
  String? emailUser;
  String? proveedorUser;

  UserModel({this.idUser,this.imageUser,this.nameUser,this.emailUser,this.proveedorUser});
  

  factory UserModel.fromJSON(Map<String, dynamic> mapUser) {
    return UserModel(
      idUser: mapUser['idUser'],
      imageUser: mapUser['imageUser']??"../assets/avatar.png",
      nameUser: mapUser['nameUser']??"",
      emailUser: mapUser['emailUser']??"",
      proveedorUser: mapUser['prooveedorUser']??""
    );
  }
  

}