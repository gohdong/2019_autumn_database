import 'package:cloud_firestore/cloud_firestore.dart';
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
              Container(
                  alignment: Alignment.center,
                  child:
                  Image.network(widget.document['img'],
                  height: MediaQuery.of(context).size.height * 0.55), // 제품사진
                  ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
                  ),
                ),
              ),// 중간 줄 생성
              Container(
//                decoration: BoxDecoration(
//                    border: Border.all(width: 1, color: Colors.blue),
//                ),
                  height: MediaQuery.of(context).size.height * 0.24,
                  child:
              Row(
                children: <Widget>[
                  Container(
//                    decoration: BoxDecoration(
//                      border: Border.all(width: 1, color: Colors.blue),
//                    ),
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child:
                    Column(
                    children: <Widget>[
                      Container(
//                        decoration: BoxDecoration(
//                          border: Border.all(width: 1, color: Colors.red),
//                        ),
                        margin: EdgeInsets.only(left: 25, top : 27),
                        child: Text(
                          widget.document['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
//                        decoration: BoxDecoration(
//                          border: Border.all(width: 1, color: Colors.purple),
//                        ),
                        margin: EdgeInsets.only(top: 10, left: 25),
                        child: Text(

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
                  ),// 상
                  ),// 품이름 / 상품가격
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: EdgeInsets.only(top : 27),
//                    decoration: BoxDecoration(
//                      border: Border.all(width: 1, color: Colors.blue),
//                    ),
                    child:
                    Column(children: <Widget>[
                      make_button(),
                      InkWell( // 장바구니 추가
                        onTap: () {
                          if (widget.array
                              .containsKey(widget.document['name'])) { //맵에 키가 존재
                            if(widget.count > 0){ // 개수 1개 이상으로 변경
                              // 이미 추가한적이 있다 -> 최신화
                              widget.array.update(widget.document['name'],
                                      (dynamic val) => widget.count);
                              widget.array.putIfAbsent(
                                  widget.document['name'], () => widget.count);
                              widget.money.putIfAbsent(
                                  widget.document['name'], ()=> widget.document['price']);
                              _showDialog2("장바구니 내의 "+widget.document['name']+"의 수량이 "+widget.count.toString()+"개로 변경되었습니다.");
                            }else{ // 개수 0개로 변경 -> 삭제
                              // 이미 추가한적이 있다 -> 최신화다
                              widget.array.remove(widget.document['name']);
                              _showDialog2("상품이 삭제되었습니다");
                            }
                          } else { // 맵에 키가 없음
                            if(widget.count == 0){
                              _showDialog2("0개의 상품이 선택되었습니다. 1개이상 상품을 선택해주세요");
                            }
                            else {
                              // 처음추가
                              widget.array.putIfAbsent(
                                  widget.document['name'], () => widget.count);
                              widget.money.putIfAbsent(
                                  widget.document['name'], () =>
                              widget.document['price']);
                              _showDialog();
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width : 150,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent
                          ),
                          margin: EdgeInsets.only(top: 15),
                          child: Text(
                            "장바구니 담기",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                      mainAxisAlignment: MainAxisAlignment.start,
                  )
                    ,)
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),),
              Expanded(
                  child:
                  Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () { // 결제하기
                        if (widget.array
                            .containsKey(widget.document['name'])) { //맵에 키가 존재
                          if(widget.count > 0){ // 개수 1개 이상으로 변경
                            // 이미 추가한적이 있다 -> 최신화
                            widget.array.update(widget.document['name'],
                                    (dynamic val) => widget.count);
                            widget.array.putIfAbsent(
                                widget.document['name'], () => widget.count);
                            widget.money.putIfAbsent(
                                widget.document['name'], ()=> widget.document['price']);
                          }else{ // 개수 0개로 변경 -> 삭제
                            // 이미 추가한적이 있다 -> 최신화다
                            widget.array.remove(widget.document['name']);
                          }
                        } else { // 맵에 키가 없음
                          if(widget.count == 0){
//                            _showDialog2("0개의 상품이 선택되었습니다. 1개이상 상품을 선택해주세요");
                          }
                          else {
                            // 처음추가
                            widget.array.putIfAbsent(
                                widget.document['name'], () => widget.count);
                            widget.money.putIfAbsent(
                                widget.document['name'], () =>
                            widget.document['price']);
//                            _showDialog();
                          }

                        }

                        if (widget.array.keys.toList().length != 0) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Food_purchase(select: widget.array, money : widget.money)));
                        } else {
                          _showDialog2("장바구니에 담긴 품목이 없습니다. 상품을 골라주세요.");
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
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
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width * 1,
                    height: 30,
//                    alignment: Alignment(0, 0),
                    //              height: MediaQuery.of(ctx).size.height * 0.3,
                  ),
               )
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
        width: MediaQuery.of(context).size.width * 0.45,
//      decoration: BoxDecoration(
//        border: Border.all(width: 1, color: Colors.orange),
//      ),
//      decoration: BoxDecoration(
//        border: Border.all(width: 2, color: Colors.black),
//      ),
      alignment: Alignment.center,
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
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.black),
                ),
                child: Icon(Icons.expand_less),
              )),// up버튼
          Container(
              alignment: Alignment.center,
              width: 40,
              height: 40,
//              decoration: BoxDecoration(
//                border: Border.all(width: 2, color: Colors.grey[300]),
//              ),
              child: Text(
                widget.count.toString(),
                style: TextStyle(
                  fontSize: 20,
                ),
              )), // 카운트
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
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.black),
                ),
                child: Icon(Icons.expand_more),
              )),// down 버
        ],mainAxisAlignment: MainAxisAlignment.center,
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
                  "장바구니에 담긴 물건이 없습니다. 상품을 1개이상 담아주세요",
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

  void _showDialog2(str) {
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
