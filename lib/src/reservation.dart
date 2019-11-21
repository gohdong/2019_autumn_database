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



ParentReserve reState = new ParentReserve();

class Reserve extends StatefulWidget {
  @override
  ParentReserve createState() => new ParentReserve();
}

class ParentReserve extends State<Reserve> {
  DocumentSnapshot sub;
  List<String> seatlist = [];
  var i;
  var j;
  int send = 100;

  @override
  Widget build(BuildContext context) {
//    seatlist.clear();
    return Scaffold(
      appBar: AppBar(title: Text("Time_table")),
      backgroundColor: Colors.grey[900],
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('time_table')
              .where('title', isEqualTo: "겨울왕국2")
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
    return Center(
        child: InkWell(
      onTap: () {
        if(document['select_count'] == 0){
          _showDialog();
        }
        else{
          setState(() {
            seatlist;
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Screen_purchase(title : "겨울왕국2", time : "09:20")));
        }

      },
      child: Container(
        margin: const EdgeInsets.only(top: 50, bottom: 30),
        width: 300.0,
        height: 48.0,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          color: Colors.orangeAccent,
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
      onTap: () {
        print("chi");
      },
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
  final Color posi = Colors.white;
  final Color imposi = Colors.grey[450];
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


    if (widget.document[seat] == '0') {
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
    } else if (widget.document[seat] == '1' || widget.document[seat] == '2') {
      // 2면 좌석이 비어있음
      return Center(
          child: InkWell(
        child: Container(
            margin: const EdgeInsets.only(top: 5, left: 1),
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              color: (widget.document[seat] == "1") ? posi : select,
            ),
            child: Center(
              child: Text(seat),
//                  child: Text(reState.seatlist.length.toString()),
            )),
        onTap: () {
          setState(() { // 0:선택불가 // 1:선택가능 2:현재선택된것
            int x;
            Firestore.instance.collection("time_table").document("test").get()
                .then((DocumentSnapshot ds){
              x = ds.data["title"];
            });
            print(x);
            if (widget.document[seat] == '1') {
              // check가 true 면 예약 가능한것 = 아직 선택 안함
              reState.seatlist.add(seat);
            check = false;
              Firestore.instance.collection("time_table").document('test').updateData({seat : "2"});
              Firestore.instance.collection("time_table").document('test').updateData({"select_count" : widget.document['select_count']+1});

            } else {
              reState.seatlist.remove(seat);
              Firestore.instance.collection("time_table").document('test').updateData({seat : "1"});
              Firestore.instance.collection("time_table").document('test').updateData({"select_count" : widget.document['select_count']-1});
              check = true;
            }
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
                color: Colors.amber,
              ),
              child: Center(
                child: Text(seat),
              )),
        ),
      );
    }
  }
}
