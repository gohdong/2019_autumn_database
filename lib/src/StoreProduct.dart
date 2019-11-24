import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreProduct extends StatelessWidget {
  StoreProduct({this.repeat = 0});

  int repeat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('store').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Cannot Found..");
          }
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.network(snapshot.data.documents[repeat]['img']),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(snapshot.data.documents[repeat]['name']),
                  Text(snapshot.data.documents[repeat]['price']),
                ],
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("상품구성"),
                      Text("유효기간"),
                      if ((0 < repeat && repeat < 4) ||
                          (9 < repeat && repeat < 13))
                        Text("원산지"),
                      Text("상품교환"),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(snapshot.data.documents[repeat]['cons']),
                      Text(snapshot.data.documents[repeat]['term']),
                      if ((0 < repeat && repeat < 4) ||
                          (9 < repeat && repeat < 13))
                        Text(snapshot.data.documents[repeat]['cont']),
                      Text("사용가능 CGV 보기"),
                    ],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(snapshot.data.documents[repeat]['desc']),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
