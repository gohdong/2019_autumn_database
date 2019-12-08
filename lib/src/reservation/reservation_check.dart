import 'package:date_format/date_format.dart';
import 'package:dbapp/src/data/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/reservation/test_movie_buy.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:dbapp/src/mypage/my.dart';

import '../data/sign_in.dart';

class Screen_purchase extends StatefulWidget {
  List<String> select_list;
  List<String> select_list_rank;
  DocumentSnapshot document_movie; // movie.docuemnt
  DocumentSnapshot document_table; //
  int money; // time_table.document

  Screen_purchase(List<String> getlist, List<String> getlist_2,
      DocumentSnapshot getmovie, DocumentSnapshot gettable, int getmoney) {
    select_list = getlist;
    select_list_rank = getlist_2;
    document_movie = getmovie;
    document_table = gettable;
    money = getmoney;
  }

  @override
  _Screen_purchaseState createState() => _Screen_purchaseState();
}

class _Screen_purchaseState extends State<Screen_purchase> {
  final db = Firestore.instance;

  int remain;
  int price;
  int mileage;

  List<String> list = ['Aa', "Bb"];

  String x = "none11";

  var i;

  var j;

  List<List<String>> mylist = [[], [], [], [], [], [], [], [], [], []];

  String seat;

  List<String> select = [];

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
      body: Start(context, widget.select_list, widget.select_list_rank),
    );
  }

  Widget Start(BuildContext ctx, List<String> se_li, List<String> se_li_ra) {
    List<String> test = se_li;
    List<String> test2 = se_li_ra;
    FlutterMoneyFormatter fmf =
    FlutterMoneyFormatter(amount: double.parse((widget.money).toString()));

    String time = formatDate((widget.document_table['startAt']).toDate(),
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
////    print(formatDate(todayDate, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]));

    List<String> sub = [];
    for (var i = 0; i < widget.select_list.length; i++) {
      sub.add(widget.select_list[i]);
    }

    List<String> sub2 = [];
    for (var i = 0; i < widget.select_list.length; i++) {
      sub2.add(widget.select_list_rank[i]);
    }

    List<String> sort_array = [];
    for (var i = 0; i < widget.select_list.length; i++) {
      sort_array.add(widget.select_list[i]);
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
                          widget.document_movie['img'],
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
                                        widget.document_movie['name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        widget.document_movie['en_name'],
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 17),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.alarm,
                                            ),
                                            Text(
                                              "  " + time,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.group),
                                            Text("  "+
                                                widget.select_list.length
                                                    .toString() +
                                                "명",
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.edit_location),
                                            Text(
                                              "  본점 " +
                                                  widget.document_table[
                                                  'theater'] +
                                                  "관",
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        )),
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
          Container(
            margin: EdgeInsets.only(top: 18, bottom: 10),
            width: MediaQuery.of(context).size.width * 0.9, // 제품사진
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
              ),
            ),
          ),
          //Load_user_data(ctx),
//          Container(child: Text(this.document_member['email']),),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.grey[300]),
            ),
            child: SingleChildScrollView(child: Column(
              children: <Widget>[
                Text("취소/환불 규정을 확인해주세요.", style: TextStyle(fontSize : 15, fontWeight: FontWeight.bold),),
                Text("1. 예매취소", style: TextStyle(fontWeight: FontWeight.bold),),
                Text("  • 부분취소는 불가능합니다."),
                Text("  • 현장 취소를 하는 경우, 상영시간 이전까지만 가능하며 영화 상영 시작 시간 이후 취소나 환불은 되지 않습니다.."),
                Text("  • 예매 취소는 '메뉴바 - My - 내가 본 영화' 탭에서 해당 영화를 선택 후 예매 취소 할수있습니다."),
                Text(""),
                Text("2. 환불규정", style: TextStyle(fontWeight: FontWeight.bold),),
                Text("   신용카드", style: TextStyle(fontWeight: FontWeight.bold),),
                Text("   • 결제 후 3일 이내 취소 시 승인 취소되며, 3일 이후 매입 취소시 영업일 기준 3~5일 소요됩니다."),
                Text("   체크카드", style: TextStyle(fontWeight: FontWeight.bold),),
                Text("   • 결제 후 3일 이내 취소 시 당일 카드사에서 환불처리되며, 3일 이후 매입 취소 시 카드사에 따라 3~10일 소요됩니다."),
                Text(""),
                Text("3.  미성년자 권리보호 안내", style: TextStyle(fontWeight: FontWeight.bold),),
                Text("   • 미성년자인 고객께서 계약을 체결하시는 경우 법정대리인이 그 계약에 동의하지 아니하면 미성년자 본인 또는 법정대리인이 그 계약을 취소할 수 있습니다."),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            ),
          ),

          Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    child: InkWell(
                      onTap: () async {

                        await db.collection('payment_movie').add({
                          'memberID': name,
                          'email': email,
                          'movieID': widget.document_movie.documentID,
                          'time_tableID': widget.document_table.documentID,
                          'seats': sort_array,
                          'payTime': Timestamp.now(),
                          'mileage': this.remain,
                          'used': false
                        });
                        // 선택한 좌석 firebase 변경
                        for (var i = 0; i < sub.length; i++) {
                          Firestore.instance
                              .collection("time_table")
                              .document(widget.document_table.documentID)
                              .collection('seats')
                              .document('1')
                              .updateData({
                            sub[i]: <String, dynamic>{
                              'number': "0",
                              'type': sub2[i],
                            }
                          });
                        };

                        Firestore.instance
                            .collection("time_table")
                            .document(widget.document_table.documentID)
                            .updateData({
                          'select_count':
                          widget.document_table['select_count'] + sub.length
                        });
                        Navigator.of(ctx).push(MaterialPageRoute(
                            builder: (context) => Payment(widget.money)));

//                    Navigator.of(ctx).push( MaterialPageRoute(builder: (context) => Payment(select_list,document_table, price)));
                      },
                      child: Container(
                        width: MediaQuery.of(ctx).size.width * 1,
                        child: Text(
                          "결제하기",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
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

  @override
  Widget Load_user_data(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('member')
            .where("email", isEqualTo: "kuran0415@gmail.com")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error : ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new Wrap(
//                  itemExtent: 80,
                children: snapshot.data.documents
                    .map((document) => Make_mileage_box(context, document))
                    .toList(),
              );
          }
        });
  }

  @override
  Widget Make_mileage_box(BuildContext context, DocumentSnapshot document) {
    return Container(
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "마일리지",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),

            //Text("총액 : " + (widget.money - document['Mileage']).toString()),
            Expanded(
              child: InkWell(
                  onTap: () {
                    setState(() {
                      if (document['mileage'] == 0) {
                        // 마일리가 0
                        showDialog2("마일리지 잔액이 없습니다");
                      } else {
                        if ((widget.money - document['mileage']) < 0) {
                          // 결제금액보다 마일리지가 많음
                          widget.money = widget.money - document['mileage'];
                          this.remain = document['mileage'] - widget.money;
                          showDialog2("마일리지가 사용되었습니다");
                        } else {
                          // 결제금액이 마일리지보다 많음

                          widget.money = 0;
                          showDialog2("마일리지가 사용되었습니다");
                        }
                      }
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      width: 200,
                      height: 40,
//              decoration: BoxDecoration(
////                shape: BoxShape.circle,
//                border: Border.all(width: 2, color: Colors.black),
//              ),
//                  child: Icon(Icons.expand_more),
                      child: Text(
                        document['mileage'].toString() + " 포인트",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ))),
            )
          ],
        ));
  }

  void showDialog2(str) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Message"),
              content: new Text(
                str,
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("닫기"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }


}