import 'package:drone_sale/modellerim/profilecomponentler/profilUstKisim.dart';
import 'package:drone_sale/modellerim/profilecomponentler/profilfavoriilan.dart';
import 'package:drone_sale/modellerim/profilecomponentler/profilkendiilanlarim.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var kullanici = Provider.of<FirebaseServis>(context);
    print("hi");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Ustkisim(
              width: width,
              height: height,
            ),
            ProfilFavoriilanlar(width: width),
            Divider(
              indent: 10,
              endIndent: 10,
            ),
            Profiloncekisiparisler(width: width),
            SizedBox(
              height: height * 4 / 100,
            ),
            Container(
              width: width * 25 / 100,
              height: height * 5 / 100,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22))),
                  onPressed: () async {
                    await kullanici.signout();
                  },
                  child: Text("Çıkış Yap")),
            ),
          ],
        ),
      ),
      /**/
    );
  }
}
