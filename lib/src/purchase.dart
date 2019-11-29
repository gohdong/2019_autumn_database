import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';


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
                children: <Widget>[wishList(), Text(' 2')],
              ),
            ),
          ],
        ));
  }

  Widget myInfo() {
    return Container(
      color: Colors.black38,
      height: 150,
      child: Column(
        children: <Widget>[
//            Image.network(''),
          Container(child: Text('왕종휘')),
          Container(child: Text('wangjh789@gmail.com'))
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
  Widget cardBuild(String movie) {
    return StreamBuilder(
      stream:
          db.collection('movie').where('en_name', isEqualTo: movie).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return Container(
          child: getMovieImg(movie),
        );
      },
    );
  }

  Widget getMovieImg(String movie) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('movie')
          .where('en_name', isEqualTo: movie)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Container(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(
                  image: NetworkImage(
                    snapshot.data.documents[0]['img'],
                  ),
                fit: BoxFit.contain,),
              ),
              Text(
                snapshot.data.documents[0]['name'],
                textScaleFactor: 1.5,
              ),
              Text(
                snapshot.data.documents[0]['en_name'],
                textScaleFactor: 0.9,
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
                    onPressed: () {},
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
