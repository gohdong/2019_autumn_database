import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/data/is_login.dart';
import 'package:dbapp/src/data/sign_in.dart';
import 'package:dbapp/src/moviepage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Purchase extends StatefulWidget {
  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase>
    with SingleTickerProviderStateMixin {
  final db = Firestore.instance;

  TabController ctr;

  @override
  void initState() {
    super.initState();
    ctr = new TabController(vsync: this, length: 2);
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
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
//      margin: EdgeInsets.all(10),
              child: TabBarView(
                controller: ctr,
                children: <Widget>[wishList(), movieList()],
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
              child: counter.getCounter() == 0
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
            '왕종휘',
            textScaleFactor: 1.5,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
          Container(
              child: Text(
            'wangjh789@gmail.com',
            style: TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }

  Widget wishList() {
    return StreamBuilder(
      stream:
          db.collection('member').document('wangjh789@gmail.com').snapshots(),
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

//DocumentSnapshot document
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

//DocumentSnapshot document
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
                              builder: (context) => MoviePage(document['movieID'])));
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
}
