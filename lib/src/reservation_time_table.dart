import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/src/reservation.dart';


Show_time_table_run showState = new Show_time_table_run();
//
class Show_time_table extends StatelessWidget{

    String input_title;
  Show_time_table(String getID) {
    input_title = getID;
  }

  @override
  Widget build(BuildContext context){
    return Show_time_table2(title : input_title);
  }
}


class Show_time_table2 extends StatefulWidget {

  Show_time_table2({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Show_time_table_run createState() => new Show_time_table_run();
}


class Show_time_table_run extends State<Show_time_table2> {

//  String title2 = widget.title;
  int theater = 0;
  int check = 0;
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
    this.check = 0;
    showState.check = 0;
    print(showState.sublist.length.toString());
    return Scaffold(
        appBar: AppBar(title: Text("시간 선택")),
        body: Column( // 옆으
          children: <Widget>[
            build_document(context),
          ],
        ),
    );
  }

  @override
  Widget build_document(BuildContext context) {
    return
      StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('time_table')
              .where('title', isEqualTo: widget.title).orderBy('theater').orderBy(
              "time")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error : ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new Wrap(
//                  shrinkWrap: true,
                  children: snapshot.data.documents
                      .map((document) => Add_array(context, document))
                      .toList(),
                );
            }
          });
  }

  @override
  Widget Add_array(BuildContext ctx, DocumentSnapshot document) {
    print("진입");
    if(int.parse(document['theater']) > this.check){
      this.check = int.parse(document['theater']);
      return Column( // row : 옆으로
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20, left : 20, right : 20),
            padding: const EdgeInsets.only(top : 5),
            width: 80.0,
            height: 40.0,
            child: Text(document['theater'] + "관", textAlign: TextAlign.center ,style : TextStyle(
              fontSize: 15,

            ),),
          ),

          InkWell(
          onTap: () {

              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>sub_Reserve(document['title'], document['time'])));

          },

          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left : 20, right : 20),
            width: 80.0,
            height: 40.0,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              )
            ),

            child: Center(
                child: Text(document['time'], style: TextStyle(
                  fontSize: 17,
                ),),
              ),
            ),
            ),
          Text("남은 좌석 : " + (100-document['select_count']).toString()),
          ],);
    }
    else {
      return Column(children: <Widget>[
        InkWell(
          onTap: () {
            print("aadsafsdfasdfadfafdsfadsf");
            print(document['title']);
            print(document['time']);
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>sub_Reserve(document['title'], document['time'])));

//            Navigator.of(context).push(MaterialPageRoute(
//
//                builder: (context) => Reserve(title : document['title'], time : document['time'])));
          },

          child: Container(
            margin: const EdgeInsets.only(top: 70, bottom:10, left : 20, right : 20),
            width: 80.0,
            height: 40.0,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                )
            ),

            child: Center(
              child: Text(document['time'], style: TextStyle(
                fontSize: 17,
              ),),
            ),
          ),
        ),
        Text("남은 좌석 : " + (100-document['select_count']).toString()),

    ],);
    }

  }


  @override
  Widget make_table(BuildContext context, int i){
    print("comcom");
    print(this.sublist.length.toString());
    if(i % 2 == 1){ // 홀수
      if(this.number < int.parse(showState.sublist[i])){
          this.number = this.number+1;
          return Text(showState.sublist[i] + "관");
      }
    }
    else{ // 짝
      return Text(showState.sublist[i]);
    }
  }
}
