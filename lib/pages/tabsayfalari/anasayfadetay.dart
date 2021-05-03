import 'package:drone_sale/modellerim/ilanlarim.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class AnaSayfaDetay extends StatefulWidget {
  String profilurl;
  String ilanadi;
  String il;
  String ilce;
  String aciklama;
  String deneyim;
  String fiyat;
  bool boostmu;
  String profilresmi;
  String userID;
  DateTime tarih;
  AnaSayfaDetay(
      {this.userID,
      this.profilurl,
      this.profilresmi,
      this.ilce,
      this.il,
      this.fiyat,
      this.deneyim,
      this.aciklama,
      this.ilanadi,
      this.tarih,
      this.boostmu,
      Key key})
      : super(key: key);

  @override
  _AnaSayfaDetayState createState() => _AnaSayfaDetayState();
}

class _AnaSayfaDetayState extends State<AnaSayfaDetay> {
  @override
  Widget build(BuildContext context) {
    var kullanici = Provider.of<FirebaseServis>(context);
    var t = widget.tarih;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: width,
            height: height,
            child: Column(
              children: [
                SizedBox(
                  height: height * 10 / 100,
                ),
                Container(
                  width: width * 45 / 100,
                  height: height * 45 / 100,
                  child: Image.network(
                    widget.profilurl,
                    scale: 0.3,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    "Tarih: " +
                        t.day.toString() +
                        "/" +
                        t.month.toString() +
                        "/" +
                        t.year.toString(),
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(
                        "İl:" + widget.il,
                        style: TextStyle(fontSize: 22),
                      ),
                      Text(
                        " İlçe: " + widget.ilce,
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(
                        "Deneyim:" + widget.deneyim,
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        height: height * 3 / 100,
                      ),
                      Text(
                        widget.aciklama,
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Fiyat:" + widget.fiyat,
                  style: TextStyle(fontSize: 22),
                ),
                ElevatedButton(
                  child: Text("Favorilere Ekle"),
                  onPressed: () async {
                    Ilanlar ilan = Ilanlar(
                      boostmu: widget.boostmu,
                      aciklama: widget.aciklama,                     
                      deneyim: widget.deneyim,
                      fiyat: widget.fiyat,
                      il: widget.il,
                      ilce: widget.ilce,
                      ilanadi: widget.ilanadi,
                      profilresmi: widget.profilresmi,
                      profilurl: widget.profilurl,
                      tarih: widget.tarih,
                      userID: widget.userID
                    );
                    await kullanici.favorilereekle(
                     ilan
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
