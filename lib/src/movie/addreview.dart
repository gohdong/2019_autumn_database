import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../data/sign_in.dart';

class AddReview extends StatefulWidget{
  String movieID;

  AddReview(String getID){
    movieID = getID;
  }

  @override
  _AddReviewState createState() => _AddReviewState(movieID);
}

class _AddReviewState extends State<AddReview> {
  String movieID;

  _AddReviewState(String getID){
    movieID = getID;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _description = TextEditingController();
  TextEditingController _title = TextEditingController();
  int _myScore;
  int _radioValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("리뷰"),),
      body: addReview(),
      floatingActionButton: FlatButton(
        child: Text("Post"),
        color: Colors.blueAccent,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _showDialog(context, Firestore.instance);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget addReview() {

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _title,
                        decoration: InputDecoration(hintText: 'Enter Title'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Input Title.";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
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

                    ],
                  ),
                ),
              ),
            ],
          ),

          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    Icon(Icons.thumb_down,color: Colors.red,)
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    Icon(Icons.thumbs_up_down,color: Colors.yellow,)
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    Icon(Icons.thumb_up,color: Colors.blue,)
                  ],
                ),
              ),

            ],
          ),
          Text(movieID),

        ],
      ),
    );
  }

  void _showDialog(BuildContext context, Firestore db) {
    int _currentCount;
    int _currentScore;


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
                await db.collection('reviews').add({
                  'title' : _title.text,
                  'description': _description.text,
                  'writer': "$name",
                  'memberID': email,
                  'date': Timestamp.now(),
                  'score': _myScore,
                  'movieID': movieID
                });
                await db.collection('member').document(email).updateData({
                  'review_movieID' : FieldValue.arrayUnion(
                    [movieID]
                  ),
                });

                await db.collection('movie').document(movieID).updateData({
                  'test' : 'test'
                });

                _description.clear();
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
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

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _myScore = 0;
          break;
        case 1:
          _myScore = 50;
          break;
        case 2:
          _myScore = 100;
          break;
      }
    });
  }

  Widget getCount() {
    return StreamBuilder(
      stream: Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context,snapshot){
        if (!snapshot.hasData) return Center(child: Text("Can't find"));
        return Text(
          snapshot.data['name'],
          textScaleFactor: 0.9,
        );
      },
    );
  }


}