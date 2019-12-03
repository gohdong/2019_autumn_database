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
    List<dynamic> ad;
    return StreamBuilder(

        stream:
          db.collection('member').document('email').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return Center(child: CircularProgressIndicator());}
        if(ad.length==0){
          return Text('좋아요를 눌러주세요');
        }
        else{
          ad = snapshot.data['like_movie'];
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
        }
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
    List<dynamic> ad;
    return StreamBuilder(

      stream:
      db.collection('member').document('email').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return Center(child: CircularProgressIndicator());}
        if(ad.length==0){
          return Text('리뷰를 남겨주세요');
        }
        else{
          ad = snapshot.data['like_movie'];
          return ListView.builder(
            primary: false,
            itemCount: ad.length,
            itemBuilder: (context, index) {
              return cardBuild3(ad[index]);
            },
          );
        }
      },
    );
  }
  Widget cardBuild3(String movieID) {
    return StreamBuilder(
      stream: db.collection('movie').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return Container(
          child: getMovieImg3(movieID),
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



}
