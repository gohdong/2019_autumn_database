import 'package:dbapp/src/menubar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Text('Item1: flex=1'),
              color: Colors.red,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text('Item1: flex=1'),
              color: Colors.orange,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text('Item1: flex=1'),
              color: Colors.red,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text('Item1: flex=1'),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );;
  }
}
