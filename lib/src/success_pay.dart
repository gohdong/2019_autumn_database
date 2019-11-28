import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/src/reservation.dart';
import 'dart:math';
import 'package:dbapp/main.dart';
import 'package:dbapp/src/data/is_login.dart';
import '../main.dart';
import 'package:dbapp/src/test_movie_buy.dart';
import 'package:dbapp/src/home.dart';
import 'data/sign_in.dart';


class Success extends StatelessWidget {

  String ok;

  Success(String getdata) {
    ok = getdata;
  }


  String seat;
  var i;
  var j;
  Firestore firestore = Firestore.instance;

  ////// 필드 생성


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

  @override
  Widget build(BuildContext context) {
    print(ok);
    print("success 진입@@@@@@");
    print('$global_select_list'.length);
    print(global_select_list.length);
    for(i=0; i<'$global_select_list'.length; i++){
      print('$global_select_list'[i]);
    }
    for(i=0; i<global_select_list.length; i++){
      print(global_select_list[i]);
    }
    print("success 진입@@@@@@");
//    Firestore.instance.collection("time_table").
//    document('20191126_CINEMA1_0920')
//        .collection('seats').document('1').updateData({
//      seat : <String, dynamic>{
//        'number' : "1",
//        'type' : 'disabled',
//      }});


    String a = '$global_time_table_ID';

//    print("document.table : " + document_table['movieID']);
    return Scaffold(
        appBar: AppBar(title: Text('$name')),
        body: Column(
          children: <Widget>[
//            Text(select_list[0]),
//            Text(document_table['movieID']),
            Center(
                child: InkWell(
              onTap: () {
                ////// 필드 생성

                Firestore.instance
                    .collection("time_table")
                    .document('20191126_CINEMA1_0920')
                    .collection('seats')
                    .document('1')
                    .updateData({
                  seat: <String, dynamic>{
                    'number': "1",
                    'type': 'disabled',
                  }
                });
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));

                return null;
              },
              child: Container(
                margin: const EdgeInsets.only(top: 50, bottom: 30),
                width: 300.0,
                height: 48.0,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Center(
//              child : Text("a"),
//              child : Text("Screen"),
                  child: Text(
                    "돌아가기",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
//          child: Text(reState.seatlist.length.toString(), style: TextStyle(
//            fontSize: 20,
//          ),),
                ),
              ),
            ))
          ],
        ));
  }

//  @override
//  Widget Test(string){
//    var a=0;
//    print("ok");
//    this.title = string;
////    print(string);
//      return Row(
//        children: <Widget>[
//          Text(string),
//        ],
//      );
//  }

}
