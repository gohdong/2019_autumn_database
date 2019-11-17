import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Store extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
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
      Divider(color: Colors.black),
      ListTile(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            Text("패키지"),
            Text("영화관람권"),
            Text("콤보"),
            Text("기프트카드")
          ])),
      Divider(color: Colors.black),

      ListTile(
          title: Column(children: <Widget>[
        Row(children: <Widget>[Text("고객님께 추천하는 영화볼 때 필수 아이템")]),
        Row(children: <Widget>[
          Column(children: <Widget>[
            Row(children: <Widget>[Text("제품 명")]),
            Row(children: <Widget>[Text("설명")]),
            Row(children: <Widget>[Text("가격")])
          ]),
          Column(children: <Widget>[Container(child: Text("사진"))])
        ])
      ])),

      Divider(color: Colors.black),

      // 베스트 상품, 선물추천, 팝콘, 음료, 스낵      추가하기

      StoreRow(),
      Divider(color: Colors.black),
      StoreRow(),
      Divider(color: Colors.black),
      StoreRow(),
      Divider(color: Colors.black),
      StoreRow(),
      Divider(color: Colors.black),
      Card(child: Center(child: Text("이용안내")))
    ]));
  }
}

Widget StoreRow() {
  return ListTile(
    title: Column(
      children: <Widget>[
        Row(children: <Widget>[Text("카테고리")]),
        for (var i = 0; i < 3; i++)
          Row(children: <Widget>[
            Column(children: <Widget>[Container(child: Text("사진"))]),
            Column(children: <Widget>[
              Row(children: <Widget>[Text("카테고리 명")]),
              Row(children: <Widget>[Text("설명")]),
              Row(children: <Widget>[Text("가격")])
            ])
          ]),
      ],
    ),
  );
}
