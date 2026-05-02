import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  void push(Widget widget) {
    Navigator.push(this, MaterialPageRoute(builder: (context) => widget));
  }

  void pushReplacement(Widget widget) {
    Navigator.pushReplacement(
        this, MaterialPageRoute(builder: (context) => widget));
  }

  void pop() {
    Navigator.pop(this);
  }
}
