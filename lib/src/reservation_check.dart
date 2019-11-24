import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Screen_purchase extends StatelessWidget {

  Screen_purchase({Key key, this.title, this.time, this.select_list, this.count}) : super(key: key);
  final String title;
  final String time;
  final List<String> select_list;
  final int count;
//  final int select_list;

  Firestore firestore = Firestore.instance;
  List<String> list = ['Aa',"Bb"];
  String x = "none11";
  var i;
  var j;
  List<List<String>> mylist = [[],[],[],[],[],[],[],[],[],[]];
  String seat;
  List<String> select = [];

  @override
  Widget build(BuildContext context) {

    for(i=0;i<10;i++){
      for(j=0;j<10;j++){
        if (i == 0) {
          seat = "A" + j.toString();
        } else if (i == 1) {
          seat = "B" + j.toString();
        } else if (i == 2) {
          seat = "C" +j.toString();
        } else if (i == 3) {
          seat = "D" + j.toString();
        } else if (i == 4) {
          seat = "E" + j.toString();
        } else if (i == 5) {
          seat = "F" + j.toString();
        } else if (i == 6) {
          seat = "G" + j.toString();
        } else if (i == 7) {
          seat = "H" + j.toString();
        } else if (i == 8) {
          seat = "I" + j.toString();
        } else if (i == 9) {
          seat = "J" + j.toString();
        } else if (i == 10) {
          seat = "K" + j.toString();
        } else {
          seat = "L" + j.toString();
        }
        mylist[i].add(seat);
      }
    }

    print(mylist[3][4]);

    return Scaffold(
      appBar: AppBar(title: Text("결제")),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('movie')
              .where('name', isEqualTo: "겨울왕국2")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error : ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
//                  itemExtent: 80,
                  children: snapshot.data.documents
                      .map((document) => Start(context, document))
                      .toList(),
                );
            }
          }),
    );
  }


  Widget Start(BuildContext ctx, DocumentSnapshot document) {

    for(i=0;i<10;i++) {
      for (j = 0; j < 10; j++) {
        if (document[mylist[i][j]] == "2") {
          select.add(mylist[i][j]);

        }
      }
    }

//    firestore.collection("movie").document('name').get()
//        .then((DocumentSnapshot ds){
//      x = ds.data["time"];


    return SingleChildScrollView(
      // 없으면, 화면을 벗어났을 때 볼 수 없음 (스크롤 지원)
      child: Center(
        child: Column(
          // 아래
          children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: 400,
                    height : 450,
                    margin : EdgeInsets.all(30),
                    padding: EdgeInsets.all(20),
                    decoration : new BoxDecoration(
                      color : Colors.blue[10],
                      border : Border.all(
                        width : 1,
                        color : Colors.grey[500],
                      ),
                      borderRadius : BorderRadius.all(
                        Radius.circular(10.0),
                      )
                    ),
                    child : Column(
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                            border: Border(
                              bottom : BorderSide(
                                color : Colors.black,
                                width : 1,
                              )
                            )
                          ),
                          width : 350,
                          margin: EdgeInsets.only(top : 0),
                          padding: EdgeInsets.only(bottom : 12),
                          child : Center(
                            child: Text("영화정보", style: TextStyle(
                            ),
                          )
                        )),
                        Row(children: <Widget>[
                          Text(document['name'], style : TextStyle(
                            fontSize: 20,
                          )),
                        ],),
                        Row(
                          children: <Widget>[
                            Text("영화시작 시간 : "),
                            Text(document['name']),
                          ],
                        ),

                        Row(children: <Widget>[
                          Text("좌석 : "),
                          for(i=0;i<select_list.length;i++)
                            if(i < select_list.length-1) Text(select_list[i] + ", ")
                            else Text(select_list[i]),
                        ],),


                      ],
                    )
                  )

                ],
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
          ],
          // mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//
//    firestore.collection("time_table").document("test").get()
//        .then((DocumentSnapshot ds){
//      x = ds.data["time"];
//    });
//    return Scaffold(
//        appBar: AppBar(title: Text("Time_table")),
//        body: Column(
//          children: <Widget>[
//            Text(x),
////              Text(sended.toString()),
//          ],
//        )
//    );
//  }
}