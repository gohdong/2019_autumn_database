import 'package:dbapp/main.dart';
import 'package:dbapp/src/data/is_login.dart';
import 'package:dbapp/src/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
              title: Text(
                counter.getCounter()==0?
                'Login':'Mypage',textScaleFactor: 1.3,),
              onTap: (){
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Login())
                );
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
        ],
      ),
    );
  }
}
