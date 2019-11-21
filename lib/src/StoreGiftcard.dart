import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreGiftcard extends StatelessWidget {
  StoreGiftcard({this.repeat = 0});

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
                  child: getGiftcardImage(),
                  width: 100,
                  height: 100,
                )
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[getGiftcardName()],
                ),
//              or text
                Row(
                  children: <Widget>[getGiftcardDescription()],
                ),
//              or text
                Row(
                  children: <Widget>[
//                  Column(children: <Widget>[getGiftcardPrice2()],),
//              or text
                    Column(
                      children: <Widget>[getGiftcardPrice1()],
                    ),
//              or text
                  ],
                )
//              or text
              ],
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget getGiftcardImage() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store_gif').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Image.network(snapshot.data.documents[repeat]['img']);
//        return new Text(snapshot.data.documents[repeat]['name']);
      },
    );
  }

  Widget getGiftcardName() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store_gif').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data.documents[repeat]['name']);
      },
    );
  }

  Widget getGiftcardDescription() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store_gif').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data.documents[repeat]['desc']);
      },
    );
  }

  Widget getGiftcardPrice1() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store_gif').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data.documents[repeat]['price']);
      },
    );
  }

//  Widget getGiftcardPrice2() {
//    return new StreamBuilder(
//      stream: Firestore.instance
//          .collection('store_gif')
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
