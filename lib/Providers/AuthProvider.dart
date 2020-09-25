import 'dart:async';
import 'dart:convert';
import 'package:myfirstproject/HtttpException.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier{
  String _token;
  String _user;
  DateTime _expiryDate;
  Timer _authTimer;

  get token{
    if(_token != null && _user != null && _expiryDate != null){
      print("usse" + _user);
      return _token;
    }
  }

  get user{
    if(_token != null && _user != null && _expiryDate != null){
      return _user;
    }
  }

  bool get Auth{
    print("4 ${token != null}");
    return token != null;
  }

  Future<void> authenticateFunc(String url_sub,String email,String password) async{
    try {
      print("1");
      final url ="https://identitytoolkit.googleapis.com/v1/accounts:$url_sub?key=AIzaSyATKk1NkBcc0Dja5h-GYBtROZWwbW0r3E4";
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }));

      print("2");
      final extractedMessege = json.decode(response.body);
      if(extractedMessege == null){return;}
      if(extractedMessege['error'] != null){
        print("werfg"+extractedMessege['error']['messege']);
        throw HttpException(extractedMessege['error']['messege']);
      }
      _token = extractedMessege['idToken'];
      _user = extractedMessege['localId'];
      _expiryDate =DateTime.now().add(Duration(seconds:int.parse(extractedMessege['expiresIn'])));

      var prefs = await SharedPreferences.getInstance();
      prefs.setString('userData',json.encode( {
        'token':_token,
        'userId':_user,
        'expiryDate':_expiryDate.toIso8601String(),
      }));
      autoLogOut();
      notifyListeners();
    }catch(error){
      print("3");
      throw error;
    }
  }

  Future<void> signUp(String email,String password) async{
    String url = "signUp";
    try {
      await authenticateFunc(url, email, password);
    }catch(error){
      throw error;
    }
  }

  Future<void> logIn(String email,String password) async{
    print('liginbaby  ' + email + password);
    String url = "signInWithPassword";
    try {
      await authenticateFunc(url, email, password);
    }catch(error){
      throw error;
    }
  }

  Future<void> logOut()async {
      try{
        var prefs = await SharedPreferences.getInstance();
        prefs.remove('userData');

        if (_authTimer != null) {
          _authTimer.cancel();
          _authTimer = null;
        }

        _token = null;
        _user = null;
        _expiryDate = null;

        notifyListeners();
    }catch(error)
      {throw error;}
  }

  void autoLogOut(){
    if(_authTimer != null){
      _authTimer.cancel();
    }
    _authTimer = Timer(Duration(seconds: _expiryDate.difference(DateTime.now()).inSeconds),logOut);
    notifyListeners();
  }

  Future<void> autoLogIn()async{
    try {
      print('werfg');
      var prefs = await SharedPreferences.getInstance();

      if(!prefs.containsKey('userData')){return true;}
      print('werfg2');
      var data = json.decode(prefs.getString('userData')) as Map<String,dynamic>;
      if(data['expiryDate'] == null){
        return true;
      }
      if (data == null) {
        return true;
      }
      _token = data['token'];
      _user = data['userId'];
      _expiryDate =DateTime.parse(data['expiryDate']);
      autoLogOut();
      notifyListeners();
    }catch(error){print(error.toString());}
  }


}