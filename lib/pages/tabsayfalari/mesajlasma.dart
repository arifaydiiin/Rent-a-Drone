import 'package:drone_sale/modellerim/mesajlar.dart';
import 'package:drone_sale/modellerim/usermodel.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class Mesajlasma extends StatefulWidget {
  final String suankiuser;
  final Usermodel ilansahibi;
  Mesajlasma({this.suankiuser, this.ilansahibi});

  @override
  _MesajlasmaState createState() => _MesajlasmaState();
}

class _MesajlasmaState extends State<Mesajlasma> {
  TextEditingController _mesajController;
  @override
  Widget build(BuildContext context) {
    _mesajController = TextEditingController();
    var kullanici = Provider.of<FirebaseServis>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ilansahibi.kullaniciadi),
      ),
      body: Center(
        child: Column(children: [
          Expanded(
            child: StreamBuilder<List<Mesaj>>(
              stream: kullanici.getAllMessage(
                  widget.suankiuser, widget.ilansahibi.userID),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      SizedBox(
                        height: height * 2 / 100,
                      ),
                      snapshot.data[index].bendenmi == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Text(
                                      snapshot.data[index].mesaj,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, left: 8),
                                  child: CircleAvatar(
                                    foregroundImage:
                                        NetworkImage(kullanici.user.profilfoto),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: CircleAvatar(
                                    foregroundImage: NetworkImage(
                                        widget.ilansahibi.profilfoto),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(snapshot.data[index].mesaj),
                                  ),
                                ),
                              ],
                            ),
                    ]);
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8, left: 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _mesajController,
                    cursorColor: Colors.blueGrey,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Mesajınızı Yazın",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (_mesajController.text.trim().length > 0) {
                        var x = await kullanici
                            .userbilgilerigetir(widget.suankiuser);
                        Mesaj kaydedilenmesaj = Mesaj(
                          kimden: widget.suankiuser,
                          kime: widget.ilansahibi.userID,
                          bendenmi: true,
                          mesaj: _mesajController.text,
                          karsidakininprofili: widget.ilansahibi.profilfoto,
                          mesajiatankisiprofil: x.profilfoto,
                        );
                        kullanici.saveMessage(kaydedilenmesaj);
                      }
                      _mesajController.clear();
                    },
                    elevation: 0,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.send,
                      size: width * 7 / 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
