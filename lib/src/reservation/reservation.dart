import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/reservation/reservation_check.dart';

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
  List<String> seatlist_rank = [];

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
    reState.seatlist_rank.clear();
    global_select_list.clear();
    return Scaffold(
      appBar: AppBar(title: Text("좌석 선택")),
      backgroundColor: Colors.grey[900],
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('time_table')
              .document(widget.document_table.documentID)
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
            _Make_detail(),
            _Purchase_button(document),
          ],
          // mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }

  Widget _Make_detail() {
    return Center(
      child: Container(
        width: 310,
        height: 40,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 0),
              child: Text(
                "장애인석",
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 7.5),
              child: Text(
                "Standard",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 7.5, right: 15),
              child: Text(
                "Economy",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              child: Text(
                "Prime",
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 15,
                ),
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
              child: Text(
                "Screen",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white70,
                ),
              ),
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
            if (reState.seatlist.length == 0) {
              _showDialog();
            } else {
              String a = document.documentID;
              String b = document['movieID'];

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Screen_purchase(
                      reState.seatlist,
                      reState.seatlist_rank,
                      widget.document_movie,
                      widget.document_table,
                      reState.seatlist.length * 8000)));
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 30),
            width: 300.0,
            height: 48.0,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.amber[300]),
                color: Colors.grey[800],
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                )),
            child: Center(
//              child : Text("a"),
//              child : Text("Screen"),
              child: Text(
                "선택완료",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
//          child: Text(reState.seatlist.length.toString(), style: TextStyle(
//            fontSize: 20,
//          ),),
            ),
          ),
        ));
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Message"),
              content: new Text("선택하신 좌석이 없습니다. 최소한 1개 이상의 좌석을 선택해주세요."),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("닫기"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
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
  final Color posi = Colors.white70;
  final Color imposi = Colors.grey[500];
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
                color: imposi,
              ),
              child: Center(
                child: Text(seat),
              )),
        ),
      );
    } else if (widget.document[seat]['number'] == '1' ||
        widget.document[seat]['number'] == '2') {
      // 2면 좌석이 비어있음
      if (widget.document[seat]['type'] == 'normal' ||
          widget.document[seat]['type'] == 'economy') {
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
                    color: check ? posi : select,
                  ),
                  child: Center(
                    child: Text(seat),
//                  child: Text(reState.seatlist.length.toString()),
                  )),
              onTap: () {
                setState(() {
                  // 0:선택불가 // 1:선택가능 2:현재선택된것
                  if (check == true) {
                    check = !check;
//                    global_select_list.add(seat);

//                    print(global_select_list.length.toString());
                    reState.seatlist.add(seat);
                    reState.seatlist_rank.add(widget.document[seat]['type']);
//                    print(reState.seatlist.length.toString());
//              Firestore.instance.collection("time_table").document('test').updateData({seat : "0"});

                  } else {
                    check = !check;
                    reState.seatlist.remove(seat);
                    reState.seatlist_rank.remove(widget.document[seat]['type']);
                  }
                });
              },
            ));
      } else if (widget.document[seat]['type'] == 'standard') {
        return Center(
            child: InkWell(
              child: Container(
                  margin: const EdgeInsets.only(top: 5, left: 1),
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.greenAccent),
//              color: (widget.document[seat] == "1") ? posi : select,
                    color: check ? posi : select,
                  ),
                  child: Center(
                    child: Text(seat),
                  )),
              onTap: () {
                setState(() {
                  // 0:선택불가 // 1:선택가능 2:현재선택된것
                  if (check == true) {
                    check = !check;
                    reState.seatlist.add(seat);
                    reState.seatlist_rank.add(widget.document[seat]['type']);
                  } else {
                    check = !check;
                    reState.seatlist.remove(seat);
                    reState.seatlist_rank.remove(widget.document[seat]['type']);
                  }
                });
              },
            ));
      } else if (widget.document[seat]['type'] == 'prime') {
        return Center(
            child: InkWell(
              child: Container(
                  margin: const EdgeInsets.only(top: 5, left: 1),
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.3, color: Colors.pinkAccent),
//              color: (widget.document[seat] == "1") ? posi : select,
                    color: check ? posi : select,
                  ),
                  child: Center(
                    child: Text(seat),
//                  child: Text(reState.seatlist.length.toString()),
                  )),
              onTap: () {
                setState(() {
                  // 0:선택불가 // 1:선택가능 2:현재선택된것
                  if (check == true) {
                    check = !check;
                    reState.seatlist.add(seat);
                    reState.seatlist_rank.add(widget.document[seat]['type']);
//                    global_select_list.add(seat);
//              Firestore.instance.collection("time_table").document('test').updateData({seat : "0"});

                  } else {
                    check = !check;
                    reState.seatlist.remove(seat);
                    reState.seatlist_rank.remove(widget.document[seat]['type']);
//                    global_select_list.remove(seat);

                  }
                });
              },
            ));
      } else if (widget.document[seat]['type'] == 'disabled') {
        return Center(
            child: InkWell(
              child: Container(
                  margin: const EdgeInsets.only(top: 5, left: 1),
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.5, color: Colors.lightBlue),
//              color: (widget.document[seat] == "1") ? posi : select,
                    color: check ? posi : select,
                  ),
                  child: Center(
                    child: Text(seat),
//                  child: Text(reState.seatlist.length.toString()),
                  )),
              onTap: () {
                setState(() {
                  // 0:선택불가 // 1:선택가능 2:현재선택된것
                  if (check == true) {
                    check = !check;
                    reState.seatlist.add(seat);
                    reState.seatlist_rank.add(widget.document[seat]['type']);
//                    global_select_list.add(seat);
//              Firestore.instance.collection("time_table").document('test').updateData({seat : "0"});

                  } else {
                    check = !check;
                    reState.seatlist.remove(seat);
                    reState.seatlist_rank.remove(widget.document[seat]['type']);
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
                  color: check ? posi : select,
                ),
                child: Center(
                  child: Text(seat),
//                  child: Text(reState.seatlist.length.toString()),
                )),
            onTap: () {
              setState(() {
                // 0:선택불가 // 1:선택가능 2:현재선택된것
                if (check == true) {
                  check = !check;
                  reState.seatlist.add(seat);
                  reState.seatlist_rank.add(widget.document[seat]['type']);
                } else {
                  check = !check;
                  reState.seatlist.remove(seat);
                  reState.seatlist_rank.remove(widget.document[seat]['type']);
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