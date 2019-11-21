import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Screen_purchase extends StatelessWidget {

  Screen_purchase({Key key, this.mylist}) : super(key: key);
  final List<String> mylist;
//  Screen_purchase({Key key, this.sended}) : super(key: key);
//  final int sended;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Time_table")),
        body: Column(
          children: <Widget>[
            Text(mylist.length.toString()),
//              Text(sended.toString()),
          ],
        )
    );
  }
}