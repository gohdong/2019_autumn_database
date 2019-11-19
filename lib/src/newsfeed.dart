import 'package:dbapp/src/moviepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';



class NewsFeed extends StatefulWidget {
  DocumentSnapshot document;
  NewsFeed(DocumentSnapshot getDocument) {
    document = getDocument;
  }
  @override
  State<StatefulWidget> createState() => NewsFeedState(document);
}

class NewsFeedState extends State<NewsFeed> {
  final db = Firestore.instance;
  bool pushLike = false;
  DocumentSnapshot document;

  NewsFeedState(DocumentSnapshot getDoc){
    document = getDoc;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
//          border: Border.all()
            ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: getMovieImg(),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getMovieName(),
                  Text(document['date']
                      .toDate()
                      .toString()
                      .split('.')[0])
                ],
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoviePage(document['movieID'])));
              },

            ),

//            Container(
//              height: MediaQuery.of(context).size.height * 0.055,
//              padding: EdgeInsets.all(0),
//              decoration: BoxDecoration(
////                color: Colors.redAccent
//                  ),
//              child:
//                Row(
//                  children: <Widget>[
////                  CircleAvatar(
////                    radius: 25.0,
////                    backgroundImage: ImageProvider(),
////                  ),
//                    getMovieImg(),
//                    Container(
//                      margin: EdgeInsets.only(left: 10),
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          getMovieName(),
//                          Text(document['date']
//                              .toDate()
//                              .toString()
//                              .split('.')[0])
//                        ],
//                      ),
//                    )
//                  ],
//                ),
//              ),

            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15,right: 15),
                alignment: Alignment.centerLeft,
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(
//                  color: Colors.blue
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(document['description'].replaceAll("\\n", "\n")),
                  ],
                )),
            Divider(),
            Container(
              height: MediaQuery.of(context).size.height * 0.04,
              decoration: BoxDecoration(
//                  color: Colors.yellow
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "댓글 0",
                    textScaleFactor: 0.7,
                    style: TextStyle(color: Colors.black45),
                  ),
                  Text(
                    "개      ",
                    textScaleFactor: 0.7,
                    style: TextStyle(color: Colors.black45),
                  ),
                  Text("조회 ",
                      textScaleFactor: 0.7,
                      style: TextStyle(color: Colors.black45)),
                  Text(
                    document['view'].toString(),
                    textScaleFactor: 0.7,
                    style: TextStyle(color: Colors.black45),
                  ),
                  Text(
                    "      ",
                    textScaleFactor: 0.7,
                    style: TextStyle(color: Colors.black45),
                  ),
                  Text("좋아요 ",
                      textScaleFactor: 0.7,
                      style: TextStyle(color: Colors.black45)),
                  Text(
                    document['like'].toString(),
                    textScaleFactor: 0.7,
                    style: TextStyle(color: Colors.black45),
                  ),
                  Text(
                    "      ",
                    textScaleFactor: 0.7,
                    style: TextStyle(color: Colors.black45),
                  ),
                  Text("공유 ",
                      textScaleFactor: 0.7,
                      style: TextStyle(color: Colors.black45)),
                  Text(
                    document['share'].toString(),
                    textScaleFactor: 0.7,
                    style: TextStyle(color: Colors.black45),
                  ),
                  Text(
                    "건",
                    textScaleFactor: 0.7,
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.04,
//            decoration: BoxDecoration(color: Colors.redAccent),
                child: Row(
                  children: <Widget>[
                    Expanded(child: likeButton()),
                    Expanded(
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.chat_bubble_outline),
                            Text("  댓글달기")
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Icon(Icons.share), Text("  공유하기")],
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget getMovieName() {
    return new StreamBuilder(
      stream: Firestore.instance
          .collection('movie')
          .document(document['movieID'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Cannot Found..");
        }
        return new Text(snapshot.data['name']);
      },
    );
  }

  Widget getMovieImg() {
    return new StreamBuilder(
      stream: Firestore.instance
          .collection('movie')
          .document(document['movieID'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("X");
        }

//        return ClipOval(
//            child: Image.network(
//              snapshot.data['img'],
//              fit: BoxFit.cover,
//              height: MediaQuery.of(context).size.height * 0.055,
//              width: MediaQuery.of(context).size.height * 0.055,
//            )
//        );
        return CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(snapshot.data['img'],),
        );
      },
    );
  }

  void pushLikeButton() {
    if(pushLike){
      document.reference.updateData({
        'like' : document['like']
      });
    }
    else{
      document.reference.updateData({
        'like' : document['like']+1
      });
    }
    pushLike = !pushLike;

  }

  Widget likeButton() {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(pushLike ? Icons.favorite : Icons.favorite_border,
              color: Colors.pink),
          Text("  좋아요")
        ],
      ),
      onPressed: () {
        setState(() {
          pushLikeButton();
        });
      },
    );
  }

  Widget Feed(String movieID) {}
}
