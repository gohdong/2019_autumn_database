import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/src/reservation/reservation_check.dart';
import 'dart:math';



class MakeSeat extends StatelessWidget {

  String seat;
  var i;
  var j;
  Firestore firestore = Firestore.instance;
  ///// 여기에 document이름 입력
  var name = "CINEMA2_2";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(title : Text("add")),
        body : Column(
          children: <Widget>[
            Text("추가할 documentID : "+name),
            Center(
                child: InkWell(
                  onTap: () {
//                    Firestore.instance.collection("time_table").
//                          document("new").collection('20191126_CINEMA1_1120').document("seats")
//                             .updateData({
//                            "time" : "3"});
                    for(i=0; i<10; i++){
                      for(j=0; j<10; j++){
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
                          seat = "J" +j.toString();
                        } else if (i == 10) {
                          seat = "K" + j.toString();
                        } else {
                          seat = "L" + j.toString();
                        }

                        if(seat == 'A0' || seat == 'A1'){
                          Firestore.instance.collection("time_table").
                          document(name)
                              .collection('seats').document('1').updateData({
                            seat : <String, dynamic>{
                              'number' : "1",
                              'type' : 'disabled',
                            }}
                            );
                        }else if(i == 1 || i == 0){
                          Firestore.instance.collection("time_table").
                          document(name)
                              .collection('seats').document('1').updateData({
                            seat : <String, dynamic>{
                              'number' : "1",
                              'type' : 'economy',
                            }});
                        }else if(i == 3 || i == 2){
                          Firestore.instance.collection("time_table").
                          document(name)
                              .collection('seats').document('1').updateData({
                            seat : <String, dynamic>{
                              'number' : "1",
                              'type' : 'standard',
                            }});
                        }else{
                          Firestore.instance.collection("time_table").
                          document(name)
                              .collection('seats').document('1').updateData({
                            seat : <String, dynamic>{
                              'number' : "1",
                              'type' : 'prime',
                            }});
                        }


                      }
                    }


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
                        )
                    ),

                    child: Center(
//              child : Text("a"),
//              child : Text("Screen"),
                      child: Text("추가하기!", style: TextStyle(
                        fontSize: 20,
                      ),),
//          child: Text(reState.seatlist.length.toString(), style: TextStyle(
//            fontSize: 20,
//          ),),
                    ),
                  ),
                ))
          ],
        )
    );
  }

}