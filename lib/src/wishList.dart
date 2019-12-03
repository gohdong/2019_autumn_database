import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/data/is_login.dart';
import 'package:dbapp/src/data/sign_in.dart';
import 'package:dbapp/src/moviepage.dart';
import 'package:expandable/expandable.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList>
    with SingleTickerProviderStateMixin {
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
                children: <Widget>[wishList(), movieList(),reviewList()],
              ),
            ),
          ],
        ));
  }

  Widget myInfo() {
    final counter = Provider.of<Counter>(context);
    return Container(
      color: Colors.black87,
      height: 150,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          Container(
              child: email==null
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
                email == null?
            '로그인을 해주세요':name,
            textScaleFactor: 1.5,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
          Container(
              child: Text(
                email==null?
            '':email,
            style: TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }

  Widget wishList() {
    return StreamBuilder(
      stream:
          db.collection('member').document('email').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        List<dynamic> ad = snapshot.data['like_movie'];
        return GridView.builder(
          primary: false,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (0.53),
          ),
          itemCount: ad.length,
          itemBuilder: (context, index) {
            return cardBuild(ad[index]);
          },
        );
      },
    );
  }
  Widget cardBuild(String movieID) {
    return StreamBuilder(
      stream: db.collection('movie').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return Container(
          child: getMovieImg(movieID),
        );
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
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          primary: false,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return cardBuild2(snapshot.data.documents[index]['movieID'],
                snapshot.data.documents[index]['time_tableID'],snapshot.data.documents[index]['seats']);
          },
        );
      },
    );
  }
  Widget cardBuild2(String movieID, String timeTableID,List<dynamic> ad) {
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
  Widget getMovieImg2(String movieID, String timeTableID,List<dynamic> ad) {
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
                margin: EdgeInsets.only(top: 10,bottom: 10,right: 10),
                child: Image(
                  height:MediaQuery.of(context).size.height * 0.25,
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
                    height:MediaQuery.of(context).size.height *0.05 ,
                  ),
                  getTimeTable(timeTableID,ad),
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
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  Widget getTimeTable(String tableID,List<dynamic> seat) {
    return StreamBuilder(
      stream: db.collection('time_table').document(tableID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return Column(
            children: <Widget>[
              Text(snapshot.data['theater'].toString()+'관 / '+seat.toString()+'석'),
                  Text(
                  snapshot.data['startAt'].toDate().toString().split('.')[0]),
            ]);
      },
    );
  }

  Widget reviewList() {
    return StreamBuilder(
      stream:
      db.collection('member').document(email).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        List<dynamic> ad = snapshot.data['review_movieID'];
        return GridView.builder(
          primary: false,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (0.53),
          ),
          itemCount: ad.length,
          itemBuilder: (context, index) {
            return cardBuild3(ad[index],index);
          },
        );
      },
    );
  }
  Widget cardBuild3(String movieID,int index) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('movie')
          .document(movieID).collection('reviews').where('writer',isEqualTo: name)
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
                       getMovieImg3(movieID),
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
    );
  }
  Widget getMovieImg3(String movieID) {
    return StreamBuilder(
      stream:
      Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.2,
                child: Image(
                  image: NetworkImage(snapshot.data['img']),
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                snapshot.data['name'],
                textScaleFactor: 1,
              ),
              Text(
                snapshot.data['en_name'],
                textScaleFactor: 0.5,
              ),
            ],
          ),
        );
      },
    );
  }

}
