import 'package:drone_sale/modellerim/ilanlarim.dart';
import 'package:drone_sale/pages/tabsayfalari/yeniilan.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class AnaSayfa extends StatefulWidget {
  AnaSayfa({Key key}) : super(key: key);

  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
 

  @override
  Widget build(BuildContext context) {
    var kullanici = Provider.of<FirebaseServis>(context);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                Get.to(YeniIlan());
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF4CA1AF), Colors.grey[350]]),
          ),
          child: StreamBuilder<List<Ilanlar>>(
              stream: kullanici.ilanlarigetir(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.length < 1) {
                  return Center(
                      child: Text("Herhangi bir ilan bulunmamaktadır."));
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 44,
                                      backgroundImage: NetworkImage(
                                          snapshot.data[index].profilresmi),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  width: 200,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: Image.network(
                                      snapshot.data[index].profilurl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(snapshot.data[index].ilanadi,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic)),
                                    trailing: Text(
                                      "Fiyat: " + snapshot.data[index].fiyat,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }),
        ));
  }
}

//snapshot.data[index].ilanadi
