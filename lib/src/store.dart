import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/StoreTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      Container(
        height: MediaQuery.of(context).size.height * 0.05,
        margin: EdgeInsets.all(10),
        decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
        child: new TabBar(
          controller: ctr,
          tabs: [
            new Tab(
              text: '콤보',
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
        height: MediaQuery.of(context).size.height * 0.75,
//      margin: EdgeInsets.all(10),
        child: TabBarView(
          controller: ctr,
          children: <Widget>[
            for (int i = 0; i < 4; i++) makeStoreTab(i),
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
    return Column(
      children: <Widget>[for (int i = 1; i < 4; i++) StoreTab(repeat: i)],
    );
  }
  if (index == 1) {
    return Column(
      children: <Widget>[for (int i = 7; i < 10; i++) StoreTab(repeat: i)],
    );
  }
  if (index == 2) {
    return Column(
      children: <Widget>[for (int i = 10; i < 13; i++) StoreTab(repeat: i)],
    );
  }
  if (index == 3) {
    return Column(
      children: <Widget>[for (int i = 16; i < 19; i++) StoreTab(repeat: i)],
    );
  }
}
