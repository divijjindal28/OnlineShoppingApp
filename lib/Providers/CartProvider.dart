

import 'package:flutter/cupertino.dart';


class Cart {
  final String id;
  final String title;
  final double price;
  final int quantity;


  Cart({
    @ required this.id,
    @ required this.title,
    @ required this.price,
    @required this.quantity
  });


}


class CartProvider with ChangeNotifier{
  Map<String,Cart> _product_item={} ;

  Map<String,Cart> get getProductItems{
    return {..._product_item};
  }

  void addToCart(String id,String title, double totalPrice){

    if(_product_item.containsKey(id)){
      _product_item.update(id, (existingItem) => Cart(id: existingItem.id,title: existingItem.title, quantity: existingItem.quantity+1,price: existingItem.price));
    }else{
      _product_item.putIfAbsent(id,() => Cart(id: DateTime.now().toIso8601String(), title: title,quantity: 1, price: totalPrice));
    }

    notifyListeners();
  }

  void removeFromCart(String id){
    if(_product_item[id].quantity == 1)
      {
        _product_item.remove(id);
      }
    else{
      _product_item.update(id, (existingItem) => Cart(id: existingItem.id,title: existingItem.title, quantity: existingItem.quantity - 1,price: existingItem.price));
    }

    notifyListeners();
  }

  void remove(String id){

      _product_item.remove(id);
      notifyListeners();


  }

  double totalCost(){
    double total=0;
    _product_item.values.forEach((prod) => total+=(prod.quantity * prod.price));
    return total;
  }

  int getNumberOfProducts(){
    return _product_item.length;
  }

  void clear(){
    _product_item ={};
    notifyListeners();
  }
}