import 'package:flutter/material.dart';
import 'package:myfirstproject/Providers/CartProvider.dart';
import 'package:myfirstproject/items/Badge.dart';
import 'package:myfirstproject/items/MainTabPageDrawer.dart';
import 'package:myfirstproject/items/SharedErrorBox.dart';
import 'package:myfirstproject/items/productGridItem.dart';

import 'package:myfirstproject/Providers/ProductProvider.dart';
import 'package:myfirstproject/screen/CartPage.dart';
import 'package:myfirstproject/screen/FavoritePage.dart';
import 'package:myfirstproject/screen/HomePage.dart';
import 'package:provider/provider.dart';

class MainTabPage extends StatefulWidget {
  static const route = './';
  // This widget is the root of your application.
  @override
  _MainTabPageState createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _selectedIndex=0;
  bool _init = false;
  bool _isLoading = false;

  List<Map<String,Object>> _pages;

  @override
  Future<void> didChangeDependencies() async{
    if(!_init){
      setState(() {
        _isLoading =  true;
      });
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .fetchAndSetProducts();

      }catch(error){
        print("xerror  ::  " + error.toString());

        await SharedErrorBox.ShowError(context, error.toString(),false);
      }
      setState(() {
        _isLoading =  false;
      });
      _init = true;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    _pages = [{
      'page': HomePage(), 'title': 'Home'
    },{
      'page': FavoritePage(), 'title': 'Favs'
    }];


    final Widget _widget =IconButton(icon :const Icon(Icons.shopping_cart),
      onPressed: (){
        Navigator.of(context).pushNamed(CartPage.route);
      },

    );


    return Scaffold(
      drawer: MainTabPageDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.purple,
        items: [
          BottomNavigationBarItem(
            icon:const Icon(Icons.home),
            title: Text(_pages[0]['title'])

          ),
          BottomNavigationBarItem(
            icon:const Icon(Icons.favorite_border),
              title: Text(_pages[1]['title'])
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (value){
          setState(() {
            _selectedIndex=value;
          });

        },
      ),
      appBar: AppBar(
        actions: <Widget>[

           Badge(
                _widget,
              Provider.of<CartProvider>(context).getNumberOfProducts()
            ),


        ],
        title:const Text( 'MartBag'),
      ),
      body:_isLoading ? Center(child: CircularProgressIndicator(),) : _pages[_selectedIndex]['page']);

  }
}
