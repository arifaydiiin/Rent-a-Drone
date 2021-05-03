import 'dart:io';
import 'package:drone_sale/servisler/firebaseservis.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Ustkisim extends StatefulWidget {
  Ustkisim({
    Key key,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  _UstkisimState createState() => _UstkisimState();
}

class _UstkisimState extends State<Ustkisim> {
  File _profilresmi;

  var picker = ImagePicker();

  _gopicture(ImageSource gelenveri) async {
    var pickedFile = await picker.getImage(source: gelenveri);
    setState(() {
      if (pickedFile != null) {
        _profilresmi = File(pickedFile.path);

        Navigator.of(context).pop();
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var kullanici = Provider.of<FirebaseServis>(context);
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height * 34 / 100,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(offset: Offset(0.0, 2.12), color: Colors.lightBlue),
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
            color: Color(0xFF0C5283),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: widget.width * 25 / 100, top: 40),
              child: SizedBox(
                height: widget.height * 2 / 100,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: widget.width * 4 / 100, top: widget.height * 1 / 100),
              child: Text(
                "Profilim".toUpperCase(),
                style: TextStyle(fontSize: 24),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: widget.width * 12 / 100,
                        top: widget.height * 6 / 100),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Profil fotoğrafı seçiniz"),
                                content: Container(
                                  width: 150,
                                  height: 100,
                                  child: ListView.builder(
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            GestureDetector(
                                                onTap: () async {
                                                  await _gopicture(
                                                      ImageSource.gallery);
                                                  var url = await kullanici
                                                      .uploadfile(
                                                          kullanici.user.userID,
                                                          "profilfotosu",
                                                          _profilresmi);

                                                  await kullanici
                                                      .profilfotokaydet(url);
                                                },
                                                child: Text(
                                                  "Galeriden seç",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )),
                                            SizedBox(height: 20),
                                            GestureDetector(
                                                onTap: () async {
                                                  await _gopicture(
                                                      ImageSource.camera);
                                                  var url = await kullanici
                                                      .uploadfile(
                                                          kullanici.user.userID,
                                                          "profilfotosu",
                                                          _profilresmi);
                                                  await kullanici
                                                      .profilfotokaydet(url);
                                                },
                                                child: Text("Kameradan Seç",
                                                    style: TextStyle(
                                                        fontSize: 20))),
                                          ],
                                        );
                                      }),
                                ),
                              );
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.black,
                        ),
                        width: 120,
                        height: 180,
                        child: Image.network(
                          kullanici.user.profilfoto,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.width * 11 / 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        kullanici.user.kullaniciadi,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        kullanici.user.email,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        kullanici.user.kullaniciparasi.toString() + "TL",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: widget.height * 15 / 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
