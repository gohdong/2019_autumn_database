import 'package:dbapp/src/movie/moviepage.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class RandomTrailer extends StatefulWidget {
  @override
  _RandomTrailerState createState() => _RandomTrailerState();
}

class _RandomTrailerState extends State<RandomTrailer> {
  final db = Firestore.instance;
  var randNum = Random().nextInt(100);

  @override
  Widget build(BuildContext context) {
    return trailerBuilder();
  }

  Widget trailerBuilder() {
    return StreamBuilder(
      stream: db.collection('movie').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: snapshot.data
                      .documents[randNum % snapshot.data.documents.length]
                  ['trailer'],
                  flags: YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: ListTile(
                leading: ClipOval(
                    child: Image.network(
                      snapshot.data
                          .documents[randNum % snapshot.data.documents.length]
                      ['img'],
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.height * 0.055,
                    )),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      snapshot.data.documents[
                      randNum % snapshot.data.documents.length]['name'],
                      textScaleFactor: 1.1,
                    ),
                    Text(
                      "예고편 공개!",
                      textScaleFactor: 0.9,
                    )
                  ],
                ),
                trailing: OutlineButton(
                  child: Text("더 알아보기"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MoviePage(snapshot
                            .data
                            .documents[randNum % snapshot.data.documents.length]
                            .documentID)));
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}