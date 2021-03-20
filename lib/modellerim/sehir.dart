class Iller {
    Iller({
        this.ilAdi,
        this.plakaKodu,
        this.ilceler,
    });

    String ilAdi;
    String plakaKodu;
    List<Ilceler> ilceler;  

    factory Iller.fromJson(Map<String, dynamic> json) => Iller(
        ilAdi: json["il_adi"],
        plakaKodu: json["plaka_kodu"],
        ilceler: List<Ilceler>.from(json["ilceler"].map((x) => Ilceler.fromJson(x))),       
    );

    Map<String, dynamic> toJson() => {
        "il_adi": ilAdi,
        "plaka_kodu": plakaKodu,
        "ilceler": List<dynamic>.from(ilceler.map((x) => x.toJson())),
    };
}


class Ilceler {
    Ilceler({
        this.ilceAdi,
    });

    String ilceAdi;

    factory Ilceler.fromJson(Map<String, dynamic> json) => Ilceler(
        ilceAdi: json["ilce_adi"],     
    );

    Map<String, dynamic> toJson() => {
        "ilce_adi": ilceAdi,    
    };
}