import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counter with ChangeNotifier {
  int _counter=0;


  getCounter() => _counter;

  void increment() async{
    _counter=1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', _counter);
    notifyListeners();
  }

  void decrement() async{
    _counter=0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', _counter);
    notifyListeners();
  }
}