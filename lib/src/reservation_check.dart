import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/src/test_movie_buy.dart';
import 'package:dbapp/src/success_pay.dart';
import 'package:intl/number_symbols.dart';

//class Screen_purchase extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Text("a");
//  }
//
//
//}


class Screen_purchase extends StatelessWidget {
  List<String> select_list;
  DocumentSnapshot document_movie; // movie.docuemnt
  DocumentSnapshot document_table; // time_table.document

  Screen_purchase(List<String> getlist, DocumentSnapshot getmovie,
      DocumentSnapshot gettable) {
    select_list = getlist;
    document_movie = getmovie;
    document_table = gettable;
  }


  final db = Firestore.instance;

//  Firestore firestore = Firestore.instance;
  List<String> list = ['Aa', "Bb"];
  String x = "none11";
  var i;
  var j;
  List<List<String>> mylist = [[], [], [], [], [], [], [], [], [], []];
  String seat;
  List<String> select = [];

//  String title2 = 'JOKER2019';

  @override
  Widget build(BuildContext context) {
    print("-----=-=-=-=-=-=-=-");
    print(document_table['movieID']);
//    global_time_table_ID = document_table.documentID;
//    print(global_time_table_ID);
//    global_select_list = select_list;
//    know = "correct";
    for (i = 0; i < 10; i++) {
      for (j = 0; j < 10; j++) {
        if (i == 0) {
          seat = "A" + j.toString();
        } else if (i == 1) {
          seat = "B" + j.toString();
        } else if (i == 2) {
          seat = "C" + j.toString();
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

    return Scaffold(
      appBar: AppBar(title: Text("Members")),
      body: Start(context),
    );
  }

//
//  @override
//  Widget build(BuildContext context) {
//    for (i = 0; i < 10; i++) {
//      for (j = 0; j < 10; j++) {
//        if (i == 0) {
//          seat = "A" + j.toString();
//        } else if (i == 1) {
//          seat = "B" + j.toString();
//        } else if (i == 2) {
//          seat = "C" + j.toString();
//        } else if (i == 3) {
//          seat = "D" + j.toString();
//        } else if (i == 4) {
//          seat = "E" + j.toString();
//        } else if (i == 5) {
//          seat = "F" + j.toString();
//        } else if (i == 6) {
//          seat = "G" + j.toString();
//        } else if (i == 7) {
//          seat = "H" + j.toString();
//        } else if (i == 8) {
//          seat = "I" + j.toString();
//        } else if (i == 9) {
//          seat = "J" + j.toString();
//        } else if (i == 10) {
//          seat = "K" + j.toString();
//        } else {
//          seat = "L" + j.toString();
//        }
//        mylist[i].add(seat);
//      }
//    }
//
//    return Scaffold(
//      appBar: AppBar(title: Text("Members")),
//      body: StreamBuilder<QuerySnapshot>(
//          stream: Firestore.instance
//              .collection('movie')
//              .where('name', isEqualTo: '조커')
//              .snapshots(),
//          builder:
//              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//            if (snapshot.hasError) return new Text('Error : ${snapshot.error}');
//            switch (snapshot.connectionState) {
//              case ConnectionState.waiting:
//                return new Text('Loading...');
//              default:
//                return new ListView(
//                  itemExtent: 600,
//                  children: snapshot.data.documents
//                      .map((document) => Start(context, document))
//                      .toList(),
//                );
//            }
//          }),
//    );
//  }

  Widget Start(BuildContext ctx) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300],
            ),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: ListView(
                padding: EdgeInsets.only(bottom: 70),
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                          color: Colors.grey[200]),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "결제정보",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      )),
                  Container(
                      padding: EdgeInsets.all(15),
                      height: 370,
                      decoration: BoxDecoration(
                          border: Border(
                            top:
                                BorderSide(width: 1.0, color: Colors.grey[400]),
                          ),
                          color: Colors.grey[200]),
                      child: Column(
                        children: <Widget>[
                          // 아래로
                          Column(
                            children: <Widget>[
                              //
                              Text(
                                document_movie['name'],
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                document_movie['en_name'],
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.start,
                      )),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        color: Colors.red),
                    child: Container(
                        child: InkWell(
                      onTap: () {
//                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Screen_purchase()));
                    Navigator.of(ctx).push( MaterialPageRoute(builder: (context) => Payment(select_list,document_table)));

                        return null;
                      },
                      child: Container(
                          child: Row(
                        children: <Widget>[
                          Text(
                            "결제하기",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      )),
                    )),
                  )
                ]),
          )
        ],
      ),
    );
  }
}
//        Row(
//          children: <Widget>[
//            Container(
//              width: MediaQuery.of(ctx).size.width * 0.8,
//              height: 300,
//              decoration: new BoxDecoration(
//                  color: Colors.blue[10],
//                  border: Border.all(
//                    width: 1,
//                    color: Colors.grey[500],
//                  ),
//                  borderRadius: BorderRadius.only(
//                    bottomLeft: Radius.circular(10.0),
//                    bottomRight: Radius.circular(10.0),
//                  )),
//            ),
//          ],
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        )

//  Widget Start2(BuildContext ctx, DocumentSnapshot document) {
//    if (document.documentID == title) {
//      return Scaffold(
//        body: Center(
//          child: Column(
//            // 아래
//            children: <Widget>[
//              Column(
//                children: <Widget>[
//                  Container(
//                      width: 400,
//                      height: 450,
//                      margin: EdgeInsets.all(30),
//                      padding: EdgeInsets.all(20),
//                      decoration: new BoxDecoration(
//                          color: Colors.blue[10],
//                          border: Border.all(
//                            width: 1,
//                            color: Colors.grey[500],
//                          ),
//                          borderRadius: BorderRadius.all(
//                            Radius.circular(10.0),
//                          )),
//                      child: Column(
//                        children: <Widget>[
//                          Container(
//                              decoration: new BoxDecoration(
//                                  border: Border(
//                                      bottom: BorderSide(
//                                color: Colors.black,
//                                width: 1,
//                              ))),
//                              width: 350,
//                              margin: EdgeInsets.only(top: 0),
//                              padding: EdgeInsets.only(bottom: 12),
//                              child: Center(
//                                  child: Text(
//                                "영화정보",
//                                style: TextStyle(),
//                              ))),
//                          Row(
//                            children: <Widget>[
//                              Text(document['name'],
//                                  style: TextStyle(
//                                    fontSize: 20,
//                                  )),
//                            ],
//                          ),
//                          Row(
//                            children: <Widget>[
//                              Text("영화시작 시간 : "),
//                              Text(document['name']),
//                            ],
//                          ),
//                          Row(
//                            children: <Widget>[
//                              Text("좌석 : "),
//                              for (i = 0; i < select_list.length; i++)
//                                if (i < select_list.length - 1)
//                                  Text(select_list[i] + ", ")
//                                else
//                                  Text(select_list[i]),
//                            ],
//                          ),
//                        ],
//                      )),
//                  InkWell(
//                      onTap: () {
//                        Navigator.of(ctx).push(
//                            MaterialPageRoute(builder: (context) => Payment()));
////                            MaterialPageRoute(builder: (context) => Payment("Simpson", 100, pay ,select_list)));
//                      },
////                    async {
////                      await firestore.collection('payment_movie').add({
////                        'date': select_list[0],
////                        'movie': "겨울왕국2",
////                        'name': "Harry",
////                        'number': 2,
////                        'array_test': <String, dynamic>{
////                          "a": "10",
////                          "b": "20",
////                          "c": select_list[0],
////
////                        },
////                      });
////                    },
////                      async {
////                        await firestore.collection('payment_movie').add({
////                          'date': "19/11/28",
////                          'movie': "겨울왕국2",
////                          'name': "Harry",
////                          'number': 2,
////                          'array_test': <String, dynamic>{
////                            "a": "10",
////                            "b": "20",
////                            "c": select_list[0],
////
////                          },
////                        });
////                      },
////                        for(i=0; i<=select_list.length; i++)
////                          await firestore.collection('payment_movie').add({
////                            'aa' : "qwer",
//////                            'test' : <String, dynamic>{
//////                              i.toString() : select_list[i],
//////                            }
////                          });
//
////                      Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => Payment()));
////                        Firestore.instance.collection("payment_movie").document('1').updateData
//
//                      child: Container(
//                        margin: const EdgeInsets.only(top: 10, bottom: 30),
//                        width: 300.0,
//                        height: 48.0,
//                        decoration: BoxDecoration(
//                            border: Border.all(width: 1, color: Colors.black),
//                            color: Colors.white,
//                            borderRadius: BorderRadius.all(
//                              Radius.circular(10.0),
//                            )),
//                        child: Center(
////              child : Text("a"),
////              child : Text("Screen"),
//                          child: Text(
//                            "결제하기",
//                            style: TextStyle(
//                              fontSize: 20,
//                            ),
//                          ),
////          child: Text(reState.seatlist.length.toString(), style: TextStyle(
////            fontSize: 20,
////          ),),
//                        ),
//                      ))
//                ],
//                mainAxisAlignment: MainAxisAlignment.center,
//                //crossAxisAlignment: CrossAxisAlignment.stretch,
//              ),
//            ],
//            // mainAxisAlignment: MainAxisAlignment.center,
//            //crossAxisAlignment: CrossAxisAlignment.stretch,
//          ),
//        ),
//      );
//    }
//  }

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
//}
