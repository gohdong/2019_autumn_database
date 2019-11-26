
import 'package:flutter/material.dart';
import 'data/sign_in.dart';

class Purchase extends StatefulWidget {
  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
              Flexible(
                child: ListView(
                  children: <Widget>[
                    myInfo(),
                    myLog(),
                  ],
                ),
              ),
            ],
      ),
    );
  }
  Widget myInfo(){
    return Expanded(
      child: Container(
        color: Colors.black38,
        child: Column(
          children: <Widget>[
            Image.network('$imageUrl'),
            Text('$name'),
            Text('$email')


          ],
        ),
      ),
    );

  }
  Widget myLog(){

  }
}
