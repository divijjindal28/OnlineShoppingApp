import 'package:flutter/material.dart';

class HttpException implements Exception {
   String msg;
  HttpException(this.msg);

  @override
  String toString() {
    // TODO: implement toString
    return msg;
  }


}