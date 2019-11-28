import 'package:dbapp/main.dart';
import 'package:dbapp/src/data/is_login.dart';
import 'package:dbapp/src/data/make_seat.dart' as prefix0;
import 'package:dbapp/src/login.dart';
import 'package:dbapp/src/reservation.dart';
import 'package:dbapp/src/data/make_seat.dart';
import 'package:dbapp/src/test_movie_buy.dart';
import 'package:dbapp/src/success_pay.dart';
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login(counter: counter,))
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Tabs()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Notice2',textScaleFactor: 1.5,),
            onTap: () {
            },
          ),
          Divider(),
          ListTile(
            title: Text('Perchase',textScaleFactor: 1.5,),
            onTap: () {
//              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Success()));
//
            },
          ),
          Divider(),
          ListTile(
            title: Text('add',textScaleFactor: 1.5,),
            onTap: () {
//              Navigator.of(context).push(MaterialPageRoute(builder: (context) => prefix0.Make_seat()));
//
            },
          ),
          Divider(),
          ListTile(
            title: Text(counter.getCounter()==0? '':'LogOut',textScaleFactor: 1.5,),
            onTap: () {
              Navigator.of(context).pop();
              signOutGoogle();
              counter.decrement();
            },
          ),
        ],
      ),
    );
  }
}
