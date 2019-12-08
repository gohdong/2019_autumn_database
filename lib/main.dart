import 'package:dbapp/src/data/is_login.dart';
import 'package:dbapp/src/data/sign_in.dart';
import 'package:dbapp/src/home/event.dart';
import 'package:dbapp/src/home/home.dart';
import 'package:dbapp/src/mypage/makeMovieTicket.dart';
import 'package:dbapp/src/home/menubar.dart';
import 'package:dbapp/src/mypage/my.dart';
import 'package:dbapp/src/store/snackBox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    print("initstate");
//    final counter = Provider.of<Counter>(context);
    super.initState();
    getUser().then((user) {
      print("1");

      if (user.displayName != null) {
        print("2");

        print(user);
        email = user.email;
        name = user.displayName;
        imageUrl = user.photoUrl;
      } else {
        print("3");

        email = null;
        name = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return ChangeNotifierProvider(
      builder: (_) => Counter(),
      child: MaterialApp(
        title: 'GVA_app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: Tabs(),
      ),
    );
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }
}

class Tabs extends StatefulWidget {
  const Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Center(child: Home()),
      Center(child: Event()),
      Center(child: SnackBox()),
      Center(child: My()),
    ];
    final _kTabs = <Tab>[
      Tab(text: 'Home'),
      Tab(text: 'Event'),
      Tab(text: 'Snack'),
      Tab(text: 'My'),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        endDrawer: MenuBar(),
        appBar: AppBar(
          title: FlatButton(
            padding: EdgeInsets.all(0),
            child: Image.asset(
              'img/gva_logo1.png',
              height: 30,
            ),
            onPressed: () {
              launch("https://github.com/gohdong/2019_autumn_database");
            },
          ),
//          title: email==null?Text("NNN"):Text(email),

          centerTitle: true,
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
