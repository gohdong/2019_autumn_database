import 'package:date_format/date_format.dart';
import 'package:dbapp/src/data/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/test_movie_buy.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:dbapp/src/my.dart';

//import 'data/sign_in.dart';

class Food_purchase extends StatefulWidget {
  Food_purchase({@required this.select, @required this.money});

//  final String str;
  final Map<String, int> select;
  final Map<String, int> money;

  @override
  _Food_purchaseState createState() => _Food_purchaseState();
}

class _Food_purchaseState extends State<Food_purchase> {
  final db = Firestore.instance;
  int total = 0;
  List<String> list = ['Aa', "Bb"];
  String x = "none11";

  var i;
  var j;

  @override
  Widget build(BuildContext context) {



    var keys = widget.select.keys.toList();
    this.total = 0;
    for (var i = 0; i < keys.length; i++){
      this.total = this.total + widget.money[keys[i]]*widget.select[keys[i]];
    }

    FlutterMoneyFormatter total_won =
    FlutterMoneyFormatter(amount: double.parse((this.total).toString()));


    return Scaffold(
      appBar: AppBar(
          title: Text(
        "결제",
        textAlign: TextAlign.center,
      )),
      bottomNavigationBar: Container(
          alignment: Alignment.center,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(width: 2, color: Colors.grey[300]),
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding : EdgeInsets.only(right : 15),
                color : Colors.white70,
                alignment: Alignment.centerRight,
                height: 40,
                width: MediaQuery.of(context).size.width * 1,
//                color: Colors.white70,
                child: Text(
                  "총 결제금액 : "+
                      total_won.output.withoutFractionDigits.toString()+
                  " 원"
                  , textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 15,
                ),),),
              InkWell(
                onTap: () async {
                  for (var i = 0; i < keys.length; i++){
                    if(widget.select[keys[i]] == 0){
                      widget.select.remove(keys[i]);
                    }
                  }


                  await db.collection('payment_store').add({
                    'memberID': name,
                    'email': email,
                    'total': this.total,
                    'list': widget.select,
                    'payTime': Timestamp.now(),
                  });
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Payment(this.total)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height : 50,
//                  decoration: BoxDecoration(
//                    border: Border.all(width: 1, color: Colors.blue),
//                  ),
                  child:
                  Text(
                  "결제하기",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          )),
      body: Start(context, widget.select),
    );
  }

  Widget Start(BuildContext ctx, Map<String, int> select) {
    int price = 1;
    var keys = select.keys.toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (var i = 0; i < keys.length; i++)
              make_box(keys[i], select[keys[i]]),
          ],
        ),
      ),
    );
  }

  Widget make_box(String name, int count) {
    int sub = count * widget.money[name];

    FlutterMoneyFormatter price =
    FlutterMoneyFormatter(amount: double.parse((sub).toString()));

    if (count != 0) {
      return Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 30),
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey[400]),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 30),
                    alignment: Alignment.centerLeft,
                    height: 50,
                    child: Text(
                      name,
//              textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showDialog_ok(context, name);
//                    setState(() {
//                      widget.select.update(name, (dynamic val) => 0);
//                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 20),
//            width: 30,
//          decoration: BoxDecoration(
//            border: Border.all(width: 2, color: Colors.grey[400]),
//          ),
                      child: Icon(Icons.delete, size: 30)),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
                  ),
                  color: Colors.grey[200]),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, top: 26),
              child: Row(
                children: <Widget>[
                  InkWell(
                      // -
                      onTap: () {
                        setState(() {
                          if(widget.select[name] == 1){
                            _showDialog_ok(context, name);
                          }
                          else{
                            widget.select.update(name, (dynamic val) => val - 1);
                            if(widget.select[name] == 0){
                              widget.select.remove(name);
                            }
                          }
                        });
                      },
                      child: Container(
//                      margin: EdgeInsets.only(left : 20, top : 20),
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: Colors.black),
                          ),
//                  child: Icon(Icons.expand_more),
                          child: Text(
                            "-",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ))),
                  Container(
                      // 카운트
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
//                decoration: BoxDecoration(
//                  border: Border.all(width: 2, color: Colors.grey[300]),
//                ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                  InkWell(
                      // +
                      onTap: () {
                        setState(() {
                          widget.select.update(name, (dynamic val) => val + 1);
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.black),
                        ),
//                  child: Icon(Icons.expand_less),
                        child: Text(
                          "+",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 87),
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
//                decoration: BoxDecoration(
//                  border: Border.all(width: 2, color: Colors.grey[300]),
//                ),
                      child: Text(
                        price.output.withoutFractionDigits.toString() + "원",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                ],
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    } else {
      return Container();
    }
  }


  void _showDialog_ok(BuildContext context, String name) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("확인"),
          content: new Text(name + " 을(를) 삭제하시겠습니까?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("예"),
              onPressed: () async {
                 setState(() {
                  widget.select.update(name, (dynamic val) => 0);
                  print(widget.select);
                    widget.select.remove([name]);
                  print(widget.select);
                });
                 Navigator.of(context).pop();
              },
              textColor: Colors.blue,
            ),
            new FlatButton(
              child: new Text("아니요"),
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
