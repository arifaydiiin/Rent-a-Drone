import 'dart:io';
import 'dart:convert';
import 'package:drone_sale/modellerim/ilanlarim.dart';
import 'package:drone_sale/modellerim/sehir.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//Smart select silinecek.

class YeniIlan extends StatefulWidget {
  YeniIlan({Key key}) : super(key: key);

  @override
  _YeniIlanState createState() => _YeniIlanState();
}

class _YeniIlanState extends State<YeniIlan> {
  TextEditingController _textilanbaslik;
  TextEditingController _textaciklama;
  TextEditingController _textfiyat;
  var _secilenil;
  var _secilenilce;
  var _dropmenusecilen;
  File _ilanresmi;
  final picker = ImagePicker();
  List _ilveilcelistesi;
  List _illerinlistesi;
  List _ilcelerinlistesi = ["İlçe Seciniz"];

  @override
  void initState() {
    super.initState();
    _textilanbaslik = TextEditingController();
    _textaciklama = TextEditingController();
    _textfiyat = TextEditingController();
  }

  @override
  void dispose() {
    _textilanbaslik.dispose();
    _textaciklama.dispose();
    _textfiyat.dispose();
    super.dispose();
  }

  _gopicture(ImageSource gelenveri) async {
    var pickedFile = await picker.getImage(source: gelenveri);
    setState(() {
      if (pickedFile != null) {
        _ilanresmi = File(pickedFile.path);

        Navigator.of(context).pop();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<List> jsonverilerigetir() async {
    var jsonall = await DefaultAssetBundle.of(context)
        .loadString("lib/jsondosyalarim/ilveilce.json");
    var _gelenliste = json.decode(jsonall);
    _ilveilcelistesi = _gelenliste.map((e) => Iller.fromJson(e)).toList();
    _ilveilcelistesi.map((e) => _illerinlistesi.add(e.ilAdi));
    return _ilveilcelistesi;
  }

  @override
  Widget build(BuildContext context) {
    var kullanici = Provider.of<FirebaseServis>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: FutureBuilder(
        future: jsonverilerigetir(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 120,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text("Kameradan seç"),
                                  onTap: () => _gopicture(ImageSource.camera),
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Galeriden seç"),
                                  onTap: () => _gopicture(ImageSource.gallery),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Container(
                        width: 100,
                        height: 120,
                        child: _ilanresmi == null
                            ? Image.asset("lib/assets/addpicture.png",
                                scale: 0.1, fit: BoxFit.contain)
                            : Image(image: FileImage(_ilanresmi))),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(_secilenil == null
                                      ? 'İl Seçiniz'
                                      : _secilenil),
                                  content: Container(
                                    height: 300.0,
                                    width: 300.0,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          title: Text(
                                              '${snapshot.data[index].ilAdi}'),
                                          onTap: () {
                                            _secilenilce = null;
                                            _ilcelerinlistesi = [];
                                            print(snapshot.data[index].ilAdi);
                                            _secilenil =
                                                snapshot.data[index].ilAdi;
                                            for (int i = 0;
                                                i <
                                                    snapshot.data[index].ilceler
                                                        .length;
                                                i++) {
                                              _ilcelerinlistesi.add(snapshot
                                                  .data[index]
                                                  .ilceler[i]
                                                  .ilceAdi
                                                  .toString());
                                            }

                                            Get.back();
                                            setState(() {});
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Text(
                            _secilenil == null ? 'İl Seçiniz' : _secilenil)),
                    SizedBox(width: 20),
                    _ilcelerinlistesi.length > 1
                        ? ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(_secilenil == null
                                          ? 'İlçe Seçiniz'
                                          : _secilenil),
                                      content: Container(
                                        height: 300.0,
                                        width: 300.0,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _ilcelerinlistesi.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                              title: Text(
                                                  '${_ilcelerinlistesi[index]}'),
                                              onTap: () {
                                                _secilenilce =
                                                    _ilcelerinlistesi[index];
                                                Get.back();
                                                setState(() {});
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Text(_secilenilce == null
                                ? 'İlçe Seçiniz'
                                : _secilenilce))
                        : SizedBox(),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: DropdownButton(
                  hint: Text('Drone Deneyinimizi girin'),
                  value: _dropmenusecilen,
                  onChanged: (value) {
                    setState(() {
                      _dropmenusecilen = value;
                    });
                  },
                  items: <String>[
                    'Drone Deneyinimizi girin',
                    'Tecrübem yok',
                    'Orta Seviye Tecrübe',
                    'İleri Seviye Tecrübe',
                    'Profesyonel'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextField(
                    controller: _textilanbaslik,
                    decoration:
                        InputDecoration(hintText: "İlan başlığı giriniz"),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextField(
                    controller: _textfiyat,
                    decoration: InputDecoration(hintText: "Fiyat Giriniz"),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: _textaciklama,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Açıklama giriniz.",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_dropmenusecilen == "Drone Deneyinimizi girin" ||
                          _secilenil == null ||
                          _secilenilce == null ||
                          _textaciklama.text == "" ||
                          _textfiyat.text == "" ||
                          _textilanbaslik.text == "") {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Drone Up"),
                                content:
                                    Text("Lütfen eksik bilgileri doldurunuz."),
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Drone Up"),
                                content:
                                    Text("İlanınız Başarıyla yayınlanmıştır."),
                              );
                            });
                        var url = await kullanici.uploadfile(
                            kullanici.user.userID, "ilanfotolari", _ilanresmi);
                        Ilanlar yenilanboost = Ilanlar(
                          userID: kullanici.user.userID,
                          profilresmi: kullanici.user.profilfoto,
                          profilurl: _ilanresmi == null
                              ? "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"
                              : url,
                          fiyat: _textfiyat.text,
                          il: _secilenil.toString(),
                          aciklama: _textaciklama.text,
                          deneyim: _dropmenusecilen,
                          ilanadi: _textilanbaslik.text,
                          ilce: _secilenilce.toString(),
                          boostmu: true,
                          kullaniciismi: kullanici.user.kullaniciadi,
                        );
                        kullanici.ilanekle(yenilanboost);
                      }
                      // Ödeme işlemleri sonuc true ise..
                    },
                    child: Text("Boost ile ilan ver"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_dropmenusecilen == "Drone Deneyinimizi girin" ||
                            _secilenil == null ||
                            _secilenilce == null ||
                            _textaciklama.text == "" ||
                            _textfiyat.text == "" ||
                            _textilanbaslik.text == "") {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Drone Up"),
                                  content: Text(
                                      "Lütfen eksik bilgileri doldurunuz."),
                                );
                              });
                        } else {
                          var url = await kullanici.uploadfile(
                              kullanici.user.userID,
                              "ilanfotolari",
                              _ilanresmi);
                          Ilanlar yenilan = Ilanlar(
                            userID: kullanici.user.userID,
                            profilresmi: kullanici.user.profilfoto,
                            profilurl: _ilanresmi == null
                                ? "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"
                                : url,
                            fiyat: _textfiyat.text,
                            il: _secilenil.toString(),
                            aciklama: _textaciklama.text,
                            deneyim: _dropmenusecilen,
                            ilanadi: _textilanbaslik.text,
                            ilce: _secilenilce.toString(),
                            boostmu: false,
                            kullaniciismi: kullanici.user.kullaniciadi,
                          );
                          kullanici.ilanekle(yenilan);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Drone Up"),
                                  content: Text(
                                      "İlanınız Başarıyla yayınlanmıştır."),
                                );
                              });
                        }
                      },
                      child: Text("İlanı ekle")),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
