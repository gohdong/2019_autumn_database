import 'package:dbapp/src/home.dart';
import 'package:dbapp/src/menubar.dart';

import 'package:dbapp/src/reservation.dart';

import 'package:dbapp/src/my.dart';

import 'package:flutter/material.dart';

import 'dart:ui';

import 'src/store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GVA_app',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Tabs(),
    );
  }
}

class Tabs extends StatelessWidget {
  const Tabs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Center(child: Home()),
      Center(child: Icon(Icons.alarm, size: 64.0, color: Colors.cyan)),
      Center(child: Store()),
      Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
      Center(child: My()),
    ];
    final _kTabs = <Tab>[
      Tab(text: 'Home'),
      Tab(text: 'Event'),
      Tab(text: 'Store'),
      Tab(text: 'Play'),
      Tab(text: 'My'),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        endDrawer: MenuBar(),
        appBar: AppBar(
          title: Text('GVA'),
          elevation: 0,
          // If `TabController controller` is not provided, then a
          // DefaultTabController ancestor must be provided instead.
          // Another way is to use a self-defined controller, c.f. "Bottom tab
          // bar" example.
          bottom: TabBar(
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}
