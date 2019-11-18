import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Reservation extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home : Scaffold(body : FirestoreSlideshow())
    );
  }
}

class FirestoreSlideshow extends StatefulWidget{
  createState() => FirestoreSlideshowState();
}

class FirestoreSlideshowState extends State<FirestoreSlideshow>{

  final PageController ctrl = PageController(viewportFraction: 0.8);

  final Firestore db = Firestore.instance;
  Stream slides;

  String activeTag = 'favorites';

  int currentPage = 0;


  @override
  void initState(){
    _queryDb();

    ctrl.addListener((){
      int next = ctrl.page.round();

      if(currentPage != next){
        setState((){
          currentPage = next;
        });

      }
    });
  }

  @override
  Widget build(BuildContext context){
    return StreamBuilder(
        stream : slides,
        initialData : [],
        builder:(context, AsyncSnapshot snap){
          List slideList = snap.data.toList();

          return PageView.builder(

            controller : ctrl,
            itemCount: slideList.length + 1,
            // ignore: missing_return
            itemBuilder: (context, int currentIdx){

              if(currentIdx == 0){
                return _buildTagPage();
              } else if(slideList.length >= currentIdx){
                bool active = currentIdx == currentPage;
                return _buildStoryPage(context, slideList[currentIdx - 1], active);
              }

            },
          );
        }
    );

  }

  Stream _queryDb({ String tag = 'favorites'}){

    Query query = db.collection('test').where('tags', arrayContains : tag);

    slides = query.snapshots().map((list) => list.documents.map((doc) => doc.data));

    setState(() {
      activeTag = tag;

    });
  }


  _buildStoryPage(BuildContext context,Map data, bool active){

    final double blur = active ? 30:0;
    final double offset = active ? 20:0;
    final double top = active ? 120:200;

    return FlatButton(
      child : AnimatedContainer(
        duration: Duration(milliseconds : 500),
        curve : Curves.easeOutQuint,
        margin : EdgeInsets.only(top : top, bottom : 50, right : 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            image : DecorationImage(
              fit : BoxFit.cover,
              image : NetworkImage(data['img']),
            ),

            boxShadow: [BoxShadow(color : Colors.black87, blurRadius : blur, offset : Offset(offset, offset))]
        ),
        child : Center(
            child : Text(data['title'], style:TextStyle(fontSize : 40, color: Colors.white))
        )
        ,),
      onPressed:() {
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) => Detail(text : data['title'], img : data['img']))
        );
      },
    );
  }

  _buildTagPage(){
    return Container(child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        Text("Movies", style:TextStyle(fontSize : 40, fontWeight:FontWeight.bold),),
        Text("category", style : TextStyle(color : Colors.black26)),
        _buildButton('최신개봉'),
        _buildButton('액션'),
        _buildButton('범죄'),
        _buildButton('드라마'),
      ],
    )
    );
  }


  _buildButton(tag){
    Color color = tag == activeTag ? Colors.purple[200] : Colors.white;
    return FlatButton(color:color, child:Text('#$tag'), onPressed:() => _queryDb(tag:tag));
  }
}



class Detail extends StatelessWidget {

  final String text, img;

  Detail({Key key, @required this.text, @required this.img }) : super(key : key);


  @override
  Widget build(BuildContext context) {
    String str = "none";
    String str2 = "none";


    return Scaffold(
      appBar: AppBar(title: Text(text)),
      body: SingleChildScrollView( // 없으면, 화면을 벗어났을 때 볼 수 없음 (스크롤 지원)
        child: Column(
          children: <Widget>[
            Card(
              child : Image.network(img),
              margin: EdgeInsets.all(10),
              color: Colors.black12,
            ),
            Card(
              child : Image.network(img),
              margin: EdgeInsets.all(10),
              color: Colors.black12,
            ),

          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }
}



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
