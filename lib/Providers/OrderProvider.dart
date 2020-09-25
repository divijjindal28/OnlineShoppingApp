

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:myfirstproject/Providers/CartProvider.dart';
import 'package:http/http.dart' as http;



class Order {
  final String id;
  final DateTime dateTime;
  final List<Cart> cart_items;
  final double total_price;


  Order({
    @ required this.id,
    @required this.dateTime,
    @ required this.cart_items,
    @ required this.total_price,
  });


}


class OrderProvider with ChangeNotifier{
  List<Order> _order_item=[] ;
  String _token;
  String _userId;
  OrderProvider(this._order_item,this._token,this._userId);

  List<Order> get geOrderItems{
    return [..._order_item];
  }

  Future<void> getAndFetchOrders()async {
    try{
      _order_item=[];
    String url = "https://betaproject-a9875.firebaseio.com/order/$_userId.json?auth=$_token";
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((key, value) =>
        _order_item.insert(0, Order(
            id: json.decode(response.body)['name'],
            dateTime:DateTime.parse(value['dateTime']),
            cart_items: [...value['cartItems'].map((cart) =>
                Cart(id: cart['id'],
                    title: cart['title'],
                    price:double.parse(cart['price']),
                    quantity: cart['quantity'])
            )],
            total_price:double.parse(value['totalPrice']))
        )
    );
    notifyListeners();
  }catch(error){
    throw error;
  }
  }

  Future<void> addToOrder(List<Cart> cart_items, double totalPrice) async{

    try {
      String url = "https://betaproject-a9875.firebaseio.com/order/$_userId.json?auth=$_token";
      final response = await http.post(url, body: json.encode({
        'dateTime': DateTime.now().toIso8601String(),
        'totalPrice': totalPrice.toStringAsFixed(2),
        'cartItems': cart_items.map((cart) =>
        {
          'id': cart.id,
          'title': cart.title,
          'quantity': cart.quantity,
          'price': cart.price.toString()
        }).toList()
      }));


      _order_item.insert(0, Order(id: json.decode(response.body)['name'],
          dateTime: DateTime.now(),
          cart_items: cart_items,
          total_price: totalPrice));

      notifyListeners();
    }catch(error){throw error;}

  }

  void removeFromOrder(String id){
    _order_item.removeWhere((order) => order.id == id);

    notifyListeners();
  }




}