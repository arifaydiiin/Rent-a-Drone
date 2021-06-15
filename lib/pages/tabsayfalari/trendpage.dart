import 'package:drone_sale/modellerim/ilanlarim.dart';
import 'package:drone_sale/pages/tabsayfalari/anasayfadetay.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class Trend extends StatefulWidget {
  Trend({Key key}) : super(key: key);

  @override
  _TrendState createState() => _TrendState();
}

class _TrendState extends State<Trend> {
  @override
  Widget build(BuildContext context) {
    var kullanici = Provider.of<FirebaseServis>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Trendler"),
      ),
      body: StreamBuilder<List<Ilanlar>>(
          stream: kullanici.ilanlarigetirtrend(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data.length < 1) {
              return Center(child: Text("Herhangi bir ilan bulunmamaktadır."));
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var veriler = snapshot.data[index];
                  return Container(
                    height: 75,
                    child: ListTile(
                      onTap: () {
                        Get.to(AnaSayfaDetay(
                          aciklama: veriler.aciklama,
                          deneyim: veriler.deneyim,
                          boostmu: veriler.boostmu,
                          fiyat: veriler.fiyat,
                          il: veriler.il,
                          ilanadi: veriler.ilanadi,
                          ilce: veriler.ilce,
                          profilresmi: veriler.profilresmi,
                          profilurl: veriler.profilurl,
                          tarih: veriler.tarih,
                          userID: veriler.userID,
                        ));
                      },
                      leading: Container(
                        width: 70,
                        height: 70,
                        child: Image.network(
                          veriler.profilurl,
                          fit: BoxFit.fill,
                        ),
                      ),
                      title: Text(veriler.aciklama.length > 25
                          ? veriler.aciklama.substring(0, 25) + "..."
                          : veriler.aciklama),
                      subtitle: Text(veriler.il + ", " + veriler.ilce),
                      trailing: Text(veriler.fiyat + "tl"),
                    ),
                  );
                });
          }),
    );
  }
}
