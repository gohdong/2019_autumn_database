import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MovieChart extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MovieChartState();
}

class MovieChartState extends State<MovieChart> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: chart(),
    );
  }

  Widget chart(){
    return Container(
      height: MediaQuery.of(context).size.height*0.45,
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Flexible(child: newsFeedBuild())
        ],
      ),
    );
  }


  Widget newsFeedBuild() {
    return StreamBuilder(
      stream: db.collection('movie')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return cardBuild(snapshot.data.documents[index]);
          },
        );
      },
    );
  }




  Widget cardBuild(DocumentSnapshot document){
    return Container(
      decoration: BoxDecoration(
//        color: Colors.blue
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(2.5),
      width: MediaQuery.of(context).size.width*0.4,
      child: Column(

        children: <Widget>[
          Image.network(
              document['img'],
              width: MediaQuery.of(context).size.width*0.4,
          ),
          Container(margin:EdgeInsets.only(top: 5,bottom: 5),child: Text(document['name'],textScaleFactor: 1.2,softWrap: false,)),
          Container(child: Text("예매율",textScaleFactor: 0.8,)),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 70,
            height: 30,
            child: OutlineButton(
              child: Text("지금예매",textScaleFactor: 0.7,),
              onPressed: (){

              },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0))
                ,color: Colors.black,
            ),
          ),


        ],
      ),
    );
  }

}