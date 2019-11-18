import 'package:dbapp/main.dart';
import 'package:dbapp/src/login.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/src/reservation.dart';

class MenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: ListTile(
              title: Text('Login',textScaleFactor: 1.3,),
              onTap: (){
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Login()));
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
            title: Text('reservation',textScaleFactor: 1.5,),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Reservation()));
            },
          ),
        ],
      ),
    );
  }
}
