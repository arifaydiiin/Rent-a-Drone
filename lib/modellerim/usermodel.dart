class Usermodel {
  final String userID;
  String email;
  bool ogretici;
  String profilfoto;

  Usermodel({this.userID, this.email, this.ogretici});

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "email": email,
      "ogretici": ogretici ?? false,
    };
  }

  Usermodel.toObj(Map<String, dynamic> obje)
      : userID = obje["userID"],
        email = obje["email"],
        ogretici = obje["ogretici"];

  @override
  String toString() {
    return "User {userID: $userID email: $email}";
  }
}
