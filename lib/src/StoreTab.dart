import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/StoreProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreTab extends StatelessWidget {
  StoreTab({this.repeat = 0});

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
                  child: getProductImage(),
                  width: 100,
                  height: 100,
                )
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[getProductName()],
                ),
//              or text
                Row(
                  children: <Widget>[getProductDescription()],
                ),
//              or text
                Row(
                  children: <Widget>[
//                  Column(children: <Widget>[getProductPrice2()],),
//              or text
                    Column(
                      children: <Widget>[getProductPrice1()],
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
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => StoreProduct(repeat: repeat,)));
      },
    );
  }

  Widget getProductImage() {
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

  Widget getProductName() {
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

  Widget getProductDescription() {
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

  Widget getProductPrice1() {
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

//  Widget getProductPrice2() {
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
