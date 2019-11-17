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
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("패키지"),
                    Text("영화관람권"),
                    Text("콤보"),
                    Text("기프트카드"),
                  ]),
            ),
            Divider(
              color: Colors.black,
            ),
            StoreRow(),
            Divider(
              color: Colors.black,
            ),
            StoreRow(),
            Divider(
              color: Colors.black,
            ),
            StoreRow(),
            Divider(
              color: Colors.black,
            ),
            StoreRow(),
            Divider(
              color: Colors.black,
            ),
          ],
        ));
  }
}

Widget StoreRow() {
  return ListTile(
    title: Column(
      children: <Widget>[
        Row(
          children: <Widget>[Text("패키지")],
        ),
        Column(
          children: <Widget>[
            Container(),
            Row(
              children: <Widget>[Text("패키지 명")],
            ),
            Row(
              children: <Widget>[Text("설명")],
            ),
            Row(
              children: <Widget>[Text("가격")],
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(),
            Row(
              children: <Widget>[Text("패키지 명")],
            ),
            Row(
              children: <Widget>[Text("설명")],
            ),
            Row(
              children: <Widget>[Text("가격")],
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(),
            Row(
              children: <Widget>[Text("패키지 명")],
            ),
            Row(
              children: <Widget>[Text("설명")],
            ),
            Row(
              children: <Widget>[Text("가격")],
            ),
          ],
        ),
      ],
    ),
  );
}
