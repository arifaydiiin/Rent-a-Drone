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
        body: StreamBuilder<List<Ilanlar>>(
            stream: kullanici.ilanlarigetir(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.green, Colors.orange]),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 27,
                                    child: Image.network(
                                      kullanici.user.profilfoto,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 200,
                                height: 300,
                                child: Image.network(
                                  snapshot.data[index].profilurl,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              ListTile(
                                leading: Text("Fotoğraf"),
                                title: Text(snapshot.data[index].ilanadi,
                                    style: TextStyle(fontSize: 16)),
                                trailing: Text(
                                  "Fiyat: " + snapshot.data[index].fiyat,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }));
  }
}

//snapshot.data[index].ilanadi
