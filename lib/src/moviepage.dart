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

class _MoviePageState extends State<MoviePage>
    with SingleTickerProviderStateMixin {
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
              decoration: BoxDecoration(color: Colors.white),
              child: Container(
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
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(color: Colors.white),
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
                      onPressed: () {},
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
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Icon(Icons.bookmark), Text("예매하기")],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            storeTab(),
            storeTabView()
          ],
        );
      },
    );
  }

  Widget storeTab() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      margin: EdgeInsets.all(10),
      decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
      child: new TabBar(
        controller: _controller,
        tabs: [
          new Tab(
            text: '영화정보',
          ),
          new Tab(
            text: '관련소식',
          ),
          new Tab(
            text: '실관람평',
          ),
        ],
      ),
    );
  }

  Widget storeTabView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
//      margin: EdgeInsets.all(10),
      child: TabBarView(
        controller: _controller,
        children: <Widget>[
          movieInfo(),
          newsFeedBuilder(),
          review2(),
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
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
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

  Widget movieInfo() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(color: Colors.white),
          height: MediaQuery.of(context).size.height * 0.12,
          child: getMovieInfo(),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.white),
          height: MediaQuery.of(context).size.height * 0.3,
          margin: EdgeInsets.all(10),
          child: actorBuild(),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          margin: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.chat),
                  Text("    "),
                  getMovieDesc(),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget review() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('reviews')
          .where('movieID', isEqualTo: movieID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.documents.length+1,
          itemBuilder: (context,index){
            if(index ==0 ){
              return  Row(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "평점",
                          textScaleFactor: 2,
                        ),
                        Text(
                          "80",
                          textScaleFactor: 1.5,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: starPoint(80),
                  ),
                ],
              );
            }
            return null;
          },
        );
      },
    );


  }

  Widget review2() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "평점",
                    textScaleFactor: 2,
                  ),
                  Text(
                    "80",
                    textScaleFactor: 1.5,
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.8,
              child: starPoint(80),
            ),
          ],
        )
      ],
    );
  }

  Widget starPoint(int score) {
    if (score >= 95) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
        ],
      );
    } else if (score >= 85) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_half,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
        ],
      );
    } else if (score >= 75) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
        ],
      );
    } else if (score >= 65) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_half,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
        ],
      );
    } else if (score >= 55) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
        ],
      );
    } else if (score >= 45) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_half,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
        ],
      );
    } else if (score >= 35) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
        ],
      );
    } else if (score >= 25) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_half,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
        ],
      );
    } else if (score >= 15) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
        ],
      );
    } else if (score >= 15) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star_half,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * 0.1,
          )),
        ],
      );
    }
    return Row(
      children: <Widget>[
        Expanded(
            child: Icon(
          Icons.star_border,
          color: Colors.amber,
          size: MediaQuery.of(context).size.height * 0.1,
        )),
        Expanded(
            child: Icon(
          Icons.star_border,
          color: Colors.amber,
          size: MediaQuery.of(context).size.height * 0.1,
        )),
        Expanded(
            child: Icon(
          Icons.star_border,
          color: Colors.amber,
          size: MediaQuery.of(context).size.height * 0.1,
        )),
        Expanded(
            child: Icon(
          Icons.star_border,
          color: Colors.amber,
          size: MediaQuery.of(context).size.height * 0.1,
        )),
        Expanded(
            child: Icon(
          Icons.star_border,
          color: Colors.amber,
          size: MediaQuery.of(context).size.height * 0.1,
        )),
      ],
    );
  }

  Widget actorBuild() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('roles')
          .where("movieID", isEqualTo: movieID)
//          .orderBy('importance')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 5),
          ),
          itemCount: snapshot.data.documents.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return getDirector();
            } else {
              return Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    getActorImg(snapshot.data.documents[index - 1]['actorID']),
                    Text("    "),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        getActorName(
                            snapshot.data.documents[index - 1]['actorID']),
                        getEngActorName(
                            snapshot.data.documents[index - 1]['actorID']),
                        Text(
                          snapshot.data.documents[index - 1]['role'] + " 역",
                          textScaleFactor: 0.8,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget getDirector() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('directors')
          .where('films', arrayContains: movieID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.only(left: 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundImage:
                    NetworkImage(snapshot.data.documents[0]['img']),
              ),
              Text("    "),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    snapshot.data.documents[0]['name'],
                    textScaleFactor: 0.9,
                  ),
                  Text(
                    snapshot.data.documents[0]['en_name'],
                    textScaleFactor: 0.7,
                  ),
                  Text(
                    "감독",
                    textScaleFactor: 0.8,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
//    return
  }

  Widget getActorName(String who) {
    return StreamBuilder(
      stream: Firestore.instance.collection('actor').document(who).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Text(
          snapshot.data['name'],
          textScaleFactor: 0.9,
        );
      },
    );
  }

  Widget getEngActorName(String who) {
    return StreamBuilder(
      stream: Firestore.instance.collection('actor').document(who).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Text(
          snapshot.data['en_name'],
          textScaleFactor: 0.6,
        );
      },
    );
  }

  Widget getActorImg(String who) {
    return StreamBuilder(
      stream: Firestore.instance.collection('actor').document(who).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(snapshot.data['img']),
        );
      },
    );
  }

  Widget getMovieDesc() {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            snapshot.data['summary'].replaceAll("\\n", "\n"),
            textScaleFactor: 1,
          ),
        );
      },
    );
  }

  Widget getMovieInfo() {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10),
              height: MediaQuery.of(context).size.height * 0.04,
              child: Row(
                children: <Widget>[
                  Icon(Icons.movie),
                  Text("  "),
                  Text(snapshot.data['name']),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              height: MediaQuery.of(context).size.height * 0.04,
              child: Row(
                children: <Widget>[
                  Icon(Icons.access_time),
                  Text("  "),
                  Text(snapshot.data['runningtime'].toString() + "분"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              height: MediaQuery.of(context).size.height * 0.04,
              child: Row(
                children: <Widget>[
                  Icon(Icons.person),
                  Text("  "),
                  snapshot.data['rate'] == "all"
                      ? Text("전체 관람가")
                      : Text(snapshot.data['rate'] + "세 관람가"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
