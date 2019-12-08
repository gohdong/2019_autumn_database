import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/src/reservation/reservation.dart';
import 'dart:math';
import 'package:dbapp/main.dart';
import 'package:dbapp/src/data/is_login.dart';
import '../../main.dart';
import 'package:dbapp/src/reservation/test_movie_buy.dart';
import 'package:dbapp/src/home/home.dart';
import '../data/sign_in.dart';

class Success extends StatelessWidget {
  String ok;

//  Success(String getdata) {
//    ok = getdata;
//  }

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


    String a = '$global_time_table_ID';

//    print("document.table : " + document_table['movieID']);
    return Scaffold(
        body: Column(children: <Widget>[
          Container(
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300],
            ),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: ListView(
                padding: EdgeInsets.only(bottom: 70),
                shrinkWrap: true,
                children: <Widget>[
//                  Refresh(),
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
                            "결제가 완료되었습니다",
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
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey[400]),
                          ),
                          color: Colors.grey[200]),
                      child: Text("예매 정보 및 내역은 'My메뉴 - 내가 본 영화' 탭에서 확인하실수 있습니다.")),
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Tabs()));

                            return null;
                          },
                          child: Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "홈으로 돌아가기",
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
        ],crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center

          ,)
    );
  }

}
