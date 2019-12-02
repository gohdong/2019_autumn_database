import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/StoreProduct.dart';
import 'package:dbapp/src/store/store_purchase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/src/store/store_make_bottom.dart';

class StoreDetail extends StatefulWidget {
  StoreDetail({@required this.array, @required this.money,  this.document});

//  final String str;
  final Map<String, int> array;
  final Map<String, int> money;
  final DocumentSnapshot document;
  int count = 0;

  @override
  _StoreDetailState createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {


//  void initState() {
//    super.initState();
//
//  }

  @override
  Widget build(BuildContext context) {
//    widget.count = 0;
    var keys;

    int sub = widget.document['price'];
    FlutterMoneyFormatter price =
        FlutterMoneyFormatter(amount: double.parse((sub).toString()));
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "결제",
          textAlign: TextAlign.center,
        )),
        body: Center(
            child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Image.network(widget.document['img'],
                  width: MediaQuery.of(context).size.width * 0.9),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Text(
                          "상품  : " + widget.document['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 25),
                        child: Text(
                          "가격 : " +
                              price.output.withoutFractionDigits.toString() +
                              "원",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  Column(
                    children: <Widget>[
                      make_button(),
                      InkWell(
                        onTap: () {
                          if (widget.array
                              .containsKey(widget.document['name'])) {
                            // 이미 추가한적이 있다 -> 최신화
                            widget.array.update(widget.document['name'],
                                (dynamic val) => widget.count);
                            widget.array.putIfAbsent(
                                widget.document['name'], () => widget.count);
                            widget.money.putIfAbsent(
                                widget.document['name'], () => widget.document['price']);
                          } else {
                            // 처음추가
                            widget.array.putIfAbsent(
                                widget.document['name'], () => widget.count);
                            widget.money.putIfAbsent(
                                widget.document['name'], () => widget.document['price']);
                          }
                          print(widget.array);
                          print(widget.money);
                          _showDialog();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10, left : 60),
                          child: Text(
                            "장바구니 담기",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Expanded(
                  child: Row(
                children: <Widget>[
                  Container(
                    child: InkWell(
                      onTap: () {
                        print(widget.array);
                        if (widget.array.keys.toList().length != 0) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Food_purchase(select: widget.array, money : widget.money)));
                        } else {
                          _showDialog2();
                        }
                      },
                      child: Text(
                        "장바구니 확인",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width * 1,
                    height: 60,
                    alignment: Alignment(0, 0),
                    //              height: MediaQuery.of(ctx).size.height * 0.3,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
              ))
            ],
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        )));
  }

  @override
  Widget make_button() {
    var keys;
    return Container(
      margin: EdgeInsets.only(left: 60),
      child: Row(
        children: <Widget>[
          InkWell(
              onTap: () {
                setState(() {
                  widget.count = widget.count + 1;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey[400]),
                ),
                child: Icon(Icons.expand_less),
              )),
          Container(
              alignment: Alignment.center,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey[300]),
              ),
              child: Text(
                widget.count.toString(),
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
          InkWell(
              onTap: () {
                if (widget.count > 0) {
                  setState(() {
                    widget.count = widget.count - 1;
                  });
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey[400]),
                ),
                child: Icon(Icons.expand_more),
              )),
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (widget.count == 0) {
            return AlertDialog(
                title: new Text("Message"),
                content: new Text(
                  "선택된 상품이 없습니다. 수량을 최소 1개이상 선택해주세요",
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text("닫기"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          } else {
            return AlertDialog(
                title: new Text("Message"),
                content: new Text(widget.document['name'] +
                    ' ' +
                    widget.count.toString() +
                    "개가 장바구니에 담겼습니다."),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text("닫기"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          }
        });
  }

  void _showDialog2() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
            return AlertDialog(
                title: new Text("Message"),
                content: new Text(
                  "장바구니에 담긴 품목이 없습니다. 상품을 골라주세요.",
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
