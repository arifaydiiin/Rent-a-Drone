class Ilanlar {
  String profilurl;
  final String ilanadi; //x
  final String il; //x
  final String ilce; //x
  final String aciklama; //x
  final String deneyim; //x
  final String fiyat;
  bool boostmu;
  //boostmu ?

  Ilanlar(
      {this.profilurl,
      this.fiyat,
      this.ilanadi,
      this.il,
      this.ilce,
      this.aciklama,
      this.deneyim,
      this.boostmu});

  Map<String, dynamic> toMap() {
    return {
      "profilurl": profilurl,
      "ilanadi": ilanadi,
      "il": il,
      "ilce": ilce,
      "aciklama": aciklama,
      "deneyim": deneyim,
      "fiyat": fiyat,
      "boostmu": boostmu,
    };
  }

  Ilanlar.toObj(Map<String, dynamic> obje)
      : profilurl = obje["profilurl"],
        ilanadi = obje["ilanadi"],
        il = obje["il"],
        ilce = obje["ilce"],
        aciklama = obje["aciklama"],
        deneyim = obje["deneyim"],
        fiyat = obje["fiyat"],
        boostmu = obje["boostmu"];
}
