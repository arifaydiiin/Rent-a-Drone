class Konusma {
  String alicikisi;
  String konusmasahibi;
  String sonyollananmesaj;
  String karsidakininprofili;
  String mesajiatankisiprofil;

  Konusma(
      {this.alicikisi,
      this.konusmasahibi,
      this.sonyollananmesaj,
      this.karsidakininprofili,
      this.mesajiatankisiprofil});

  Map<String, dynamic> toMap() {
    return {
      "alicikisi": alicikisi,
      "konusmasahibi": konusmasahibi,
      "sonyollananmesaj": sonyollananmesaj,
      "karsidakininprofili": karsidakininprofili,
      "mesajiatankisiprofil": mesajiatankisiprofil,
    };
  }

  Konusma.toObj(Map<String, dynamic> obje)
      : alicikisi = obje["alicikisi"],
        konusmasahibi = obje["konusmasahibi"],
        karsidakininprofili = obje["karsidakininprofili"],
        mesajiatankisiprofil = obje["mesajiatankisiprofil"],
        sonyollananmesaj = obje["sonyollananmesaj"];
}
