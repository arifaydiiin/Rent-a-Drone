import 'package:drone_sale/pages/homepage.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import 'package:drone_sale/pages/signpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Yonlendirici extends StatelessWidget {
  const Yonlendirici({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kullanici = Provider.of<FirebaseServis>(context);
    return kullanici.user == null ? SignPage() : HomePage();
  }
}
