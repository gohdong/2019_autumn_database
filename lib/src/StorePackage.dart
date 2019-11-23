import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StorePackage extends StatelessWidget {
  StorePackage({this.repeat = 0});

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
                  child: getPackageImage(),
                  width: 100,
                  height: 100,
                )
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[getPackageName()],
                ),
//              or text
                Row(
                  children: <Widget>[getPackageDescription()],
                ),
//              or text
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[getPackagePrice2()],
                    ),
//              or text
                    Column(
                      children: <Widget>[getPackagePrice1()],
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

  Widget getPackageImage() {
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

  Widget getPackageName() {
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

  Widget getPackageDescription() {
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

  Widget getPackagePrice1() {
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

  Widget getPackagePrice2() {
    return new StreamBuilder(
      stream: Firestore.instance.collection('store').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data.documents[repeat]['price2']);
      },
    );
  }
}
