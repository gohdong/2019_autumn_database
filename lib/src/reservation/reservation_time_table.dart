import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/reservation/reservation.dart';
import 'package:date_format/date_format.dart';

import '../data/sign_in.dart';
import '../data/login.dart';

Show_time_table_run showState = new Show_time_table_run();

//
class Show_time_table extends StatelessWidget {
  String input_title2; // FROZEN2019
  DocumentSnapshot document_movie2; // movie.document

  Show_time_table(String getID, DocumentSnapshot getDocument) {
    input_title2 = getID;
    document_movie2 = getDocument;
  }

  @override
  Widget build(BuildContext context) {
    return Show_time_table2(input_title2, document_movie2);
  }
}

class Show_time_table2 extends StatefulWidget {
  String input_title; // FROZEN2019
  DocumentSnapshot document_movie; // movie.document

  Show_time_table2(String getID, DocumentSnapshot getDocument) {
    input_title = getID;
    document_movie = getDocument;
  }

  @override
  Show_time_table_run createState() => new Show_time_table_run();
}

class Show_time_table_run extends State<Show_time_table2> {
//  String title2 = widget.title;
  int theater = 0;
  int check = 0;
  int sub_check = 0;
  int number = 0;
  int i;
  Firestore db = Firestore.instance;
  List<String> sublist = <String>[];

  void initState() {
    super.initState();
//    this.sublist.clear();
  }

  @override
  Widget build(BuildContext context) {
    showState.sublist.clear();
    check = 0;
    sub_check = 0;
    this.check = 0;
    showState.check = 0;
    return Scaffold(
        appBar: AppBar(title: Text("시간 선택")),
        body: SingleChildScrollView(
          child: Column(
            // 옆으
            children: <Widget>[
              for (var i = 1; i < 10; i++)
                build_document(context, i.toString()),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ));
  }

  @override
  Widget build_document(BuildContext context, String theater) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('time_table')
            .where('movieID', isEqualTo: widget.input_title)
            .where('theater', isEqualTo: theater)
//              .orderBy('key', )
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error : ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new Wrap(
//                  shrinkWrap: true,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: snapshot.data.documents
                    .map((document) => Add_array(context, document))
                    .toList(),
              );
          }
        });
  }

  @override
  Widget Add_array(BuildContext ctx, DocumentSnapshot document) {
    Color bor = Colors.red;
    String time;
    time = (document['startAt']).toDate().hour.toString() +
        ":" +
        (document['startAt']).toDate().minute.toString();
    this.sub_check++;
    time = formatDate(document['startAt'].toDate(), [HH, ':', nn]);

    if (int.parse(document['theater']) > this.check) {
      // 새로운 관 시작
      this.sub_check = 1;
      this.check = int.parse(document['theater']);
      return Container(
          child: Column(
            // row : 옆으로
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10, right: 20),
                padding: const EdgeInsets.only(top: 5),
                width: 80.0,
                height: 40.0,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_down, size: 40),
                    Text(
                      document['theater'] + "관",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                  ],
//                mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start
                ),
              ),
              InkWell(
                onTap: () {
                  email == null
                      ? _confirmLogOut(context)
                      : Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          sub_Reserve(widget.document_movie, document)));
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 10, left: 20, right: 20),
                  width: 80.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(0),
                      )),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        width: 60,
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 1.0, color: Colors.grey[400]),
                            ),
                            color: Colors.grey[200]),
                      ),
                      Center(
                        child: Text(
                          (100-document['select_count']).toString() + "/100",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ),
//              Text("남은 좌석 : " + (100 - document['select_count']).toString()),
            ],
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
          ));
    } else if (this.sub_check == 2 || this.sub_check == 3) {
      // 3칸 뒤부터
      return Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              email == null
                  ? _confirmLogOut(context)
                  : Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      sub_Reserve(widget.document_movie, document)));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              margin: const EdgeInsets.only(
                  top: 70, bottom: 10, left: 20, right: 20),
              width: 80.0,
              height: 70.0,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  )),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.grey[400]),
                        ),
                        color: Colors.grey[200]),
                  ),
                  Center(
                    child: Text(
                      (100-document['select_count']).toString() + "/100",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
//        Text("남은 좌석 : " + (100 - document['select_count']).toString()),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisAlignment: MainAxisAlignment.spaceAround,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
      );
    } else {
      // 3칸 뒤부터
      return Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              email == null
                  ? _confirmLogOut(context)
                  : Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      sub_Reserve(widget.document_movie, document)));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              margin: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 20, right: 20),
              width: 80.0,
              height: 70.0,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  )),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.grey[400]),
                        ),
                        color: Colors.grey[200]),
                  ),
                  Center(
                    child: Text(
                      (100-document['select_count']).toString() + "/100",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
//        Text("남은 좌석 : " + (100 - document['select_count']).toString()),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      );
    }
  }

  void _confirmLogOut(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          content: new Text("계속 진행하시려면\n로그인이 필요합니다."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("확인"),
              onPressed: () async {
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Login()));
//                int count = 0;
                Navigator.of(context).pop();
              },
              textColor: Colors.blue,
            ),
            new FlatButton(
              child: new Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Colors.red,
            ),
          ],
        );
      },
    );
  }
}