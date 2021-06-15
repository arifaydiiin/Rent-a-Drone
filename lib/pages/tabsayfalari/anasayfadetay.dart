import 'package:drone_sale/modellerim/ilanlarim.dart';
import 'package:drone_sale/pages/tabsayfalari/ilanresmibuyuk.dart';
import 'package:drone_sale/pages/tabsayfalari/mesajlasma.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AnaSayfaDetay extends StatefulWidget {
  final String profilurl;
  final String ilanadi;
  final String il;
  final String ilce;
  final String aciklama;
  final String deneyim;
  final String fiyat;
  final bool boostmu;
  final String profilresmi;
  final String userID;
  final DateTime tarih;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: width,
              height: height,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Center(
                        child: Text(
                          widget.ilanadi,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(Ilanresmibuyuk(url: widget.profilurl));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      width: double.infinity,
                      height: height * 40 / 100,
                      child: Image.network(
                        widget.profilurl,
                        scale: 0.3,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Text(
                      "İlan Bilgileri",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tarih:",
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          t.day.toString() +
                              "/" +
                              t.month.toString() +
                              "/" +
                              t.year.toString(),
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    indent: width * 5 / 100,
                    endIndent: width * 5 / 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 12.0, right: 12, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "İl:",
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          widget.il,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    indent: width * 5 / 100,
                    endIndent: width * 5 / 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 12.0, right: 12, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "İlçe:",
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          widget.ilce,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    indent: width * 5 / 100,
                    endIndent: width * 5 / 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 12.0, right: 12, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Deneyim:",
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          widget.deneyim,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    indent: width * 5 / 100,
                    endIndent: width * 5 / 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 12.0, right: 12, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Fiyat:",
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          widget.fiyat + "₺",
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 3 / 100,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            widget.aciklama,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 2 / 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.favorite),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Favorilere Ekle"),
                          ],
                        ),
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
                              userID: widget.userID);
                          var veri = await kullanici.favorilereekle(ilan);
                          if (veri) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("DroneUP"),
                                    content: Text("Favorilere eklendi"),
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("DroneUP"),
                                    content: Text("Favorilere eklenemedi "),
                                  );
                                });
                          }
                        },
                      ),
                      kullanici.user.userID != widget.userID
                          ? ElevatedButton(
                              onPressed: () async {
                                var x = await kullanici
                                    .userbilgilerigetir(widget.userID);
                                Get.to(Mesajlasma(
                                    suankiuser: kullanici.user.userID,
                                    ilansahibi: x));
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.message),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Mesaj At"),
                                ],
                              ))
                          : SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
