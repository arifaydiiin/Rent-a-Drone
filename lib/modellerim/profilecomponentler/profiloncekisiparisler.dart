import "package:flutter/material.dart";

class Profiloncekisiparisler extends StatelessWidget {
  const Profiloncekisiparisler({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 25),
            child: Text(
              "Önceki Siparişleriniz",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            height: 130,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    height: 130,
                    width: 90,
                    color: Colors.teal,
                  ),
                );
              },             
            ),
          ),
        ],
      ),
    );
  }
}
