import 'package:cloud_firestore/cloud_firestore.dart';

class Mesaj {
  final String kimden;
  final String kime;
  final bool bendenmi;
  final String mesaj;
  final DateTime date;
  String karsidakininprofili;
  String mesajiatankisiprofil;

  Mesaj(
      {this.kimden,
      this.kime,
      this.bendenmi,
      this.mesaj,
      this.date,
      this.karsidakininprofili,
      this.mesajiatankisiprofil});

  Map<String, dynamic> toMap() {
    return {
      "kimden": kimden,
      "kime": kime,
      "bendenmi": bendenmi,
      "mesaj": mesaj,
      "date": date ?? FieldValue.serverTimestamp(),
      "karsidakininprofili": karsidakininprofili,
      "mesajiatankisiprofil": mesajiatankisiprofil,
    };
  }

  Mesaj.toObj(Map<String, dynamic> obje)
      : kimden = obje["kimden"],
        kime = obje["kime"],
        bendenmi = obje["bendenmi"],
        mesaj = obje["mesaj"],
        karsidakininprofili = obje["karsidakininprofili"],
        mesajiatankisiprofil = obje["mesajiatankisiprofil"],
        date = (obje["date"] as Timestamp).toDate();

  @override
  String toString() {
    return "Mesaj: $kimden , $kime $bendenmi $mesaj $date";
  }
}
