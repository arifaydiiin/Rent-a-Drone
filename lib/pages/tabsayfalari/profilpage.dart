import 'package:drone_sale/servisler/firebaseservis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profil extends StatefulWidget {
  Profil({Key key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    var kullanici = Provider.of<FirebaseServis>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                          "https://miro.medium.com/max/550/1*vYUBqmI6Q8rR_vO4BgUXOQ.jpeg",
                          scale: 0.6),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Arkadaşlarım"),
                        Text("105"),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Engelleyenler"),
                        Text("0"),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Post Sayım"),
                        Text("17"),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.teal,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  children: [],
                ),
              ),
              Container(
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 8,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await kullanici.signout();
                  },
                  child: Text("Çıkış Yap")),
              Text("Arif2"),
            ],
          ),
        ),
      ),
    );
  }
}
