import 'package:dbapp/src/menubar.dart';
import 'package:dbapp/src/moviechart.dart';
import 'package:dbapp/src/newsfeed.dart';
import 'package:dbapp/src/random_trailer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            child: newsFeedBuild(),
          ),
        ],
      ),
    );
  }

  Widget newsFeedBuild() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('feed')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.documents.length+3,
          itemBuilder: (context, index) {
            if(index==0){
              return RandomTrailer();
            }
            if(index==1){
              return Divider();
            }
            if(index==2){
              return MovieChart();
            }

            return Column(
              children: <Widget>[
                NewsFeed(snapshot.data.documents[index-3]),
                Divider(
                  height: 10,
                  color: Colors.white,
                )
              ],
            );
          },
        );
      },
    );
  }
}