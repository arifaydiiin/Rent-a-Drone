import 'package:cloud_firestore/cloud_firestore.dart';

class Ilanlar {
  String profilurl;
  final String ilanadi; //x
  final String il; //x
  final String ilce; //x
  final String aciklama; //x
  final String deneyim; //x
  final String fiyat;
  bool boostmu;
  final String profilresmi;
  final String userID;
  final DateTime tarih;
  String kullaniciismi;

  //boostmu ?

  Ilanlar(
      {this.tarih,
      this.userID,
      this.profilresmi,
      this.profilurl,
      this.fiyat,
      this.ilanadi,
      this.il,
      this.ilce,
      this.aciklama,
      this.deneyim,
      this.kullaniciismi,
      this.boostmu});

  Map<String, dynamic> toMap() {
    return {
      "profilresmi": profilresmi ??
          "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
      "userID": userID,
      "profilurl": profilurl,
      "ilanadi": ilanadi,
      "il": il,
      "ilce": ilce,
      "aciklama": aciklama,
      "deneyim": deneyim,
      "fiyat": fiyat,
      "kullaniciismi": kullaniciismi,
      "boostmu": boostmu,
      "tarih": tarih ?? FieldValue.serverTimestamp(),
    };
  }

  Ilanlar.toObj(Map<String, dynamic> obje)
      : profilresmi = obje["profilresmi"],
        userID = obje["userID"],
        profilurl = obje["profilurl"],
        ilanadi = obje["ilanadi"],
        kullaniciismi = obje["kullaniciismi"],
        il = obje["il"],
        ilce = obje["ilce"],
        aciklama = obje["aciklama"],
        deneyim = obje["deneyim"],
        fiyat = obje["fiyat"],
        boostmu = obje["boostmu"],
        tarih = (obje["tarih"] as Timestamp).toDate();
}
