import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Reserve extends StatelessWidget {

//  Detail({Key key, this.data}) : super(key: key);
//  final Map data;


  //final String text, img;

  //Detail({Key key, @required this.text, @required this.img }) : super(key : key);
  final Color posi = Colors.white;
  final Color imposi = Colors.grey;


  @override
  Widget build(BuildContext context) {
    String str = "red";
    String str2 = "blue";
    bool a = true;
    int num = 10;

    return Scaffold(
      appBar: AppBar(title: Text("Time_table")),
      body:  StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('time_table').where('number', isEqualTo: 1).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error : ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  itemExtent: 80,
                  children: snapshot.data.documents.map((document) => Start(context, document)).toList(),
                );
            }
          }
      ),


    );
  }

  Widget Start(BuildContext ctx, DocumentSnapshot document){
    return SingleChildScrollView( // 없으면, 화면을 벗어났을 때 볼 수 없음 (스크롤 지원)
      child: Center(
        child :
        Column( // 아래
          children: <Widget>[
            _Make_Screen(document),
            for(var i=0; i<12; i++)
              Row(
                children: <Widget>[
                  for(var j=0; j<10; j++)
                    _Make_box(i,j,document),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
              )
          ],
          // mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
        ),

      ),
    );
  }

  Widget _Make_Screen(document){
    return Center(
      child : InkWell(
        onTap:(){
          print("chi");
        },
        child : Container(
          margin : const EdgeInsets.only(top : 30, bottom : 30),
          width : 300.0,
          height : 48.0,
          decoration: BoxDecoration(
            border : Border.all(width : 1, color : Colors.black),
            color : posi,
          ),
          child : Center(
            child : Text("aa"),
          ),

        ),
      )

    );
  }


  Widget _Make_box(i,j,document) {
      String seat = "Z10";

      if(i == 0){
        seat = "A"+j.toString();
      }else if(i == 1){
        seat = "B"+j.toString();
      }else if(i == 2){
        seat = "C"+j.toString();
      }else if(i == 3){
        seat = "D"+j.toString();
      }else if(i == 4){
        seat = "E"+j.toString();
      }else if(i == 5){
        seat = "F"+j.toString();
      }else if(i == 6){
        seat = "G"+j.toString();
      }else if(i == 7){
        seat = "H"+j.toString();
      }else if(i == 8){
        seat = "I"+j.toString();
      }else if(i == 9){
        seat = "J"+j.toString();
      }else if(i == 10){
        seat = "K"+j.toString();
      }else if(i == 11){
        seat = "L"+j.toString();
      }


      return Center(
          child : InkWell(
              onTap:(){

              },
              child :  Container(
            margin : const EdgeInsets.only(top : 5, left : 1),
            width : 30.0,
            height : 30.0,
            decoration: BoxDecoration(
              border : Border.all(width : 1, color : Colors.black),
              color : posi,
            ),
            child : Center(
              child : Text("a"),
            )
        ),
    ),
      );
  }
}


//
//class FirestoreSlideshow extends StatefulWidget{
//  createState() => FirestoreSlideshowState();
//}
//
//
//class FirestoreSlideshowState extends State<FirestoreSlideshow>{
//
//  final PageController ctrl = PageController(viewportFraction: 0.8);
//
//  final Firestore db = Firestore.instance;
//  Stream slides;
//
//  String activeTag = 'favorites';
//
//  int currentPage = 0;
//
//
//  @override
//  void initState(){
//    _queryDb();
//
//    ctrl.addListener((){
//      int next = ctrl.page.round();
//
//      if(currentPage != next){
//        setState((){
//          currentPage = next;
//        });
//
//      }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context){
//    return StreamBuilder(
//        stream : slides,
//        initialData : [],
//        builder:(context, AsyncSnapshot snap){
//          List slideList = snap.data.toList();
//
//          return PageView.builder(
//
//            controller : ctrl,
//            itemCount: slideList.length + 1,
//            // ignore: missing_return
//            itemBuilder: (context, int currentIdx){
//
//              if(currentIdx == 0){
//                return _buildTagPage();
//              } else if(slideList.length >= currentIdx){
//                bool active = currentIdx == currentPage;
//                return _buildStoryPage(context, slideList[currentIdx - 1], active);
//              }
//
//            },
//          );
//        }
//    );
//
//  }
//
//  Stream _queryDb({ String tag = 'favorites'}){
//    Query query = db.collection('movie');
//    slides = query.snapshots().map((list) => list.documents.map((doc) => doc.data));
//
//    setState(() {
//      activeTag = tag;
//    });
//    if(tag == "전체"){
//      Query query = db.collection('movie');
//      slides = query.snapshots().map((list) => list.documents.map((doc) => doc.data));
//
//      setState(() {
//        activeTag = tag;
//      });
//    }
//    else{
//      Query query = db.collection('movie').where('tags', arrayContains : tag);
//      slides = query.snapshots().map((list) => list.documents.map((doc) => doc.data));
//
//      setState(() {
//        activeTag = tag;
//      });
//    }
//  }
//
//
//
//
//  _buildButton(tag){
//    Color color = tag == activeTag ? Colors.purple[200] : Colors.white;
//    return FlatButton(color:color, child:Text('#$tag'), onPressed:() => _queryDb(tag:tag));
//  }
//}




//class Reservation extends StatelessWidget{
//  final PageController ctrl = PageController(viewportFraction: 0.8);
//
//  @override
//  Widget build(BuildContext context){
//    return MaterialApp(
//      home : Scaffold(
//        body : PageView(
//          scrollDirection: Axis.vertical,
//          controller: ctrl,
//          children: <Widget>[
//            Container(color: Colors.green),
//            Container(color: Colors.blue),
//            Container(color: Colors.red),
//          ],
//        )
//
//      )
//    );
//  }
//}
//


//class Reservation extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final Size size = MediaQuery.of(context).size;
//    return Scaffold(
//      appBar : AppBar(title : Text("영화 예매")),
//      body : ListView(
//        children : <Widget>[
//          Text("영화 제목"),
//          seGallery(size),
//        ]
//      )
//    );
//  }
//
//  Widget seGallery(Size size) {
//    return Container(
//      height: size.height * 0.2,
//      child: ListView(
//        scrollDirection: Axis.horizontal,
//        children: <Widget>[
//          // ignore: sdk_version_ui_as_code
//          for(var a=0; a<5; a++)
//            InkWell(
//                child :Card(
//                  child: Image.network('https://movie-phinf.pstatic.net/20191113_203/1573610067050zNCj1_JPEG/movie_image.jpg',
//                  scale : 2),
//                  margin: EdgeInsets.all(10),
//                  color: Colors.black12,
//                  ),
//              onTap:(){},
//              )
//        ],
//      ),
//    );
//  }
//}
