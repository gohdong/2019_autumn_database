import 'package:dbapp/main.dart';
import 'package:dbapp/src/data/is_login.dart';
import 'package:dbapp/src/login.dart';
import 'package:dbapp/src/reservation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'data/sign_in.dart';


class MenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: ListTile(
              leading: Icon(
                counter.getCounter()==0?
                Icons.account_circle:Icons.audiotrack, size: 50,),
              title: Text(
                counter.getCounter()==0?
                'Login':'$name님 환영합니다.',textScaleFactor: 1.3,),
              onTap: (){
                counter.getCounter()==0?
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login())
                ) : Text("dd");
              },
            ),
            decoration: BoxDecoration(
              color: Colors.black45,
            ),

          ),
          ListTile(
            title: Text('Home',textScaleFactor: 1.5,),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Notice',textScaleFactor: 1.5,),
            onTap: () {
            },
          ),
          ListTile(
            title: Text('reserve',textScaleFactor: 1.5,),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Reserve()));
            },
          ),
        ],
      ),
    );
  }
}
