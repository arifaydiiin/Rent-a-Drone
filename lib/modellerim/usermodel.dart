import 'dart:math';

class Usermodel {
  int kullaniciparasi;
  final String userID;
  String email;
  bool ogretici;
  String profilfoto;
  String kullaniciadi;

  Usermodel({this.userID, this.email, this.ogretici, this.profilfoto});

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "email": email,
      "ogretici": ogretici ?? false,
      "profilfoto": profilfoto ??
          "https://eitrawmaterials.eu/wp-content/uploads/2016/09/empty-avatar.jpg",
      "kullaniciadi": kullaniciadi ?? email.substring(0, email.indexOf("@")) + randomsayi(),
      "kullaniciparasi":kullaniciparasi ?? 0,
    };
  }

  Usermodel.toObj(Map<String, dynamic> obje)
      : userID = obje["userID"],
        email = obje["email"],
        ogretici = obje["ogretici"],
        profilfoto = obje["profilfoto"],
        kullaniciadi = obje["kullaniciadi"],
        kullaniciparasi = obje["kullaniciparasi"];

  @override
  String toString() {
    return "User {userID: $userID email: $email}";
  }
  String randomsayi() {
    int rastgelesayi = Random().nextInt(99999);
    return rastgelesayi.toString();
  }
}
