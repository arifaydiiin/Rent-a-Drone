import 'package:drone_sale/servisler/firebaseservis.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class SignPage extends StatefulWidget {
  SignPage({Key key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController sifrecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var firebase = Provider.of<FirebaseServis>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xFF45726b),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 200,
                  width: 200,
                  child: Image.asset("lib/assets/people.jpg"),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.lime,
                  ),
                  height: 400,
                  width: 250,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 70,
                        width: 230,
                        child: TextFormField(
                          controller: emailcontroller,
                          decoration: InputDecoration(
                              hintText: "E-mailinizi giriniz",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.greenAccent[400]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(26.0)))),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 70,
                        width: 230,
                        child: TextFormField(
                          controller: sifrecontroller,
                          decoration: InputDecoration(
                              hintText: "??ifrenizi giriniz",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.greenAccent[400]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(26.0)))),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Container(
                        width: 160,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[600],
                            ),
                            onPressed: () async {
                              await firebase.createuserwithemail(
                                  emailcontroller.text, sifrecontroller.text);
                            },
                            child: Text("Kay??t ol ")),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 160,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[600],
                            ),
                            onPressed: () async {
                              await firebase.signinwithemail(
                                  emailcontroller.text, sifrecontroller.text);
                            },
                            child: Text("Giri?? Yap")),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 160,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[600],
                            ),
                            onPressed: () async {
                              await firebase.signwithgoogle();
                            },
                            child: Text("Google ile giri?? Yap")),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
