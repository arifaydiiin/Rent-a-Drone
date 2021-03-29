import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_sale/modellerim/ilanlarim.dart';
import 'package:drone_sale/modellerim/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      return _usermodel;
    } catch (e) {
      print("Hata var create: " + e);
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
    } catch (e) {
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

  //Firebase Storage işlemleri

  Future<String> uploadfile(
      String userID, String fileType, File yuklenecekdosya) async {
    var id = _dbservis.collection("ilanlar").doc().id;
    Reference storageReference =
        _storage.ref().child(userID).child("$fileType").child(id).child("$fileType.png");
    UploadTask uploadtask = storageReference.putFile(yuklenecekdosya);
    var url = await uploadtask.then((a) => a.ref.getDownloadURL());
    print("URLLL: " + url.toString());
    return url;
  }
}
