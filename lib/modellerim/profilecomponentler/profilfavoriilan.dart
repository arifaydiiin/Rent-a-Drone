import 'package:drone_sale/pages/tabsayfalari/anasayfadetay.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfilFavoriilanlar extends StatelessWidget {
  const ProfilFavoriilanlar({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    var kullanici = Provider.of<FirebaseServis>(context);
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 25),
            child: Text(
              "Favori ilanlarınız",
              style: TextStyle(fontSize: 20),
            ),
          ),
          StreamBuilder(
              stream: kullanici.favorilerigetir(kullanici.user.userID),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.length < 1) {
                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text("Favori İlanınız yok"),
                    ),
                  ]);
                }
                return Container(
                  height: 130,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var veriler = snapshot.data[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(AnaSayfaDetay(
                            boostmu: veriler.boostmu,
                            userID: veriler.userID,
                            fiyat: veriler.fiyat,
                            il: veriler.il,
                            ilce: veriler.ilce,
                            profilurl: veriler.profilurl,
                            profilresmi: veriler.profilresmi,
                            deneyim: veriler.deneyim,
                            aciklama: veriler.aciklama,
                            ilanadi: veriler.ilanadi,
                            tarih: veriler.tarih,
                          ));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            height: 130,
                            width: 90,
                            child: Image.network(
                              snapshot.data[index].profilurl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
