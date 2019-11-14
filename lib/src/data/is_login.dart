import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int _counter=0;


  getCounter() => _counter;

  void increment() {
    _counter=1;
    notifyListeners();
  }

  void decrement() {
    _counter=0;
    notifyListeners();
  }
}