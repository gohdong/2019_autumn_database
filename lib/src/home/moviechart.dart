import 'package:dbapp/src/movie/moviepage.dart';
import 'package:dbapp/src/reservation/reservation_time_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/reservation/reservation_time_table.dart';
import 'package:intl/intl.dart';

import '../data/sign_in.dart';
import '../data/login.dart';

class MovieChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MovieChartState();
}

class MovieChartState extends State<MovieChart> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: chart(size),
    );
  }

  Widget chart(size) {
    return Container(
      height: size.height * 0.5,
      padding: EdgeInsets.all(10),
      child: newsFeedBuild(),
    );
  }

  Widget newsFeedBuild() {
    return StreamBuilder(
      stream: db.collection('movie').orderBy('spectator',descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data.documents.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return cardBuild(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget cardBuild(DocumentSnapshot document) {
    Size size = MediaQuery.of(context).size;
    final formatter = new NumberFormat("#,###");
    return Container(
      decoration: BoxDecoration(
//        color: Colors.blue
          ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(2.5),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          Container(
            child: ConstrainedBox(

              constraints: BoxConstraints.expand(
                height: size.height*0.25
              ),
              child: FlatButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoviePage(document.documentID)));
                },
                padding: EdgeInsets.all(0.0),
                child: Image.network(
                  document['img'],
                ),
              ),
            ),
          ),

          Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                document['name'],
                textScaleFactor: 1.2,
                softWrap: false,
              )),
          Container(
              child: Text("관객수 : "+
            formatter.format(document['spectator']),
            style: TextStyle(
              color: Colors.black54
            ),
            textScaleFactor: 0.8,
          )),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 70,
            height: 30,
            child: OutlineButton(
              child: Text(
                "지금예매",
                textScaleFactor: 0.7,
              ),
              onPressed: () {
//                print("현재 이름 : " +  name);
                  if(name==null){
                    Navigator.of(context).push(MaterialPageRoute
                        (builder: (context) => Login()));}
                  else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Show_time_table(document.documentID, document)));
//                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Show_time_table()));
                  }
              },

              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
