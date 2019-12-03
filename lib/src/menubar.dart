import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/main.dart';
import 'package:dbapp/src/data/is_login.dart';
import 'package:dbapp/src/event.dart';
import 'package:dbapp/src/home.dart';
import 'package:dbapp/src/login.dart';
import 'package:dbapp/src/my.dart';

import 'package:dbapp/src/data/make_seat.dart' as prefix0;
import 'package:dbapp/src/login.dart';
import 'package:dbapp/src/reservation.dart';
import 'package:dbapp/src/data/make_seat.dart';
import 'package:dbapp/src/test_movie_buy.dart';
import 'package:dbapp/src/success_pay.dart';
import 'package:dbapp/src/wishList.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'data/sign_in.dart';

class MenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Container(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 30,
            ),
            head(context, size),
            Divider(
              indent: 15,
              endIndent: 15,
            ),
            Container(
              height: 27,
              child: Text(
                '영화별 예매',
                textAlign: TextAlign.center,
                textScaleFactor: 1.5,
              ),
            ),
            Divider(
              indent: 15,
              endIndent: 15,
            ),
            gird(context),
            Divider(
              indent: 15,
              endIndent: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Tabs()));
              },
              child: Container(
                child: Text(
                  'Home',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.5,
                ),
              ),
            ),
            Divider(
              indent: 15,
              endIndent: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                signOutGoogle();
                counter.decrement();
              },
              child: Container(
                child: Text(
                  counter.getCounter() == 0 ? '' : 'LogOut',
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget head(context, size) {
    final counter = Provider.of<Counter>(context);
    return Column(
      children: <Widget>[
        Container(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_alert),
            Container(
                child: counter.getCounter() == 0
                    ? Container(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: Icon(Icons.account_circle, size: 70))
                    : Container(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: CircleAvatar(
                            radius: 40.0,
                            backgroundImage: NetworkImage('$imageUrl')))),
            Icon(Icons.settings)
          ],
        ),
        Container(
          padding: EdgeInsets.only(bottom: 30),
          child: counter.getCounter() == 0
              ? OutlineButton.icon(
                  icon: Icon(Icons.power_settings_new),
                  label: Text("login"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Login()));
                  },
                )
              : Column(
                  children: <Widget>[
                    Text(
                      '$name',
                      textScaleFactor: 1.3,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("$email"),
                  ],
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                counter.getCounter() == 0
                    ? null
                    : Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Purchase()));
              },
              child: Column(
                children: <Widget>[
                  Text("위시영화"),
                  Container(
                    child: counter.getCounter() == 0
                        ? Text('-')
                        : likeMovie(context),
                  ), //database 연결
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Text("내가 본 영화"),
                Container(
                  child: counter.getCounter() == 0
                      ? Text('-')
                      : viewMovie(context), //database 연결
                )
              ],
            ),
            Column(
              children: <Widget>[
                Text("내가 쓴 댓글"),
                Container(
                  child: counter.getCounter() == 0 ? Text('-') : reviewList(),
                  //database 연결
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget gird(BuildContext context) {
    return Container(
      height: 280,
      child: GridView.count(
        primary: false,
        padding: EdgeInsets.only(top: 10, left: 30, right: 30),
        crossAxisCount: 3,
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Home()));
              },
              child: gridComponent(Icons.home, "홈")),
          InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => My()));
              },
              child: gridComponent(Icons.account_box, 'my')),
          gridComponent(Icons.credit_card, '할인정보'),
          gridComponent(Icons.info, '고객센터'),
          gridComponent(Icons.stars, "특별관"),
          InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Event()));
              },
              child: gridComponent(Icons.event, "이벤트")),
          gridComponent(Icons.collections_bookmark, "매거진"),
          gridComponent(Icons.event_seat, "club서비스"),
          gridComponent(Icons.headset_mic, "고객센터")
        ],
      ),
    );
  }

  Widget gridComponent(IconData icon, String str) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.black12),
        top: BorderSide(width: 1.0, color: Colors.black12),
        left: BorderSide(width: 1.0, color: Colors.black12),
        right: BorderSide(width: 1.0, color: Colors.black12),
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(icon, size: 40), Text(str)],
      ),
    );
  }

  Widget likeMovie(context) {
    final counter = Provider.of<Counter>(context);
    if (counter.getCounter() == 0) {
      return Text(
        '0',
        textScaleFactor: 1.5,
      );
    }
    return StreamBuilder(
        stream:
            Firestore.instance.collection('member').document(email).snapshots(),
        builder: (context, snapshot) {
          List<dynamic> ad = snapshot.data['like_movie'];
          if (!snapshot.hasData) return const Text('Loading…');
          return Container(
            child: _likeMovie(context, ad),
          );
        });
  }

  Widget _likeMovie(BuildContext context, List<dynamic> ad) {
    return Container(
      child: Text(
        ad.length.toString(),
        textScaleFactor: 1.5,
      ),
    );
  }

  Widget viewMovie(context) {
    final counter = Provider.of<Counter>(context);
    if (counter.getCounter() == 0) {
      return Text(
        '0',
        textScaleFactor: 1.5,
      );
    }
    return StreamBuilder(
        stream: Firestore.instance
            .collection('payment_movie')
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: (context, snapshot) {
          int ad = snapshot.data.documents.length;
          if (!snapshot.hasData) return const Text('Loading…');
          return Container(
            child: _viewMovie(context, ad),
          );
        });
  }

  Widget _viewMovie(BuildContext context, int ad) {
    return Container(
      child: Text(
        ad.toString(),
        textScaleFactor: 1.5,
      ),
    );
  }

  Widget reviewList() {
    return StreamBuilder(
        stream:
            Firestore.instance.collection('member').document(email).snapshots(),
        builder: (context, snapshot) {
          List<dynamic> ad = snapshot.data['review_movieID'];
          if (!snapshot.hasData) return const Text('Loading…');
          return Container(
            child: _reviewList(context, ad),
          );
        });
  }

  Widget _reviewList(BuildContext context, List<dynamic> document) {
    return Container(
      child: Text(
        document.length.toString(),
        textScaleFactor: 1.5,
      ),
    );
  }
}
