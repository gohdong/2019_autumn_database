import 'package:date_format/date_format.dart';
import 'package:dbapp/src/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/test_movie_buy.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:dbapp/src/my.dart';

import 'data/sign_in.dart';

class Screen_purchase extends StatelessWidget {
  List<String> select_list;
  List<String> select_list_rank;
  DocumentSnapshot document_movie; // movie.docuemnt
  DocumentSnapshot document_table; // time_table.document

  Screen_purchase(List<String> getlist, List<String> getlist_2,
      DocumentSnapshot getmovie, DocumentSnapshot gettable) {
    select_list = getlist;
    select_list_rank = getlist_2;
    document_movie = getmovie;
    document_table = gettable;
  }

//  final DocumentSnapshot document;
  final db = Firestore.instance;

//  Firestore firestore = Firestore.instance;
  List<String> list = ['Aa', "Bb"];
  String x = "none11";
  var i;
  var j;
  List<List<String>> mylist = [[], [], [], [], [], [], [], [], [], []];
  String seat;
  List<String> select = [];

//  String title2 = 'JOKER2019';

  @override
  Widget build(BuildContext context) {
//    global_time_table_ID = document_table.documentID;
//    print(global_time_table_ID);
//    global_select_list = select_list;
//    know = "correct";
    for (i = 0; i < 10; i++) {
      for (j = 0; j < 10; j++) {
        if (i == 0) {
          seat = "A" + j.toString();
        } else if (i == 1) {
          seat = "B" + j.toString();
        } else if (i == 2) {
          seat = "C" + j.toString();
        } else if (i == 3) {
          seat = "D" + j.toString();
        } else if (i == 4) {
          seat = "E" + j.toString();
        } else if (i == 5) {
          seat = "F" + j.toString();
        } else if (i == 6) {
          seat = "G" + j.toString();
        } else if (i == 7) {
          seat = "H" + j.toString();
        } else if (i == 8) {
          seat = "I" + j.toString();
        } else if (i == 9) {
          seat = "J" + j.toString();
        } else if (i == 10) {
          seat = "K" + j.toString();
        } else {
          seat = "L" + j.toString();
        }
        mylist[i].add(seat);
      }
    }

    return Scaffold(
      body: Start(context, select_list, select_list_rank),
    );
  }

  Widget Start(BuildContext ctx, List<String> se_li, List<String> se_li_ra) {
    List<String> test = se_li;
    List<String> test2 = se_li_ra;
    int price = select_list.length * 100;
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: double.parse((select_list.length * 8000).toString()));
//    print(fmf);

//    print("여기가ㅏ각 ");
//    final timeStamp = document_table['startAt'].millisecondsSinceEpoch;
//    print("timeStamp:$timeStamp");
//    String time2 = formatDate(timeStamp, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);

//    print(time2);
//
//    Timestamp a = document_table['startAt'];
//    String formatted = formatTime(document_table['startAt'].toData().subtract(Duration(hours: 2)).millisecondsSinceEpoch);
//    print(a.seconds);
//    print(a);
//
//    print((document_table['startAt']));
//    print("adfdkjfkd");
//    print(formatted);
    String time = formatDate((document_table['startAt']).toDate(),
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
////    print(formatDate(todayDate, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]));

    List<String> sub = [];
    for (var i = 0; i < select_list.length; i++) {
      sub.add(select_list[i]);
    }

    List<String> sub2 = [];
    for (var i = 0; i < select_list.length; i++) {
      sub2.add(select_list_rank[i]);
    }

    List<String> sort_array = [];
    for (var i = 0; i < select_list.length; i++) {
      sort_array.add(select_list[i]);
    }

    sort_array.sort((String l, String r) {
      return l.compareTo(r);
    });

    Color bor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "결제",
        textAlign: TextAlign.center,
      )),
      body: Column(
        children: <Widget>[
          Container(
            child: // 전체
                Column(
              children: <Widget>[
                Container(
                  child: // 포스터 + 정보
                      Row(
                    children: <Widget>[
                      Container(
                        child: // 포스터
                            Image.network(
                          document_movie['img'],
                          fit: BoxFit.cover,
//                      height: MediaQuery.of(ctx).size.height * 0.2,
//                      width: MediaQuery.of(ctx).size.height * 0.2,
                        ),
                        width: MediaQuery.of(ctx).size.width * 0.35,
                        height: MediaQuery.of(ctx).size.height * 0.3,
                        margin: EdgeInsets.only(left: 15),
//                        height: 300,
//                        decoration: BoxDecoration(
//                          border: Border.all(width: 2, color: Colors.red),
//                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(ctx).size.width * 0.53,
                                height: MediaQuery.of(ctx).size.height * 0.25,
//                           decoration: BoxDecoration(
//                             border: Border.all(width: 2, color: bor),
//                           ),
                                margin: EdgeInsets.only(left: 15),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        document_movie['name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        document_movie['en_name'],
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 17),
                                      child: Text(
                                        time,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        select_list.length.toString() + "명",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "본점 " + document_table['theater'] + "관",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                )),
                            Container(
                              width: MediaQuery.of(ctx).size.width * 0.53,
//                         height: MediaQuery.of(ctx).size.height * 0.25,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 2, color: bor),
//                         ),
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                fmf.output.withoutFractionDigits + " 원",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
//                  decoration: BoxDecoration(
//                    border: Border.all(width: 2, color: bor),
//                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(top: 40),
          ),
          Expanded(
//            width: MediaQuery.of(ctx).size.width * 1,
//            height: MediaQuery.of(ctx).size.height * 0.5,
//            decoration: BoxDecoration(
//              border: Border.all(width: 2, color: bor),
//            ),
              child: Row(
            children: <Widget>[
              Container(
                child: InkWell(
                  onTap: () async {
                    print("sdffsfdsds : "+'$name');
                    print('$name' == null);
                    await db.collection('payment_movie').add({
                            'memberID': '$name',
                            'email': '$email',
                            'movieID': document_movie.documentID,
                            'time_tableID': document_table.documentID,
                            'seats': sort_array,
                            'payTime': Timestamp.now(),
                          });
                    // 선택한 좌석 firebase 변경
                    for (var i = 0; i < sub.length; i++) {
                      Firestore.instance
                          .collection("time_table")
                          .document(document_table.documentID)
                          .collection('seats')
                          .document('1')
                          .updateData({
                        sub[i]: <String, dynamic>{
                          'number': "0",
                          'type': sub2[i],
                        }
                      });
                    }
                    Firestore.instance
                        .collection("time_table")
                        .document(document_table.documentID)
                        .updateData({
                      'select_count':
                          document_table['select_count'] + sub.length
                    });
                    Navigator.of(ctx).push(MaterialPageRoute(
                        builder: (context) => Payment(price)));

//                    Navigator.of(ctx).push( MaterialPageRoute(builder: (context) => Payment(select_list,document_table, price)));
                    },
                  child: Text(
                    "결제하기",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                color: Colors.red,
                width: MediaQuery.of(ctx).size.width * 1,
                height: 60,
                alignment: Alignment(0, 0),
                //              height: MediaQuery.of(ctx).size.height * 0.3,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
          ))
        ],
      ),
    );
  }

  Widget make_title(str) {
    return Text(
      str,
      style: TextStyle(
        fontSize: 25,
        color: Colors.black,
      ),
    );
  }

  Widget make_detail(str) {
    return Text(
      str,
      style: TextStyle(
        fontSize: 17,
        color: Colors.grey,
      ),
    );
  }
}

//>>>>>>>>>>>>> save
//Container(
//height: 500,
//decoration: BoxDecoration(
//borderRadius: BorderRadius.circular(20),
//color: Colors.grey[300],
//),
//margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
//child: ListView(
//padding: EdgeInsets.only(bottom: 70),
//shrinkWrap: true,
//children: <Widget>[
////                  Refresh(),
//Container(
//height: 60,
//decoration: BoxDecoration(
//borderRadius: BorderRadius.only(
//topRight: Radius.circular(10.0),
//topLeft: Radius.circular(10.0),
//),
//color: Colors.grey[200]),
//child: Row(
//children: <Widget>[
//Text(
//"결제정보",
//textAlign: TextAlign.center,
//style: TextStyle(
//fontSize: 25,
//color: Colors.black,
//),
//),
//],
//mainAxisAlignment: MainAxisAlignment.center,
//)),
//Container(
//padding: EdgeInsets.all(15),
//height: 370,
//decoration: BoxDecoration(
//border: Border(
//top:
//BorderSide(width: 1.0, color: Colors.grey[400]),
//),
//color: Colors.grey[200]),
//child: Column(
//children: <Widget>[
//// 아래로
//Column(
//children: <Widget>[
//make_title("영화제목"),
//make_detail(document_movie['name']),
//make_detail("("+document_movie['en_name']+")"),
//make_title("예약정보"),
//make_detail("상영날짜"),
//make_detail("상영날짜"),
//
//],
//crossAxisAlignment: CrossAxisAlignment.start,
//)
//],
//crossAxisAlignment: CrossAxisAlignment.start,
////                      mainAxisAlignment: MainAxisAlignment.start,
//)),
//Container(
//height: 70,
//decoration: BoxDecoration(
//borderRadius: BorderRadius.only(
//bottomRight: Radius.circular(10.0),
//bottomLeft: Radius.circular(10.0),
//),
//color: Colors.red),
//child: Container(
//child: InkWell(
//onTap: ()  async {
//await db.collection('payment_movie').add({
//'memberID': '홍길동',
//'movieID': document_movie.documentID,
//'time_tableID': document_table.documentID,
//'seats': sort_array,
//'payTime' : Timestamp.now(),
//});
//// 선택한 좌석 firebase 변경
//for(var i=0; i<sub.length; i++){
//Firestore.instance.collection("time_table").
//document(document_table.documentID)
//    .collection('seats').document('1').updateData({
//sub[i] : <String, dynamic>{
//'number' : "0",
//'type' : sub2[i],
//}});
//}
//
//
//
//
//
////                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Screen_purchase()));
//Navigator.of(ctx).push( MaterialPageRoute(builder: (context) => Payment(select_list,document_table)));
//
//return null;
//},
//child: Container(
//child: Row(
//children: <Widget>[
//Text(
//"결제하기",
//textAlign: TextAlign.center,
//style: TextStyle(
//fontSize: 25,
//color: Colors.white,
//),
//),
//],
//mainAxisAlignment: MainAxisAlignment.center,
//)),
//)),
//)
//]),
//)
