import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MakeMovieTicket extends StatefulWidget {
  String reservationID;

  MakeMovieTicket(String getID) {
    this.reservationID = getID;
  }

  @override
  _MakeMovieTicketState createState() => _MakeMovieTicketState(reservationID);
}

class _MakeMovieTicketState extends State<MakeMovieTicket> {
  String reservationID;

  _MakeMovieTicketState(String getID) {
    this.reservationID = getID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'img/gva_logo1.png',
            height: 30,
          ),
          centerTitle: true,
          elevation: 0,
          // If `TabController controller` is not provided, then a
          // DefaultTabController ancestor must be provided instead.
          // Another way is to use a self-defined controller, c.f. "Bottom tab
          // bar" example.
        ),
        body: getMovieTicket());
  }

  Widget getStoreExchange() {
    return Text("store");
  }

  Widget getMovieTicket() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('payment_movie')
          .document(reservationID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              QrImage(
                data: snapshot.data.documentID,
                version: 3,
                size: MediaQuery.of(context).size.width * 0.7,
              ),
              getReservationData(
                snapshot.data['time_tableID'],
                Text(
                  seatList2String(snapshot.data['seats']),
                  textScaleFactor: 1.2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    padding: EdgeInsets.only(top: 15,bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.redAccent
                    ),
                    width: MediaQuery.of(context).size.width*0.65,
                    child: Center(child: Text("예매 취소",style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),textScaleFactor: 1.5,),),
                  ),
                  onPressed: () {
                    _showDialog(context);
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget getReservationData(String tableID, Widget seat) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('time_table')
          .document(tableID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: <Widget>[
            getMovieData(snapshot.data['movieID']),
            Text(
              "시작 시간 : " +
                  snapshot.data['startAt'].toDate().toString().split(':')[0] +
                  ":" +
                  snapshot.data['startAt'].toDate().toString().split(':')[1],
              textScaleFactor: 1.3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  snapshot.data['theater'] + "관  ",
                  textScaleFactor: 1.7,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                seat,
              ],
            ),
          ],
        );
      },
    );
  }

  Widget getMovieData(String movieID) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('movie').document(movieID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Text(
          snapshot.data['name'],
          textScaleFactor: 2,
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      },
    );
  }

  String seatList2String(List seats) {
    return seats.join(' , ');
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of reservationID Dialog
        return CupertinoAlertDialog(
          title: new Text("확인"),
          content: new Text("정말 취소 하시겠습니까?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                await Firestore.instance.collection('payment_movie').document('s2xGOcXdVAdoimnX8m89').delete();
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
}
