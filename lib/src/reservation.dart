
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/src/reservation_check.dart';
import 'dart:math';
import 'package:date_format/date_format.dart';


String global_time_table_ID = null;
List<String> global_select_list = [];
String know;

ParentReserve reState = new ParentReserve();


class sub_Reserve extends StatefulWidget {

  DocumentSnapshot document_movie; // movie.docuemnt
  DocumentSnapshot document_table; // time_table.document

  sub_Reserve(DocumentSnapshot getmovie, DocumentSnapshot gettable) {
    document_movie = getmovie;
    document_table = gettable;
  }


//  sub_Reserve({Key key, this.title}) : super(key: key);
//  final String title;
//  String title = "CINEMA1_1";
//  String input_ID = "aa";

  @override
  ParentReserve createState() => new ParentReserve();
}

class ParentReserve extends State<sub_Reserve> {
  DocumentSnapshot sub;
  List<String> seatlist = [];

//  final title2 = widget.input_title;
  var i;
  var j;
  int send = 100;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    reState.seatlist.clear();
    global_select_list.clear();
//    print("right?????? : "+widget.title);
    return Scaffold(
      appBar: AppBar(title: Text("좌석 선택")),
      backgroundColor: Colors.grey[900],
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('time_table').document(widget.document_table.documentID)
              .collection('seats')
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
    sub = document;
    print("print(document['title'])");

//    print(document['A0']);
    return SingleChildScrollView(
      // 없으면, 화면을 벗어났을 때 볼 수 없음 (스크롤 지원)
      child: Center(
        child: Column(
          // 아래
          children: <Widget>[
            _Make_Screen(document),
            // ignore: sdk_version_ui_as_code
            for (i = 0; i < 10; i++)
              Row(
                children: <Widget>[
                  for (j = 0; j < 10; j++)
                    Make_seat(i: i, j: j, document: document),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
//            Make_box(),
            _Purchase_button(document),
          ],
          // mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }

  Widget _Make_Screen(document) {
//    seatlist.clear();

    return Center(
        child: InkWell(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: 300.0,
            height: 48.0,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              color: Colors.grey[900],
            ),
            child: Center(
//              child : Text("a"),
              child : Text("Screen", style: TextStyle(
                fontSize: 25,
                color: Colors.white70,
              ),),
//          child: Text(seatlist.length.toString()),
            ),
          ),
        ));
  }

  Widget _Purchase_button(document) {
    final Color zero = Colors.grey[700];
    final Color more = Colors.orangeAccent;

    return Center(
        child: InkWell(
          onTap: () {
            if(reState.seatlist.length == 0){
              _showDialog();
            }
            else{
              reState.seatlist.sort((String l, String r){
                return l.compareTo(r);

              });
              print("wht???");
              String a = document.documentID;
              String b = document['movieID'];
              print(document['key']);
//              String time = formatDate(document['startAt'].toDate(), [mm, ':', dd]);
//              String time2 = formatDate(document['startAt'].toDate(), [HH, ':', nn]);
//              print("formatdata -=-=-=-=-=--=- : " + (document['startAt'].toDate).toString());
//              String time2 = formatDate(document['startAt'].toDate(), [HH, ':', nn]);

              Navigator.of(context).push(MaterialPageRoute(
//              builder: (context) => Screen_purchase(title : "겨울왕국2", time : "09:20", select_list : reState.seatlist, count : reState.seatlist.length)));
//                  builder: (context) => Screen_purchase(
////                      pay : document.documentID,
////                      title : document['movieID'] ,
////                      time : widget.time,
//                      select_list : reState.seatlist,
//                      count : reState.seatlist.length)));
                  builder: (context) => Screen_purchase(
                      reState.seatlist, widget.document_movie, widget.document_table

                  )));
            }

          },
          child: Container(
            margin: const EdgeInsets.only(top: 50, bottom: 30),
            width: 300.0,
            height: 48.0,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                color: reState.seatlist.length == 0 ? zero : more,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                )
            ),

            child: Center(
//              child : Text("a"),
//              child : Text("Screen"),
              child: Text("결제", style: TextStyle(
                fontSize: 20,
              ),),
//          child: Text(reState.seatlist.length.toString(), style: TextStyle(
//            fontSize: 20,
//          ),),
            ),
          ),
        ));
  }

  void _showDialog(){
    showDialog(
        context : context,
        builder : (BuildContext context){
          return AlertDialog(
              title : new Text("Message"),
              content: new Text("선택하신 좌석이 없습니다. 최소한 1개 이상의 좌석을 선택해주세요."),
              actions : <Widget>[
                new FlatButton(
                    child : new Text("닫기"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    })
              ]
          );
        }
    );
  }
}



class Make_box extends StatefulWidget {
  @override
  _Child_Make_box createState() => new _Child_Make_box();
}

class _Child_Make_box extends State<Make_box> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: 300.0,
            height: 48.0,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              color: Colors.white,
            ),
            child: Center(
              child: Text(reState.seatlist.length.toString()),
//              child : Text("a"),
//              child: Text(seatlist.length.toString() + " " + seatlist[0] + " " + seatlist[1] + " " + seatlist[2] + " " + seatlist[3] + " " + seatlist[4]),
            ),
          ),
        ));
  }
}

class Make_seat extends StatefulWidget {
  Make_seat({Key key, this.i, this.j, this.document}) : super(key: key);
  final int i;
  final int j;
  final DocumentSnapshot document;

  @override
  _Child_Make_seat createState() => new _Child_Make_seat();
}

class _Child_Make_seat extends State<Make_seat> {
  String seat = "";
  final Color posi = Colors.grey;
  final Color imposi = Colors.red;
  final Color select = Colors.amber[300];
  bool check = true;
  Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {


    if (widget.i == 0) {
      seat = "A" + widget.j.toString();
    } else if (widget.i == 1) {
      seat = "B" + widget.j.toString();
    } else if (widget.i == 2) {
      seat = "C" + widget.j.toString();
    } else if (widget.i == 3) {
      seat = "D" + widget.j.toString();
    } else if (widget.i == 4) {
      seat = "E" + widget.j.toString();
    } else if (widget.i == 5) {
      seat = "F" + widget.j.toString();
    } else if (widget.i == 6) {
      seat = "G" + widget.j.toString();
    } else if (widget.i == 7) {
      seat = "H" + widget.j.toString();
    } else if (widget.i == 8) {
      seat = "I" + widget.j.toString();
    } else if (widget.i == 9) {
      seat = "J" + widget.j.toString();
    } else if (widget.i == 10) {
      seat = "K" + widget.j.toString();
    } else {
      seat = "L" + widget.j.toString();
    }
//    print("widget.document[seat]");
//    print(widget.document[seat]);

    ////// 필드 생성
//if(seat == 'A0' || seat == 'A1'){
//  Firestore.instance.collection("time_table").
//  document('20191126_CINEMA1_0920')
//      .collection('seats').document('1').updateData({
//    seat : <String, dynamic>{
//      'number' : "1",
//      'type' : 'disabled',
//    }});
//}else if(widget.i == 1 || widget.i == 0){
//  Firestore.instance.collection("time_table").
//  document('20191126_CINEMA1_1120')
//      .collection('seats').document('1').updateData({
//    seat : <String, dynamic>{
//      'number' : "1",
//      'type' : 'economy',
//    }});
//}else if(widget.i == 3 || widget.i == 2){
//  Firestore.instance.collection("time_table").
//  document('20191126_CINEMA1_1120')
//      .collection('seats').document('1').updateData({
//    seat : <String, dynamic>{
//      'number' : "1",
//      'type' : 'standard',
//    }});
//}else{
//  Firestore.instance.collection("time_table").
//  document('20191126_CINEMA1_1120')
//      .collection('seats').document('1').updateData({
//    seat : <String, dynamic>{
//      'number' : "1",
//      'type' : 'prime',
//    }});
//}


    ////////////////





//    print(widget.document[seat]['number']);
    if (widget.document[seat]['number'] == '0') {
      // 1이면 좌석이 차있
      return Center(
        child: InkWell(
          child: Container(
              margin: const EdgeInsets.only(top: 5, left: 1),
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                color: Colors.grey,
              ),
              child: Center(
                child: Text(seat),
              )),
        ),
      );
    } else if (widget.document[seat]['number'] == '1' || widget.document[seat]['number'] == '2') {
      // 2면 좌석이 비어있음
      if(widget.document[seat]['type'] == 'normal' || widget.document[seat]['type'] == 'economy'){
        return Center(
            child: InkWell(
              child: Container(
                  margin: const EdgeInsets.only(top: 5, left: 1),
//                  color: Colors.grey,
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(

                    border: Border.all(width: 1.5, color: Colors.orangeAccent),
//              color: (widget.document[seat] == "1") ? posi : select,
                    color : check ? posi : select,
                  ),
                  child: Center(
                    child: Text(seat),
//                  child: Text(reState.seatlist.length.toString()),
                  )),
              onTap: () {
                setState(() { // 0:선택불가 // 1:선택가능 2:현재선택된것
                  if(check == true){
                    check = !check;
                    global_select_list.add(seat);
//                    print(global_select_list.length.toString());
                    reState.seatlist.add(seat);
//                    print(reState.seatlist.length.toString());
//              Firestore.instance.collection("time_table").document('test').updateData({seat : "0"});

                  }
                  else{
                    check = !check;
                    reState.seatlist.remove(seat);
//                    print(reState.seatlist.length.toString());
                    global_select_list.remove(seat);
//                    print("b" + global_select_list.length.toString());
//                    print("c" + '$global_select_list'.length.toString());

                  }
                });
              },
            ));
      }else if(widget.document[seat]['type'] == 'standard'){
        return Center(
            child: InkWell(
              child: Container(
                  margin: const EdgeInsets.only(top: 5, left: 1),
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.greenAccent),
//              color: (widget.document[seat] == "1") ? posi : select,
                    color : check ? posi : select,
                  ),
                  child: Center(
                    child: Text(seat),
//                  child: Text(reState.seatlist.length.toString()),
                  )),
              onTap: () {
                setState(() { // 0:선택불가 // 1:선택가능 2:현재선택된것
                  if(check == true){
                    check = !check;
                    reState.seatlist.add(seat);
                    print(reState.seatlist.length.toString());
                    global_select_list.add(seat);
//              Firestore.instance.collection("time_table").document('test').updateData({seat : "0"});

                  }
                  else{
                    check = !check;
                    reState.seatlist.remove(seat);
                    print(reState.seatlist.length.toString());
                    global_select_list.remove(seat);

                  }
                });
              },
            ));
      }else if(widget.document[seat]['type'] == 'prime'){
        return Center(
            child: InkWell(
              child: Container(
                  margin: const EdgeInsets.only(top: 5, left: 1),
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.3, color: Colors.pinkAccent),
//              color: (widget.document[seat] == "1") ? posi : select,
                    color : check ? posi : select,
                  ),
                  child: Center(
                    child: Text(seat),
//                  child: Text(reState.seatlist.length.toString()),
                  )),
              onTap: () {
                setState(() { // 0:선택불가 // 1:선택가능 2:현재선택된것
                  if(check == true){
                    check = !check;
                    reState.seatlist.add(seat);
                    print(reState.seatlist.length.toString());
                    global_select_list.add(seat);
//              Firestore.instance.collection("time_table").document('test').updateData({seat : "0"});

                  }
                  else{
                    check = !check;
                    reState.seatlist.remove(seat);
                    print(reState.seatlist.length.toString());
                    global_select_list.remove(seat);

                  }
                });
              },
            ));
      }else if(widget.document[seat]['type'] == 'disabled'){
        return Center(
            child: InkWell(
              child: Container(
                  margin: const EdgeInsets.only(top: 5, left: 1),
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.5, color: Colors.lightBlue),
//              color: (widget.document[seat] == "1") ? posi : select,
                    color : check ? posi : select,
                  ),
                  child: Center(
                    child: Text(seat),
//                  child: Text(reState.seatlist.length.toString()),
                  )),
              onTap: () {
                setState(() { // 0:선택불가 // 1:선택가능 2:현재선택된것
                  if(check == true){
                    check = !check;
                    reState.seatlist.add(seat);
                    print(reState.seatlist.length.toString());
                    global_select_list.add(seat);
//              Firestore.instance.collection("time_table").document('test').updateData({seat : "0"});

                  }
                  else{
                    check = !check;
                    reState.seatlist.remove(seat);
                    print(reState.seatlist.length.toString());
                    global_select_list.remove(seat);

                  }
                });
              },
            ));
      }


      return Center(
          child: InkWell(
            child: Container(
                margin: const EdgeInsets.only(top: 5, left: 1),
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
//              color: (widget.document[seat] == "1") ? posi : select,
                  color : check ? posi : select,
                ),
                child: Center(
                  child: Text(seat),
//                  child: Text(reState.seatlist.length.toString()),
                )),
            onTap: () {
              setState(() { // 0:선택불가 // 1:선택가능 2:현재선택된것
                if(check == true){
                  check = !check;
                  reState.seatlist.add(seat);
                  print(reState.seatlist.length.toString());
                  global_select_list.add(seat);
//              Firestore.instance.collection("time_table").document('test').updateData({seat : "0"});

                }
                else{
                  check = !check;
                  reState.seatlist.remove(seat);
                  print(reState.seatlist.length.toString());
                  global_select_list.remove(seat);

                }
                //            int x;
//            Firestore.instance.collection("time_table").document("test").get()
//                .then((DocumentSnapshot ds){
//              x = ds.data["title"];
//            });
//            print(x);
//            if (widget.document[seat] == '1') {
//              // check가 true 면 예약 가능한것 = 아직 선택 안함
//              reState.seatlist.add(seat);
//            check = false;
//              Firestore.instance.collection("time_table").document('test').updateData({seat : "2"});
//              Firestore.instance.collection("time_table").document('test').updateData({"select_count" : widget.document['select_count']+1});
//
//            } else {
//              reState.seatlist.remove(seat);
//              Firestore.instance.collection("time_table").document('test').updateData({seat : "1"});
//              Firestore.instance.collection("time_table").document('test').updateData({"select_count" : widget.document['select_count']-1});
//              check = true;
//            }
              });
            },
          ));
    } else {
      // 3이면 지금 선택한 좌석
      return Center(
        child: InkWell(
          child: Container(
              margin: const EdgeInsets.only(top: 5, left: 1),
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                color: Colors.blue,
              ),
              child: Center(
                child: Text(seat),
              )),
        ),
      );
    }
  }
}




//import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:async';
//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:dbapp/src/reservation_check.dart';
//import 'dart:math';
//
//
//
//ParentReserve reState = new ParentReserve();
//
//class sub_Reserve extends StatelessWidget{
//  String input_title;
//  String input_time;
//  sub_Reserve(String getID, String getID2) {
//    input_title = getID;
//    input_time = getID2;
//
//  }
//
//  @override
//  Widget build(BuildContext context){
//    return Reserve(title : input_title, time : input_time);
//  }
//}
//
//class Reserve extends StatefulWidget {
//
//  Reserve({Key key, this.title, this.time}) : super(key: key);
//  final String title;
//  final String time;
//
//  @override
//  ParentReserve createState() => new ParentReserve();
//}
//
//class ParentReserve extends State<Reserve> {
//  DocumentSnapshot sub;
//  List<String> seatlist = [];
//
//import 'package:dbapp/src/success_pay.dart';
////  final title2 = widget.input_title;
//  var i;
//  var j;
//  int send = 100;
//  String title;
//
//  @override
//  void initState() {
//    super.initState();
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
////    reState.seatlist.clear();
////
////
//    Firestore.instance.collection("time_table").
//    document("20191126_CINEMA1_0900").
//    collection("seats").document("A0").get().then((DocumentSnapshot ds){
//      this.title = ds.data["type"];
//      print(this.title);
//    });
//
////    Firestore firestore = Firestore.instance;
////    Stream<QuerySnapshot> currentStream;
////    String aa;
////    currentStream = firestore.collection('time_table')
////        .document('20191126_CINEMA1_0900')
////        .collection('seats').document('A0')
////        .snapshots() as Stream<QuerySnapshot>;
//
//
//    return SingleChildScrollView(
//      // 없으면, 화면을 벗어났을 때 볼 수 없음 (스크롤 지원)
//        child: Center(
//            child: Column(
//              // 아래
//                children: <Widget>[
//                  Text("aa"),
//                  Text(currentStream),
////                  Text(this.title)
//                ]
//            )
//        )
//    );
//  }
//
////            Text(document["type"]),
//
//
////    return new StreamBuilder(
////        stream:
//////        Firestore.instance.collection('seats').document('20191126_CINEMA1_0900').collection("seats").snapshots(),
//////        .where("test", isEqualTo: "aa").snapshots(),
////        Firestore.instance.collection('time_table')
////        .where("movieID", isEqualTo: "FROZEN2019")
////        .where("test", isEqualTo: "aa")
////        .snapshots(),
////        builder: (context, snapshot) {
////          if (!snapshot.hasData) {
////            return CircularProgressIndicator();
////          }
////          return ListView(
//////              children: snapshot.data
//////                      .map((document) => Start(context, document))
//////                      .toList()
////            children: snapshot.data.documents.map((document) => Start(context, document)).toList(),
////
////          );
////        });
//
//  Widget Start(BuildContext ctx, DocumentSnapshot document) {
////    sub = document;
////    List<String> a = ["test","test2"];
////    print("print(document['title'])");
////    var a = Firestore.instance.collection("time_table").
////    document("20191126_CINEMA1_0900").
////    collection("seats").getDocuments();
////      "seat" : <List, dynamic>{
////        "test22" : a,
////      }
////    });
//
////    print(document['A0']);
//    return SingleChildScrollView(
//      // 없으면, 화면을 벗어났을 때 볼 수 없음 (스크롤 지원)
//      child: Center(
//        child: Column(
//          // 아래
//          children: <Widget>[
//            Text("aa"),
//
////            Text(document["type"]),
//
//
////            _Make_Screen(document),
////            // ignore: sdk_version_ui_as_code
////            for (i = 0; i < 10; i++)
////              Row(
////                children: <Widget>[
////                  for (j = 0; j < 10; j++)
////                    Make_seat(i: i, j: j, document: document),
////                ],
////                mainAxisAlignment: MainAxisAlignment.center,
////                //crossAxisAlignment: CrossAxisAlignment.stretch,
////              ),
//////            Make_box(),
////            _Purchase_button(document),
//          ],
//          // mainAxisAlignment: MainAxisAlignment.center,
//          //crossAxisAlignment: CrossAxisAlignment.stretch,
//        ),
//      ),
//    );
//  }
//
//  Widget _Make_Screen(document) {
////    seatlist.clear();
//
//    return Center(
//        child: InkWell(
//      child: Container(
//        margin: const EdgeInsets.only(top: 30, bottom: 30),
//        width: 300.0,
//        height: 48.0,
//        decoration: BoxDecoration(
//          border: Border.all(width: 1, color: Colors.white),
//          color: Colors.grey[900],
//        ),
//        child: Center(
////              child : Text("a"),
//              child : Text("Screen", style: TextStyle(
//                fontSize: 25,
//                color: Colors.white70,
//              ),),
////          child: Text(seatlist.length.toString()),
//        ),
//      ),
//    ));
//  }
//
//  Widget _Purchase_button(document) {
//    final Color zero = Colors.grey[700];
//    final Color more = Colors.orangeAccent;
//
//    return Center(
//        child: InkWell(
//      onTap: () {
//        if(reState.seatlist.length == 0){
//          _showDialog();
//        }
//        else{
//          reState.seatlist.sort((String l, String r){
//            return l.compareTo(r);
//
//          });
//
//          Navigator.of(context).push(MaterialPageRoute(
////              builder: (context) => Screen_purchase(title : "겨울왕국2", time : "09:20", select_list : reState.seatlist, count : reState.seatlist.length)));
//               builder: (context) => Screen_purchase(title : "겨울왕국2", time : "09:10", select_list : reState.seatlist, count : reState.seatlist.length)));
//
//      }
//
//      },
//      child: Container(
//        margin: const EdgeInsets.only(top: 50, bottom: 30),
//        width: 300.0,
//        height: 48.0,
//        decoration: BoxDecoration(
//          border: Border.all(width: 1, color: Colors.black),
//          color: reState.seatlist.length == 0 ? zero : more,
//          borderRadius: BorderRadius.all(
//            Radius.circular(10.0),
//          )
//        ),
//
//        child: Center(
////              child : Text("a"),
////              child : Text("Screen"),
//          child: Text("결제", style: TextStyle(
//            fontSize: 20,
//          ),),
////          child: Text(reState.seatlist.length.toString(), style: TextStyle(
////            fontSize: 20,
////          ),),
//        ),
//      ),
//    ));
//  }
//
//  void _showDialog(){
//    showDialog(
//        context : context,
//        builder : (BuildContext context){
//          return AlertDialog(
//            title : new Text("Message"),
//            content: new Text("선택하신 좌석이 없습니다. 최소한 1개 이상의 좌석을 선택해주세요."),
//            actions : <Widget>[
//              new FlatButton(
//                child : new Text("닫기"),
//                  onPressed: (){
//                  Navigator.of(context).pop();
//                  })
//            ]
//          );
//        }
//    );
//  }
//}
//
//
//
//class Make_box extends StatefulWidget {
//  @override
//  _Child_Make_box createState() => new _Child_Make_box();
//}
//
//class _Child_Make_box extends State<Make_box> {
//  @override
//  Widget build(BuildContext context) {
//    return Center(
//        child: InkWell(
//      child: Container(
//        margin: const EdgeInsets.only(top: 30, bottom: 30),
//        width: 300.0,
//        height: 48.0,
//        decoration: BoxDecoration(
//          border: Border.all(width: 1, color: Colors.black),
//          color: Colors.white,
//        ),
//        child: Center(
//          child: Text(reState.seatlist.length.toString()),
////              child : Text("a"),
////              child: Text(seatlist.length.toString() + " " + seatlist[0] + " " + seatlist[1] + " " + seatlist[2] + " " + seatlist[3] + " " + seatlist[4]),
//        ),
//      ),
//    ));
//  }
//}
//
//class Make_seat extends StatefulWidget {
//  Make_seat({Key key, this.i, this.j, this.document}) : super(key: key);
//  final int i;
//  final int j;
//  final DocumentSnapshot document;
//
//  @override
//  _Child_Make_seat createState() => new _Child_Make_seat();
//}
//
//class _Child_Make_seat extends State<Make_seat> {
//  String seat = "";
//  final Color posi = Colors.white;
//  final Color imposi = Colors.grey[450];
//  final Color select = Colors.amber[300];
//  bool check = true;
//  Firestore firestore = Firestore.instance;
//
//  @override
//  Widget build(BuildContext context) {
//
//
//    if (widget.i == 0) {
//      seat = "A" + widget.j.toString();
//    } else if (widget.i == 1) {
//      seat = "B" + widget.j.toString();
//    } else if (widget.i == 2) {
//      seat = "C" + widget.j.toString();
//    } else if (widget.i == 3) {
//      seat = "D" + widget.j.toString();
//    } else if (widget.i == 4) {
//      seat = "E" + widget.j.toString();
//    } else if (widget.i == 5) {
//      seat = "F" + widget.j.toString();
//    } else if (widget.i == 6) {
//      seat = "G" + widget.j.toString();
//    } else if (widget.i == 7) {
//      seat = "H" + widget.j.toString();
//    } else if (widget.i == 8) {
//      seat = "I" + widget.j.toString();
//    } else if (widget.i == 9) {
//      seat = "J" + widget.j.toString();
//    } else if (widget.i == 10) {
//      seat = "K" + widget.j.toString();
//    } else {
//      seat = "L" + widget.j.toString();
//    }
////    print("widget.document[seat]");
////    print(widget.document[seat]);
////    Firestore.instance.collection("time_table").document('eqedzkEpodA34FFn0Cjm').updateData({seat : "1"});
//
//    if (widget.document[seat] == '0') {
//      // 1이면 좌석이 차있
//      return Center(
//        child: InkWell(
//          child: Container(
//              margin: const EdgeInsets.only(top: 5, left: 1),
//              width: 30.0,
//              height: 30.0,
//              decoration: BoxDecoration(
//                border: Border.all(width: 1, color: Colors.black),
//                color: Colors.grey,
//              ),
//              child: Center(
//                child: Text(seat),
//              )),
//        ),
//      );
//    } else if (widget.document[seat] == '1' || widget.document[seat] == '2') {
//      // 2면 좌석이 비어있음
//      return Center(
//          child: InkWell(
//        child: Container(
//            margin: const EdgeInsets.only(top: 5, left: 1),
//            width: 30.0,
//            height: 30.0,
//            decoration: BoxDecoration(
//              border: Border.all(width: 1, color: Colors.black),
////              color: (widget.document[seat] == "1") ? posi : select,
//                color : check ? posi : select,
//            ),
//            child: Center(
//              child: Text(seat),
////                  child: Text(reState.seatlist.length.toString()),
//            )),
//        onTap: () {
//          setState(() { // 0:선택불가 // 1:선택가능 2:현재선택된것
//            if(check == true){
//              check = !check;
//              reState.seatlist.add(seat);
//              print(reState.seatlist.length.toString());
////              Firestore.instance.collection("time_table").document('test').updateData({seat : "0"});
//
//            }
//            else{
//              check = !check;
//              reState.seatlist.remove(seat);
//              print(reState.seatlist.length.toString());
//
//            }
//              //            int x;
////            Firestore.instance.collection("time_table").document("test").get()
////                .then((DocumentSnapshot ds){
////              x = ds.data["title"];
////            });
////            print(x);
////            if (widget.document[seat] == '1') {
////              // check가 true 면 예약 가능한것 = 아직 선택 안함
////              reState.seatlist.add(seat);
////            check = false;
////              Firestore.instance.collection("time_table").document('test').updateData({seat : "2"});
////              Firestore.instance.collection("time_table").document('test').updateData({"select_count" : widget.document['select_count']+1});
////
////            } else {
////              reState.seatlist.remove(seat);
////              Firestore.instance.collection("time_table").document('test').updateData({seat : "1"});
////              Firestore.instance.collection("time_table").document('test').updateData({"select_count" : widget.document['select_count']-1});
////              check = true;
////            }
//          });
//        },
//      ));
//    } else {
//      // 3이면 지금 선택한 좌석
//      return Center(
//        child: InkWell(
//          child: Container(
//              margin: const EdgeInsets.only(top: 5, left: 1),
//              width: 30.0,
//              height: 30.0,
//              decoration: BoxDecoration(
//                border: Border.all(width: 1, color: Colors.black),
//                color: Colors.blue,
//              ),
//              child: Center(
//                child: Text(seat),
//              )),
//        ),
//      );
//    }
//  }
//}
/////////////////////////////////////
