import 'package:dbapp/src/home.dart';
import 'package:dbapp/src/menubar.dart';
import 'package:flutter/material.dart';

import 'src/store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
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
      Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
    ];
    final _kTabs = <Tab>[
      Tab(icon: Icon(Icons.cloud), text: 'Home'),
      Tab(icon: Icon(Icons.alarm), text: 'Event'),
      Tab(icon: Icon(Icons.forum), text: 'Store'),
      Tab(icon: Icon(Icons.forum), text: 'Play'),
      Tab(icon: Icon(Icons.forum), text: 'My'),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        endDrawer: MenuBar(),
        appBar: AppBar(
          title: Text('GVA'),
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
