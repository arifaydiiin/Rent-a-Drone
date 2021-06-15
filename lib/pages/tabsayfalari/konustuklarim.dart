import 'package:drone_sale/modellerim/konusma.dart';
import 'package:drone_sale/pages/tabsayfalari/mesajlasma.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Mesajlaslarim extends StatefulWidget {
  Mesajlaslarim({Key key}) : super(key: key);

  @override
  _MesajlaslarimState createState() => _MesajlaslarimState();
}

class _MesajlaslarimState extends State<Mesajlaslarim> {
  @override
  Widget build(BuildContext context) {
    var kullanici = Provider.of<FirebaseServis>(context);
    kullanici.konusmalarigetir();
    return Scaffold(
      appBar: AppBar(
        title: Text("Mesajlarım"),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {});
          },
          child: FutureBuilder<List<Konusma>>(
              future: kullanici.konusmalarigetir(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (snapshot.hasData) {
                        return GestureDetector(
                          onTap: () async {
                            var x = await kullanici.userbilgilerigetir(
                                snapshot.data[index].alicikisi);
                            Get.to(Mesajlasma(
                              suankiuser: kullanici.user.userID,
                              ilansahibi: x,
                            ));
                          },
                          //kullanıcı.user.userID ==  snapshot.data[index].konusmasahibi ? Circular mesajatanikisi : circular ilansahibi bla bla
                          child: ListTile(
                            leading: CircleAvatar(
                              foregroundImage: NetworkImage(kullanici
                                          .user.userID !=
                                      snapshot.data[index].konusmasahibi
                                  ? snapshot.data[index].karsidakininprofili
                                  : snapshot.data[index].mesajiatankisiprofil),
                            ),
                            title: Text(
                                snapshot.data[index].sonyollananmesaj.length >
                                        35
                                    ? snapshot.data[index].sonyollananmesaj
                                            .substring(0, 35) +
                                        "..."
                                    : snapshot.data[index].sonyollananmesaj),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error));
                      }
                      return null;
                    });
              }),
        ),
      ),
    );
  }
}
