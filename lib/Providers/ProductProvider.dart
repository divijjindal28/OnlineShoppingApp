

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:myfirstproject/HtttpException.dart';


class Product with ChangeNotifier{
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  bool isFav;

  Product({
    @ required this.id,
    @ required this.title,
    @ required this.price,
    @ required this.imageUrl,
    @ required this.description,
    this.isFav = false
});

  Future<void> toggleFav(String prodId,String userId,String token) async{


    try {

      String url = "https://betaproject-a9875.firebaseio.com/favorites/${userId}/${id}.json?auth=$token";
      final response = await http.put(url, body: json.encode(!isFav));
      if (response.statusCode >= 400) {

        throw HttpException('Error Occured');

      }
      isFav = !isFav;
      notifyListeners();

    }catch(error){throw error;}
  }
}


class ProductProvider with ChangeNotifier{

  List<Product> _product_item=[] ;
  String _token;
  String _userId;
  ProductProvider(this._product_item,this._token,this._userId);

  List<Product> get getProductItems{
    return [..._product_item];
  }

  List<Product> get getFavProductItems{
    return _product_item.where((prod) => prod.isFav == true).toList();
  }

   Product getProduct(String id){
    return _product_item.firstWhere((prod) => prod.id == id);
  }


  
  Future<void> addProduct (String id, String item,String imageurl,double price,String description)async{
    try {
      String url = "https://betaproject-a9875.firebaseio.com/product.json?auth=$_token";
      final response = await http.post(url, body: json.encode({
        'userId':_userId,
        'name': item,
        'price': price.toString(),
        'imageUrl': imageurl,
        'description': description,
      }));
      _product_item.insert(0, Product(id: json.decode(response.body)['name'],
          title: item,
          price: price,
          imageUrl: imageurl,
          description: description));
      notifyListeners();
    }catch(error){
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async{


    int index = _product_item.indexWhere((prod) => prod.id == id);
    if(index >=0) {
      try {
        String url = "https://betaproject-a9875.firebaseio.com/product/${product.id}.json?auth=$_token";
        final response = await http.patch(url, body: json.encode({

          'name': product.title,
          'price': product.price.toString(),
          'imageUrl': product.imageUrl,
          'description': product.description
        }));
        if (response.statusCode >= 400) {
          throw HttpException('Error Occured');
        }else {
          _product_item[index] = product;
          notifyListeners();
        }
      }catch(error){
        throw error;
      }
    }

  }


  Future<void> removeProduct(String id) async{
    try{
      String url = "https://betaproject-a9875.firebaseio.com/product/${id}.json?auth=$_token";
      final response = await http.delete(url);
      if(response.statusCode >= 400){
        throw HttpException("error Occured");
      }else{
        _product_item.removeWhere((prod) => prod.id == id);
        notifyListeners();
      }
    }catch(error){
      throw error;
    }

  }

  Future<void> fetchAndSetProducts({default_mode= false}) async{
    try{
      _product_item = [];
      String added_url = '&orderBy="userId"&equalTo="$_userId"';
      String url = "https://betaproject-a9875.firebaseio.com/product.json?auth=$_token${default_mode ? added_url : ''}";
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      if(extractedData['error']!=null){
        throw HttpException(extractedData['error']['messege']);
      }
      if(extractedData !=  null) {
        print('extractedData 1  '+extractedData.toString());
        String url2 = "https://betaproject-a9875.firebaseio.com/favorites/${_userId}.json?auth=$_token";
        final response2 = await http.get(url2);
        print('response  '+response2.toString());
        final extractedFavData = json.decode(response2.body);
        print('abc2');
        if(extractedFavData !=null){
        if(extractedFavData['error']!=null){
          print('abc3');

          throw HttpException(extractedFavData['error']['messege']);
        }}
        print('abc4');
          extractedData.forEach((key, value) {
            _product_item.insert(0, Product(
                id: key,
                title: value['name'],
                price: double.parse(value['price']),
                imageUrl: value['imageUrl'],
                description: value['description'],
                isFav:extractedFavData==null?false: extractedFavData[key] == null
                    ? false
                    : extractedFavData[key]

            ));
          });

          notifyListeners();

      }
    }catch(error){
      print("xerror  ::  " + error.toString());

      throw error;
    }
  }
}