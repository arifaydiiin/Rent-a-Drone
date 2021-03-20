class Ilanlar {
  String profilurl;
  final String ilanadi; //x
  final String il; //x
  final String ilce; //x
  final String aciklama; //x
  final String deneyim; //x
  final String fiyat;

  Ilanlar({this.fiyat,
      this.ilanadi, this.il, this.ilce, this.aciklama, this.deneyim});

  Map<String, dynamic> toMap() {
    return {
      "ilanadi": ilanadi,
      "il": il,
      "ilce": ilce,
      "aciklama": aciklama,
      "deneyim": deneyim,
      "fiyat": fiyat,
    };
  }

  Ilanlar.toObj(Map<String, dynamic> obje)
      : ilanadi = obje["ilanadi"],
        il = obje["il"],
        ilce = obje["ilce"],
        aciklama = obje["aciklama"],
        deneyim = obje["deneyim"],
        fiyat = obje["fiyat"];
}
