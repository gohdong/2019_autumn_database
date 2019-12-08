import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/reservation/reservation.dart';
import 'package:dbapp/main.dart';
import '../../main.dart';

class Success extends StatelessWidget {
  String ok;



  String seat;
  var i;
  var j;
  Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(children: <Widget>[
          Container(
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300],
            ),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: ListView(
                padding: EdgeInsets.only(bottom: 70),
                shrinkWrap: true,
                children: <Widget>[
//                  Refresh(),
                  Container(
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                          color: Colors.grey[200]),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "결제가 완료되었습니다",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      )),
                  Container(
                      padding: EdgeInsets.all(15),
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey[400]),
                          ),
                          color: Colors.grey[200]),
                      child: Text("예매 정보 및 내역은 'My메뉴 - 내가 본 영화' 탭에서 확인하실수 있습니다.")),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        color: Colors.red),
                    child: Container(
                        child: InkWell(
                          onTap: () {
//                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Screen_purchase()));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Tabs()));

                            return null;
                          },
                          child: Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "홈으로 돌아가기",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              )),
                        )),
                  )
                ]),
          )
        ],crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center

          ,)
    );
  }

}
