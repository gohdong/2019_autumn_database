import 'package:dbapp/src/movie/addreview.dart';
import 'package:dbapp/src/data/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:dbapp/src/reservation/reservation_time_table.dart';

import '../home/newsfeed.dart';
import 'package:provider/provider.dart';
import '../data/is_login.dart';
import '../data/sign_in.dart';
import 'package:expandable/expandable.dart';

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
  bool pushLike = false;
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
//    final counter = Provider.of<Counter>(context);

    return Scaffold(
        appBar: AppBar(
          title: Image.asset('img/gva_logo1.png',height: 30,),
          centerTitle: true,
          elevation: 0,
          // If `TabController controller` is not provided, then a
          // DefaultTabController ancestor must be provided instead.
          // Another way is to use a self-defined controller, c.f. "Bottom tab
          // bar" example.
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.chat),
          onPressed: () {
            if (email == null) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Login(
                      )));
            } else {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddReview(movieID)));
            }
          },
        ),
        body: getMovieTrailer());
  }

  Widget getMovieTrailer() {
//    final counter = Provider.of<Counter>(context);

    return new StreamBuilder(
      stream:
          Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return ListView(
          physics: BouncingScrollPhysics(),
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
                          Icon(pushLike ? Icons.favorite : Icons.favorite_border,
                              color: Colors.pink),
                          Text(
                              snapshot.data['like'].toString())
                        ],
                      ),

                      onPressed: () {
                        if(email != null){
                          if(!pushLike){
                          try {
                          db.collection('movie').document(movieID)
                              .updateData({'like': snapshot.data['like']+1});
                          db.collection('member').document(email).updateData(
                            {'like_movie': FieldValue.arrayUnion([movieID])}
                          );
                        } catch (e) {
                          print(e.toString());
                          }
                        }
                        else{
                          try {
                            db.collection('movie').document(movieID)
                                .updateData({'like': snapshot.data['like']-1});
                          } catch (e) {
                            print(e.toString());
                          }
                        }
                        pushLike = !pushLike;}
                        else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Login(
                              )));
                        }
                      }
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
                      onPressed: () {                                                           //document.documentID, document
                        if(name==null){
                          Navigator.of(context).push(MaterialPageRoute
                            (builder: (context) => Login()));}
                        else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Show_time_table(snapshot.data.documentID, snapshot.data)));
//
                        }
                      },
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
          review(),
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
          physics: BouncingScrollPhysics(),
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
                  Container(
                    child: Icon(Icons.chat),
                    margin: EdgeInsets.only(left: 5),
                  ),
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
    return Column(
      children: <Widget>[
        reviewTop(),
        Flexible(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('reviews').where('movieID',isEqualTo: movieID).orderBy('date',descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ExpandablePanel(
                        header: Container(
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 25.0,
                                child: Text(
                                    snapshot.data.documents[index]['writer']),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data.documents[index]['title'],
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data.documents[index]['date']
                                            .toDate()
                                            .toString()
                                            .split('.')[0],
                                        textScaleFactor: 0.9,
                                        style: TextStyle(color: Colors.black45),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              reviewTail(
                                  snapshot.data.documents[index]['score'])
                            ],
                          ),
                        ),
                        expanded: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 70),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data.documents[index]['description'],
                                softWrap: true,
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
//                        Container(
//                            child: Row(
//                              children: <Widget>[
//                                Expanded(
//                                  child: Text(
//                                    'By ' + document['name'],
//                                    textScaleFactor: 1.5,
//                                    style: TextStyle(fontStyle: FontStyle.italic),
//                                  ),
//                                ),
//                                IconButton(
//                                  icon: Icon(Icons.delete_forever),
//                                  iconSize: 40,
//                                  onPressed: () {
//                                    _showDialog(context, db, document);
//                                  },
//                                )
//                              ],
//                            ))
                          ],
                        ),
                        tapHeaderToExpand: true,
                        hasIcon: false,
                      ),
                      Divider(
                        thickness: 1.5,
                        endIndent: 10,
                        indent: 10,
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }


  Widget starPoint(int score, double size) {
    if (score >= 95) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
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
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_half,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
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
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
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
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_half,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
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
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
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
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_half,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
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
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
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
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_half,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
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
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
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
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
          )),
          Expanded(
              child: Icon(
            Icons.star_border,
            color: Colors.amber,
            size: MediaQuery.of(context).size.height * size,
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
          size: MediaQuery.of(context).size.height * size,
        )),
        Expanded(
            child: Icon(
          Icons.star_border,
          color: Colors.amber,
          size: MediaQuery.of(context).size.height * size,
        )),
        Expanded(
            child: Icon(
          Icons.star_border,
          color: Colors.amber,
          size: MediaQuery.of(context).size.height * size,
        )),
        Expanded(
            child: Icon(
          Icons.star_border,
          color: Colors.amber,
          size: MediaQuery.of(context).size.height * size,
        )),
        Expanded(
            child: Icon(
          Icons.star_border,
          color: Colors.amber,
          size: MediaQuery.of(context).size.height * size,
        )),
      ],
    );
  }

  Widget actorBuild() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('roles')
          .where("movieID", isEqualTo: movieID)
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
          physics: const NeverScrollableScrollPhysics(),
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
            overflow: TextOverflow.ellipsis,
            maxLines: 14,
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

  Widget pentaGraph() {
    return null;
  }

  Widget reviewTail(int score) {
    if (score == 100) {
      return Icon(
        Icons.thumb_up,
        color: Colors.blue,
      );
    }
    if (score == 50) {
      return Icon(
        Icons.thumbs_up_down,
        color: Colors.amber,
      );
    }
    return Icon(
      Icons.thumb_down,
      color: Colors.red,
    );
  }

//  Widget getAvgScore(){
//    int _total = 0;
//    return StreamBuilder(
//      stream: Firestore.instance.collection('reviews').where('movieID', isEqualTo: movieID).snapshots(),
//      builder: (context,snapshot){
//        if (!snapshot.hasData)
//          return starPoint(0, 0.07);
//        return ListView.builder(
//          itemCount: snapshot.data.documents.length,
//          itemBuilder: (context, index) {
//            _total += snapshot.data.documents[index]['score'];
//
//            if(index == snapshot.data.documents.length-1){
//              return starPoint(_total/snapshot.data.documents.length, 0.07);
//            }
//            return null;
//
//          },
//        );
//      },
//    );
//  }

  Widget reviewTop(){
    return StreamBuilder(
      stream: Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }
        return Row(
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
                    snapshot.data['avgRating'].toInt().toString(),
                    textScaleFactor: 1.5,
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.8,
              child: starPoint(snapshot.data['avgRating'].toInt(), 0.07),
            ),
          ],
        );
      },
    );
  }





}
