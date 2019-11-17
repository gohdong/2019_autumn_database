import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Store extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Text("TICKET & POPCORN STORE")],
          ),
          onTap: () {
//            Navigator.of(context)
//                .push(MaterialPageRoute(builder: (context) => null));
          },
        ),
        Divider(
          color: Colors.black,
        ),
        ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("패키지"),
                  Text("영화관람권"),
                  Text("콤보"),
                  Text("기프트카드")
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

//아래 고려해보기
//        return Card(
//    child: InkWell(
//    child: Row(
//      // Row content
//    ),
//    onTap: () => {
//    print("Card tapped.");
//    },
//    ),
//    elevation: 2,
//    );
