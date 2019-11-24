import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreCombo extends StatelessWidget {
  StoreCombo({this.repeat = 0});

  int repeat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: getComboImage(),
                  width: 100,
                  height: 100,
                )
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[getComboName()],
                ),
//              or text
                Row(
                  children: <Widget>[getComboDescription()],
                ),
//              or text
                Row(
                  children: <Widget>[
//                  Column(children: <Widget>[getComboPrice2()],),
//              or text
                    Column(
                      children: <Widget>[getComboPrice1()],
                    ),
//              or text
                  ],
                )
//              or text
              ],
            ),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget getComboImage() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Image.network(snapshot.data.documents[repeat]['img']);
//        return new Text(snapshot.data.documents[repeat]['name']);
      },
    );
  }

  Widget getComboName() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data.documents[repeat]['name']);
      },
    );
  }

  Widget getComboDescription() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data.documents[repeat]['desc']);
      },
    );
  }

  Widget getComboPrice1() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data.documents[repeat]['price']);
      },
    );
  }

//  Widget getComboPrice2() {
//    return new StreamBuilder(
//      stream: Firestore.instance
//          .collection('store')
//          .snapshots(),
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) {
//          return new Text("Cannot Found..");
//        }
//        return new Text(snapshot.data.documents[repeat]['price2']);
//      },
//    );
//  }
}
