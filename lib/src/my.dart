import 'package:flutter/material.dart';


class My extends StatefulWidget {
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          child: Text('Item1: flex=1'),
          color: Colors.red,
          height: 300,
        ),
        Container(
          child: Text('Item1: flex=1'),
          color: Colors.red,
          height: 300,
        ),
        Container(
          child: Text('Item1: flex=1'),
          color: Colors.red,
          height: 300,
        )
      ],
    );
  }
}
