import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirstproject/Providers/OrderProvider.dart';
import 'package:myfirstproject/Providers/ProductProvider.dart';
import 'package:myfirstproject/items/MainTabPageDrawer.dart';
import 'package:myfirstproject/items/ManageProductListItems.dart';
import 'package:myfirstproject/items/OrderListItems.dart';
import 'package:myfirstproject/items/SharedErrorBox.dart';
import 'package:myfirstproject/screen/AddNEditProductScreen.dart';
import 'package:provider/provider.dart';


class ManageOrderScreen extends StatefulWidget{
  static const route = './ManageOrderScreen';

  @override
  _ManageOrderScreenState createState() => _ManageOrderScreenState();
}

class _ManageOrderScreenState extends State<ManageOrderScreen> {

  var _isLoading = false;
  var _init = false;
  Future<void> refreshList()async{
    setState(() {
      _isLoading = true;
    });
    try{
      await Provider.of<ProductProvider>(context,listen: false).fetchAndSetProducts(default_mode: true);
    }catch(error){
      await SharedErrorBox.ShowError(context, "Could not fetch items. Please try after sometime.",false);
    }
    setState(() {
      _isLoading = false;
    });
  }
  
  @override
  void didChangeDependencies() async{
    if(!_init){
      refreshList();
    }
    _init = true;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
        drawer: MainTabPageDrawer(),
        appBar: AppBar(

          title:const Text('Manage Order'),
          actions: <Widget>[
            IconButton(icon:const Icon(Icons.add),onPressed: (){
              Navigator.of(context).pushNamed(AddNEditProductScreen.route);
            },)
          ],
        ),
        body:
         RefreshIndicator(
           onRefresh: refreshList,
           child:_isLoading? Center(child: CircularProgressIndicator(),): ListView(
              children: <Widget>[
                ...Provider.of<ProductProvider>(context).getProductItems.map((product) => ManageProductListItems(product)).toList()
              ],
            ),
         ),

    );
  }
}