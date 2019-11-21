import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreTicket extends StatelessWidget {
  StoreTicket({this.repeat = 0});

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
                  child: getTicketImage(),
                  width: 100,
                  height: 100,
                )
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[getTicketName()],
                ),
//              or text
                Row(
                  children: <Widget>[getTicketDescription()],
                ),
//              or text
                Row(
                  children: <Widget>[
//                  Column(children: <Widget>[getTicketPrice2()],),
//              or text
                    Column(
                      children: <Widget>[getTicketPrice1()],
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

  Widget getTicketImage() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store_tic').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Image.network(snapshot.data.documents[repeat]['img']);
//        return new Text(snapshot.data.documents[repeat]['name']);
      },
    );
  }

  Widget getTicketName() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store_tic').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data.documents[repeat]['name']);
      },
    );
  }

  Widget getTicketDescription() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store_tic').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data.documents[repeat]['desc']);
      },
    );
  }

  Widget getTicketPrice1() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store_tic').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data.documents[repeat]['price']);
      },
    );
  }

//  Widget getTicketPrice2() {
//    return new StreamBuilder(
//      stream: Firestore.instance
//          .collection('store_tic')
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
