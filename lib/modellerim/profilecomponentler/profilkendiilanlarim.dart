import 'package:drone_sale/modellerim/ilanlarim.dart';
import 'package:drone_sale/pages/tabsayfalari/anasayfadetay.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Profiloncekisiparisler extends StatelessWidget {
  const Profiloncekisiparisler({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var kullanici = Provider.of<FirebaseServis>(context);
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              "Benim İlanlarım",
              style: TextStyle(fontSize: 20),
            ),
          ),
          StreamBuilder<List<Ilanlar>>(
              stream: kullanici.kendiilanimigetir(),
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
                      child: Text("Şuanda İlanınız yok"),
                    ),
                  ]);
                }
                return Container(
                  height: 130,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
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
                              child: Image.network(veriler.profilurl)),
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
