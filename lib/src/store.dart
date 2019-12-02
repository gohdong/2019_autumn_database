import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/StorePackage.dart';
import 'package:dbapp/src/StoreTab.dart';
import 'package:dbapp/src/store/store_make_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'StoreCombo.dart';
import 'StoreGiftcard.dart';
import 'StoreTicket.dart';

// 리스트뷰

class Store extends StatefulWidget {
  @override
  Store1 createState() => Store1();
}

class Store1 extends State<Store> with SingleTickerProviderStateMixin {
  TabController ctr;

  @override
  void initState() {
    super.initState();
    ctr = new TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
          ListTile(
              title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: StreamBuilder(
                          stream:
                          Firestore.instance.collection('store').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return new Text("Cannot Found..");
                            }
                            return new Image.network(
                                snapshot.data.documents[0]['header']);
                          }),
                    )
                  ]),
              onTap: () {}),
          Divider(color: Colors.black),

//      ListTile(
//          title: Column(children: <Widget>[
//        Row(children: <Widget>[Text("고객님께 추천하는 영화볼 때 필수 아이템")]),
//        Row(children: <Widget>[
//          Column(children: <Widget>[
//            Row(children: <Widget>[Text("제품 명")]),
//            Row(children: <Widget>[Text("설명")]),
//            Row(children: <Widget>[Text("가격")])
//          ]),
//          Column(children: <Widget>[Container(child: Text("사진"))])
//        ])
//      ])),
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.05,
            margin: EdgeInsets.all(10),
            decoration: new BoxDecoration(color: Theme
                .of(context)
                .primaryColor),
            child: new TabBar(
              controller: ctr,
              tabs: [
                new Tab(
                  text: '푸드',
                ),
                new Tab(
                  text: '기프트카드',
                ),
                new Tab(
                  text: '패키지',
                ),
                new Tab(
                  text: '티켓',
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.75,
//      margin: EdgeInsets.all(10),
            child: TabBarView(
              controller: ctr,
              children: <Widget>[
                for(int i = 0; i < 4; i++)
                  makeStoreTab(i),
              ],
            ),
          ),

          // 베스트 상품, 선물추천, 팝콘, 음료, 스낵      추가하기
          Divider(color: Colors.black),

          Divider(color: Colors.black),

          Card(child: Center(child: Text("이용안내")))
        ]));
  }
}

Widget makeStoreTab(int index) {
  if (index == 0) {
    return StoreBottom("food");
  }
  if (index == 1) {
    return StoreBottom("card");
  }
  if (index == 2) {
    return StoreBottom("package");
  }
  if (index == 3) {
    return StoreBottom("ticket");
  }
}
