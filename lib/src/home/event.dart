import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/src/movie/moviepage.dart';
import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            child: EventList(),
          ),
        ],
      ),
    );
  }
}
Column _buildButtonColumn(IconData icon, String label) {
//  Color color = Theme.of(context).primaryColor;
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.black12,
          foregroundColor: Colors.black,
          child: Icon(icon)),
      Container(
        margin: const EdgeInsets.only(top: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}

class EventList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EventListState();
}

class EventListState extends State<EventList> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: chart(size),
    );
  }

  Widget chart(size) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[Flexible(child: newsFeedBuild())],
      ),
    );
  }

  Widget newsFeedBuild() {
    return StreamBuilder(
      stream: db.collection('event').where('kind', isEqualTo: 'special').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.documents.length+1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Contents();
            }
            return cardBuild(snapshot.data.documents[index-1]);
          },
        );
      },
    );
  }

  Widget cardBuild(DocumentSnapshot document) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
//        color: Colors.blue
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5),
            width: size.width,
            height: size.height*0.3,
            decoration: BoxDecoration(
                border: Border(

                ),
            ),
            child: new Image.network(
              document['img'],
              fit: BoxFit.fill,
            ),
          ),

          Container(
            width: size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white30,
                  border: Border(
                    left: BorderSide(width: 2.0, color: Colors.black12),
                    right: BorderSide(width: 2.0, color: Colors.black12),
                  )
              ),
              padding: EdgeInsets.only(top: 5,left: 10),
              child: Text(
                document['title'].replaceAll("\\n", "\n"),
                textScaleFactor: 1.2,
                softWrap: false,
              )
          ),
          Container(
            height: 30,
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white30,
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: Colors.black12),
                    left: BorderSide(width: 2.0, color: Colors.black12),
                    right: BorderSide(width: 2.0, color: Colors.black12),
                  )
              ),
              padding: EdgeInsets.only(left: 10,bottom: 10),
              child: Text(
                document['date'],
                textScaleFactor: 0.9,
                softWrap: false,
              )
          ),

          Container(
            width: size.width,
            height: 9,
          )

        ],
      ),
    );
  }
}

class Contents extends StatefulWidget {
  @override
  _ContentsState createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TopEvent(),
        Container(
          height: 7,
          color: Colors.black12,
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: buttonSection,
        ),
        Container(
          height: 7,
          color: Colors.black12,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
            child: Image.network(
              'http://img.cgv.co.kr/Event/Event/2019/1120/CGV_1911_072_w.jpg',
              fit: BoxFit.fill,
            )
        ),
      ],
    );
  }
  Widget buttonSection = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(Icons.room_service, '클럽서비스'),
        _buildButtonColumn(Icons.credit_card, '할인정보'),
        _buildButtonColumn(Icons.check_box, '당첨확인'),
      ],
    ),
  );
}

class TopEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TopEventState();
}

class TopEventState extends State<TopEvent> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: chart(size),
    );
  }

  Widget chart(size) {
    return Container(
      height: size.height*0.25,
      child: Column(
        children: <Widget>[Flexible(
            child: StreamBuilder(
              stream: db.collection('event').where('kind', isEqualTo: 'top').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return cardBuild(snapshot.data.documents[index]);
                  },
                );
              },
            ))],
      ),
    );
  }


  Widget cardBuild(DocumentSnapshot document) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height*0.25,
            child: Image.network(
              document['img'],
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}



