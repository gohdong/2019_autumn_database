import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/is_login.dart';
import '../data/sign_in.dart';

// ignore: must_be_immutable
class Comment extends StatefulWidget {
  String feedID;
  Widget img;
  String desc;

  Comment(String getFeedID,String getDesc,Widget getImg) {
    feedID = getFeedID;
    desc = getDesc;
    img = getImg;
  }

  @override
  CommentState createState() => CommentState(feedID,desc,img);
}

class CommentState extends State<Comment> {
  String feedID;
  Widget img;
  String desc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _description = TextEditingController();

  CommentState(String getMovieId,String getDesc,Widget getImg) {
    feedID = getMovieId;
    desc = getDesc;
    img = getImg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("댓글"),
      ),
      body: commentBuild(),
    );
  }

  Widget commentBuild() {
//    final counter = Provider.of<Counter>(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('comments')
          .where('feedID', isEqualTo: feedID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.documents.length + 2,
          itemBuilder: (context, index) {
            if(index==0){
              return Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        img,
                        Container(margin:EdgeInsets.only(left: 10),child: Text(desc.replaceAll("\\n", "\n")))
                      ],
                    ),
                    Divider(color: Colors.black,thickness: 1)
                  ],
                ),
              );
            }

            if (index == snapshot.data.documents.length + 1) {
              return Container(margin: EdgeInsets.only(top: 20),child: enterComment(email));

            }

            return commentTile(snapshot.data.documents[index - 1]);
          },
        );
      },
    );
  }

  Widget commentTile(DocumentSnapshot document) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      margin: EdgeInsets.only(left: 10,right: 10),
      child: Container(
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25.0,
              child: Text(document['writer']),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    document['writer'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaleFactor: 1.1,
                  ),
                  Container(
                    child: Text(
                      document['description'],
                        overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black45),
                      textScaleFactor: 0.9,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget enterComment(String email) {
    if (email == null) {
      return addCommentNotLogin();
    }

    return addCommentLogin();
  }

  Widget addCommentLogin() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _description,
                decoration: InputDecoration(hintText: 'Enter Description'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Input Description.";
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.15,
            child: FlatButton(
              child: Text("Post",textScaleFactor: 0.9,),
              color: Colors.blueAccent,
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _showDialog(context, Firestore.instance);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget addCommentNotLogin() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _description,
                decoration: InputDecoration(hintText: '로그인후 이용하세요'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Input Description.";
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.15,
            child: FlatButton(
              child: Text("Post",textScaleFactor: 0.9,),
              color: Colors.blueAccent,
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              onPressed: (){

              },

            ),
          )
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, Firestore db) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Alert"),
          content: new Text("Are you sure to add it?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                await db.collection('comments').add({
                  'description': _description.text,
                  'writer': "$name",
                  'date': Timestamp.now(),
                  'feedID': feedID
                });
                _description.clear();
                Navigator.of(context).pop();
              },
              textColor: Colors.blue,
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Colors.red,
            ),
          ],
        );
      },
    );
  }
}
