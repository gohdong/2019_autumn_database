import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/store/store_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class SnackBox extends StatefulWidget {
  @override
  _SnackBoxState createState() => _SnackBoxState();
}

class _SnackBoxState extends State<SnackBox> {
  var test = Map<String, int>();
  var test2 = Map<String, int>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('store').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: (CircularProgressIndicator()),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.documents.length + 2,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Image.network(
                    'http://img.cgv.co.kr/GiftStore/Display/PC/15468087168510.jpg'),
              );
            }
            if (index == 1) {
              return Column(
                children: <Widget>[
                  Divider(
                    endIndent: 10,
                    indent: 10,
                    color: Colors.black54,
                  ),
                  Text(
                    "S N A C K S",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaleFactor: 2,
                  ),
                  Divider(
                    endIndent: 10,
                    indent: 10,
                    color: Colors.black54,
                  ),
                ],
              );
            }
            return makeContents(context, snapshot.data.documents[index - 2]);
          },
        );
      },
    );
  }

  Widget makeContents(BuildContext context, DocumentSnapshot document) {
    int sub = document['price'];
    FlutterMoneyFormatter price =
        FlutterMoneyFormatter(amount: double.parse((sub).toString()));
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                StoreDetail(array: test, money: test2, document: document)));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
          ),
        ),
        width: MediaQuery.of(context).size.width * 1,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 15),
              child: Image.network(document['img'],
                  width: MediaQuery.of(context).size.width * 0.3),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      document['name'],
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      document['desc'],
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      price.output.withoutFractionDigits.toString() + "원",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            )
          ],
        ),
      ),
    );
  }
}
