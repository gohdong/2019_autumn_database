import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/store/store_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';



class StoreBottom extends StatefulWidget {

  String title;
  StoreBottom(String gettitle) {
    title = gettitle;
  }

  @override
  _StoreBottomState createState() => _StoreBottomState();
}

class _StoreBottomState extends State<StoreBottom> {
//  final Map<String, int> _suggestions = {};

//  final Set<Map<String, int>> _array = Set<Map<String, int>>();

  var test = Map<String, int>();
  var test2 = Map<String, int>();
//  var a = List<String>();
//  var ab= Map<int, String>();
////  final Set<bag> _suggestions = Set<bag>();
//  final String str = "before";
//  final List<String> array = ['a', 'b', 'c'];
//  List<String> seatlist = [];

  List<String> _array = [];


  @override
  Widget build(BuildContext context) {
//    test.add

//    _array.add("apple");
//    _array.add("banana");
//    _array.add("orange");
//    print("first : " + _array.length.toString());
//    print(_array);

    if(widget.title == "food" || widget.title == "package"){
      return make_stream("food");

    }
    else if(widget.title == "card"){
      return Text("card");
    }
    else if(widget.title == "package"){
      return make_stream(widget.title);
    }
    else{ // title == ticket
      return make_stream(widget.title);
    }

  }

  @override
  Widget make_stream(name){
    return
      Scaffold(
        body:SingleChildScrollView(child:
        StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('store')
                .where('category', isEqualTo: 'food')
//          .orderBy('key', )
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error : ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                physics: BouncingScrollPhysics(),
//                  shrinkWrap: true,
//                crossAxisAlignment: WrapCrossAlignment.start,
                    children: snapshot.data.documents
                        .map((document) => make_contents(context, document))
                        .toList(),
                  );
              }
            }))
          );

  }

  @override
  Widget make_contents(BuildContext ctx, DocumentSnapshot document){
    int sub = document['price'];
    FlutterMoneyFormatter price = FlutterMoneyFormatter(
        amount: double.parse((sub).toString())
    );
    return InkWell(

      onTap: (){
//        print(str);
        Navigator.of(ctx).push( MaterialPageRoute(builder: (context) => StoreDetail(array : test, money : test2, document : document)));

      },
      child:  Container(
        decoration: BoxDecoration(
          border: Border(
            bottom:
            BorderSide(width: 1.0, color: Colors.grey[400]),
          ),),
        width: MediaQuery.of(ctx).size.width * 1,
        child:
        Row(children: <Widget>[
          Container(

            margin: EdgeInsets.only(right : 15),
            child:
            Image.network(document['img'],
                width: MediaQuery.of(ctx).size.width * 0.3),),
          Container(
            child:
            Column(children: <Widget>[
              Container(child: Text(document['name'], style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),),
              Container(
                width: MediaQuery.of(ctx).size.width * 0.6,
                child: Text(document['desc'], style: TextStyle(
                fontSize: 15,
                color: Colors.grey[500],
              ),),),
              Container(
                margin : EdgeInsets.only(top : 5),
                child: Text(price.output.withoutFractionDigits.toString()+ "원", style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),),),
            ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            ),)
        ],),),);
  }
}
//class StoreBottom extends StatelessWidget {
//
//  String title;
//  StoreBottom(String gettitle) {
//    title = gettitle;
//
//  }
//
//  final List<String> array = ["apple"];
//  final String str = "before";
//
//  @override
//  Widget build(BuildContext context) {
//    if(title == "food"){
//      return make_stream(title);
//    }
//    else if(title == "card"){
//      return Text("card");
//    }
//    else if(title == "package"){
//      return make_stream(title);
//    }
//    else{ // title == ticket
//      return make_stream(title);
//    }
//
//  }
//
//  @override
//  Widget make_stream(name){
//    return StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance
//            .collection('store')
//            .where('category', isEqualTo: name)
////          .orderBy('key', )
//            .snapshots(),
//        builder:
//            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//          if (snapshot.hasError) return new Text('Error : ${snapshot.error}');
//          switch (snapshot.connectionState) {
//            case ConnectionState.waiting:
//              return new Text('Loading...');
//            default:
//              return new Wrap(
////                  shrinkWrap: true,
//                crossAxisAlignment: WrapCrossAlignment.start,
//                children: snapshot.data.documents
//                    .map((document) => make_contents(context, document))
//                    .toList(),
//              );
//          }
//        });
//  }
//
//  @override
//  Widget make_contents(BuildContext ctx, DocumentSnapshot document){
//    int sub = document['price'];
//    FlutterMoneyFormatter price = FlutterMoneyFormatter(
//        amount: double.parse((sub).toString())
//    );
//    return InkWell(
//
//      onTap: (){
//        print(str);
//        Navigator.of(ctx).push( MaterialPageRoute(builder: (context) => StoreDetail(str : str, array : array, document2 : document)));
//
//      },
//      child:  Container(
//      decoration: BoxDecoration(
//        border: Border(
//          bottom:
//          BorderSide(width: 1.0, color: Colors.grey[400]),
//        ),),
//      width: MediaQuery.of(ctx).size.width * 1,
//      child:
//        Row(children: <Widget>[
//          Container(
//
//            margin: EdgeInsets.only(right : 15),
//            child:
//              Image.network(document['img'],
//                  width: MediaQuery.of(ctx).size.width * 0.3),),
//          Container(
//            child:
//            Column(children: <Widget>[
//              Container(child: Text(document['name'], style: TextStyle(
//                fontWeight: FontWeight.bold,
//              ),),),
//              Container(child: Text(document['desc'], style: TextStyle(
//                color: Colors.grey[500],
//              ),),),
//              Container(
//                margin : EdgeInsets.only(top : 5),
//                child: Text(price.output.withoutFractionDigits.toString()+ "원"),),
//            ],
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.start,
//            ),)
//        ],),),);
//  }
//}