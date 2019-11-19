import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'newsfeed.dart';

class MoviePage extends StatefulWidget {
  String movieID;

  MoviePage(String getID) {
    movieID = getID;
  }

  @override
  _MoviePageState createState() => _MoviePageState(movieID);
}

class _MoviePageState extends State<MoviePage> with SingleTickerProviderStateMixin{
  final db = Firestore.instance;
  TabController _controller;

  String movieID;

  _MoviePageState(String getID) {
    movieID = getID;
  }

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: getMovieTrailer());
  }

  Widget getMovieTrailer() {
    return new StreamBuilder(
      stream:
          Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: snapshot.data['trailer'],
                  flags: YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.12,
              margin: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.network(snapshot.data['img']),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              snapshot.data['name'],
                              textScaleFactor: 2,
                            ),
                            Container(
                              child: Image.asset(
                                'img/' + snapshot.data['rate'] + '.png',
                                width: 25,
                              ),
                              margin: EdgeInsets.only(left: 5),
                            )
                          ],
                        ),
                        Text(
                          snapshot.data['en_name'],
                          textScaleFactor: 1,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.favorite),
                          Text(snapshot.data['like'].toString())
                        ],
                      ),
                      onPressed: (){

                      },
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.open_in_new),
                          Text("공유하기")
                        ],
                      ),
                      onPressed: (){

                      },
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.bookmark),
                          Text("예매하기")
                        ],
                      ),
                      onPressed: (){

                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.black, indent: 10,endIndent: 10,),
            storeTab(),
            storeTabView()

          ],
        );
      },
    );
  }

  Widget storeTab(){
    return Container(
      height: MediaQuery.of(context).size.height*0.05,
      margin: EdgeInsets.all(10),
      decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
      child: new TabBar(
        controller: _controller,
        tabs: [
          new Tab(
            text: '관련소식',
          ),
          new Tab(
            text: '영화정보',
          ),
          new Tab(
            text: '실관람평',
          ),
        ],
      ),
    );
  }

  Widget storeTabView(){
    return Container(
      height: MediaQuery.of(context).size.height*0.75,
      margin: EdgeInsets.all(10),
      child: TabBarView(
        controller: _controller,
        children: <Widget>[
          newsFeedBuilder(),
          new Text("ss"),
          new Text("ad"),
        ],
      ),
    );
  }

  Widget newsFeedBuilder() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('feed')
          .where("movieID", isEqualTo: movieID)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {

            return Column(
              children: <Widget>[
                NewsFeed(snapshot.data.documents[index]),
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
