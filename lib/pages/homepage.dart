import 'package:drone_sale/pages/tabsayfalari/anasayfapage.dart';
import 'package:drone_sale/pages/tabsayfalari/profilpage.dart';
import 'package:drone_sale/pages/tabsayfalari/trendpage.dart';
import 'package:drone_sale/servisler/firebaseservis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

List<Widget> sayfalar = [
  Trend(),
  AnaSayfa(),
  Profil(),
];

List<String> sayfaliste = [
  "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
  "https://emrealtunbilek.com/wp-content/uploads/2016/10/apple-icon-72x72.png",
  "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
];

class _HomePageState extends State<HomePage> {
  int _currentindex = 1;

  @override
  Widget build(BuildContext context) {
    var firebase = Provider.of<FirebaseServis>(context);
    return firebase.user.ogretici == true
        ? Scaffold(
            bottomNavigationBar: BottomNavigationBar(            
              
              onTap: (index) {
                setState(() {
                  _currentindex = index;
                });
              },  
              selectedItemColor: Colors.blue,  
              currentIndex: _currentindex,        
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.polymer_sharp),
                  label: "Trend",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "AnaSayfa",
                ),
                BottomNavigationBarItem(
                  tooltip: "Profil Sayfanız",
                  icon: Icon(Icons.person),
                  label: "Profil",
                ),
              ],
            ),
            body: sayfalar[
                _currentindex] /*SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("User:" + firebase.firebaseuser.uid),
                    Text("User:" + firebase.user.ogretici.toString()),
                    ElevatedButton(
                        onPressed: () async {
                          await firebase.signout();
                        },
                        child: Text("Çıkış Yap")),
                  ],
                ),
              ),
            ),*/
            )
        : Scaffold(
            body: Swiper(
              pagination: SwiperPagination(),
              itemCount: 3,
              itemHeight: 300,
              itemWidth: 300,
              onIndexChanged: (int index) {},
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.black,
                      child: Image.network(sayfaliste[index]),
                    ),
                    index == 2
                        ? ElevatedButton(
                            onPressed: () async {
                              await firebase.updateogretici(firebase.user);
                            },
                            child: Text("Geç"))
                        : SizedBox(),
                  ],
                );
              },
            ),
          );
  }
}

/* 
Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("User:"+c.user),
              ElevatedButton(
                  onPressed: () async {
                    await c.signout();
                  },
                  child: Text("Çıkış Yap")),
            ],
          ),
        ),
      ),
    );
*/
