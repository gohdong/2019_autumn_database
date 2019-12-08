import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/main.dart';
import 'package:dbapp/src/data/is_login.dart';
import 'package:dbapp/src/home/event.dart';
import 'package:dbapp/src/home/home.dart';
import 'package:dbapp/src/data/login.dart';
import 'package:dbapp/src/mypage/my.dart';

import 'package:dbapp/src/data/make_seat.dart' as prefix0;
import 'package:dbapp/src/data/login.dart';
import 'package:dbapp/src/reservation/reservation.dart';
import 'package:dbapp/src/data/make_seat.dart';
import 'package:dbapp/src/reservation/test_movie_buy.dart';
import 'package:dbapp/src/reservation/success_pay.dart';
import 'package:dbapp/src/mypage/myList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../data/sign_in.dart';

class MenuBar extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
            email != null
                ? InkWell(
                    onTap: () {
                      _confirmLogOut(context);
                    },
                    child: Container(
                      child: Text(
                        'LogOut',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget head(context, size) {
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
                child: name == null
                    ? Container(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: Icon(Icons.account_circle, size: 70))
                    : Container(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(imageUrl),
                        ))),
            Icon(Icons.settings)
          ],
        ),
        Container(
          padding: EdgeInsets.only(bottom: 30),
          child: email == null
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
                email == null
                    ? null
                    : Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyList()));
              },
              child: Column(
                children: <Widget>[
                  Text("위시영화"),
                  Container(
                    child: email == null ? Text('-') : likeMovie(context),
                  ), //database 연결
                ],
              ),
            ),
            InkWell(
              onTap: () {
                email == null
                    ? null
                    : Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyList()));
              },
              child: Column(
                children: <Widget>[
                  Text("내가 본 영화"),
                  Container(
                    child: email == null
                        ? Text('-')
                        : viewMovie(context), //database 연결
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Text("내가 쓴 댓글"),
                Container(
                  child: email == null ? Text('-') : reviewList(),
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
                    .push(MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: gridComponent(Icons.event, "이벤트")),
//          InkWell(
//              onTap: () {
//                Navigator.of(context)
//                    .push(MaterialPageRoute(builder: (context) => prefix0.Make_seat()));
//              },
//              child: gridComponent(Icons.event, "추가")),
//

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
    if (email == null) {
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
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
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
    if (email == null) {
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
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          int ad = snapshot.data.documents.length;
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
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Container(
            child: _reviewList(context, snapshot.data['review_movieID']),
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

  void _confirmLogOut(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Alert"),
          content: new Text("Are you sure to add it?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                await _firebaseAuth.signOut();
                email = null;
                name = null;
                imageUrl = null;

                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
              textColor: Colors.blue,
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Colors.red,
            ),
          ],
        );
      },
    );
  }
}
