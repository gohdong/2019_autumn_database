import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/data/is_login.dart';
import 'package:dbapp/src/data/sign_in.dart';
import 'package:dbapp/src/mypage/makeMovieTicket.dart';
import 'package:dbapp/src/movie/moviepage.dart';
import 'package:expandable/expandable.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> with SingleTickerProviderStateMixin {
  final db = Firestore.instance;

  TabController ctr;

  @override
  void initState() {
    super.initState();
    ctr = new TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: ListView(
          children: <Widget>[
            myInfo(),
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              margin: EdgeInsets.all(10),
              decoration:
                  new BoxDecoration(color: Theme.of(context).primaryColor),
              child: new TabBar(
                controller: ctr,
                tabs: [
                  new Tab(
                    text: '위시리스트',
                  ),
                  new Tab(
                    text: '내가 본 영화',
                  ),
                  new Tab(
                    text: '내가 쓴 리뷰',
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
//      margin: EdgeInsets.all(10),
              child: TabBarView(
                controller: ctr,
                children: <Widget>[wishList(), movieList(), reviewList()],
              ),
            ),
          ],
        ));
  }

  Widget myInfo() {
    return Container(
      color: Colors.black87,
      height: 150,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          Container(
              child: email == null
                  ? Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Icon(Icons.account_circle, size: 50))
                  : Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage('$imageUrl')))),
          Container(
              child: Text(
            email == null ? '로그인을 해주세요' : name,
            textScaleFactor: 1.5,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
          Container(
              child: Text(
            email == null ? '' : email,
            style: TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }

  Widget wishList() {
    return StreamBuilder(
      stream: db.collection('member').document(email).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return GridView.builder(
            primary: false,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (0.53),
            ),
            itemCount: snapshot.data['like_movie'].length,
            itemBuilder: (context, index) {
              return getMovieImg(snapshot.data['like_movie'][index]);
            },
          );
        }
      },
    );
  }

  Widget getMovieImg(String movieID) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Container(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(
                  image: NetworkImage(snapshot.data['img']),
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                snapshot.data['name'],
                textScaleFactor: 1.7,
              ),
              Text(
                snapshot.data['en_name'],
                textScaleFactor: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.open_in_new,
                        ),
                        Text("공유")
                      ],
                    ),
                    onPressed: () {},
                  ),
                  OutlineButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.bookmark),
                        Text("예매"),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MoviePage(movieID)));
                    },
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget movieList() {
    return StreamBuilder(
      stream: db
          .collection('payment_movie')
          .where('email', isEqualTo: email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.documents == null)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          primary: false,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return snapshot.data.documents[index]['used'] == false
                ? FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    child: cardBuild2(
                        snapshot.data.documents[index]['movieID'],
                        snapshot.data.documents[index]['time_tableID'],
                        snapshot.data.documents[index]['seats']),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MakeMovieTicket(
                            snapshot.data.documents[index].documentID)));
                  },
                )
                : ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.color),
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        child: cardBuild2(
                            snapshot.data.documents[index]['movieID'],
                            snapshot.data.documents[index]['time_tableID'],
                            snapshot.data.documents[index]['seats']),
                      ),
                      onPressed: (){
                        null;
                      },
                    ),
                  );
          },
        );
      },
    );
  }

  Widget cardBuild2(String movieID, String timeTableID, List<dynamic> ad) {
    return StreamBuilder(
      stream: db.collection('movie').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return Container(
          color: Colors.grey[50],
          child: getMovieImg2(movieID, timeTableID, ad),
        );
      },
    );
  }

  Widget getMovieImg2(String movieID, String timeTableID, List<dynamic> ad) {
    DocumentSnapshot document;
    return StreamBuilder(
      stream:
          Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Card(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: Image(
                  height: MediaQuery.of(context).size.height * 0.25,
                  image: NetworkImage(snapshot.data['img']),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    snapshot.data['name'],
                    textScaleFactor: 1.5,
                  ),
                  Text(
                    snapshot.data['en_name'],
                    textScaleFactor: 0.9,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  getTimeTable(timeTableID, ad),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OutlineButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.open_in_new,
                            ),
                            Text("리뷰")
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MoviePage(movieID)));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getTimeTable(String tableID, List<dynamic> seat) {
    return StreamBuilder(
      stream: db.collection('time_table').document(tableID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return Column(children: <Widget>[
          Text(snapshot.data['theater'].toString() +
              '관 / ' +
              seat.toString() +
              '석'),
          Text(snapshot.data['startAt'].toDate().toString().split('.')[0]),
        ]);
      },
    );
  }

  Widget reviewList() {
    return StreamBuilder(
      stream: db
          .collection('reviews')
          .where('memberID', isEqualTo: email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            primary: false,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return cardBuild3(
                  snapshot.data.documents[index]['movieID'],
                  snapshot.data.documents[index]['title'],
                  snapshot.data.documents[index]['description'],
                  snapshot.data.documents[index]['score'],
                  snapshot.data.documents[index]['date']
                      .toDate()
                      .toString()
                      .split('.')[0]);
            },
          );
        }
      },
    );
  }

  Widget cardBuild3(String movieID, String title, String description, int score,
      String date) {
    return StreamBuilder(
      stream: db.collection('movie').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  child: getMovieImg3(movieID)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  getMovieName(movieID),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    textScaleFactor: 1.2,
                  ),
                  Text(description),
                  SizedBox(
                    height: 30,
                  ),
                  Text(date + ' 작성'),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget getMovieImg3(String movieID) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Container(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Image(
              image: NetworkImage(snapshot.data['img']),
            ),
          ),
        );
      },
    );
  }

  Widget getMovieName(String movieID) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Column(
            children: <Widget>[
              Text(
                snapshot.data['name'],
                textScaleFactor: 1.3,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                snapshot.data['en_name'],
                textScaleFactor: 0.8,
              ),
            ],
          ),
        );
      },
    );
  }
}
