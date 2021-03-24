class Usermodel {
  //kullanıcıparasi;
  final String userID;
  String email;
  bool ogretici;
  String profilfoto;

  Usermodel({this.userID, this.email, this.ogretici, this.profilfoto});

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "email": email,
      "ogretici": ogretici ?? false,
      "profilfoto": profilfoto ??
          "https://eitrawmaterials.eu/wp-content/uploads/2016/09/empty-avatar.jpg",
    };
  }

  Usermodel.toObj(Map<String, dynamic> obje)
      : userID = obje["userID"],
        email = obje["email"],
        ogretici = obje["ogretici"],
        profilfoto = obje["profilfoto"];

  @override
  String toString() {
    return "User {userID: $userID email: $email}";
  }
}
