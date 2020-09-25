import 'package:flutter/material.dart';
import 'package:myfirstproject/Providers/CartProvider.dart';
import 'package:myfirstproject/Providers/OrderProvider.dart';
import 'package:myfirstproject/items/CartListItem.dart';
import 'package:myfirstproject/items/SharedErrorBox.dart';

import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {


  static const route = './cartPage';
  @override
  Widget build(BuildContext context) {
    var _cart_provider = Provider.of<CartProvider>(context);

    
    print("page got buid");

    return Scaffold(

        appBar: AppBar(

          title:const Text( 'Your Cart'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: <Widget>[
                    const Text('Total'),
                     Chip(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(8.0),
                        label: Text(_cart_provider.totalCost().toStringAsFixed(2),style: Theme.of(context).textTheme.button,),
                      ),

                   orderButton(_cart_provider)
                  ],

                ),
              ),

//CartListItem(_cart_provider.getProductItems.keys.toList()[index])

            ),
            Expanded(
              child: ListView(
               children: <Widget>[
                 ..._cart_provider.getProductItems.keys.toList().map(((key) =>
                     CartListItem(key)
                 )).toList()
               ],
              ),
            )
          ],
        )
    );

  }

}


class orderButton extends StatefulWidget{
  final CartProvider _cart_provider;
  orderButton(this._cart_provider);
  bool _isLoading = false;
  @override
  _orderButtonState createState() => _orderButtonState();
}

class _orderButtonState extends State<orderButton> {
  @override
  Widget build(BuildContext context) {
    final _order_provider = Provider.of<OrderProvider>(context,listen: false);

    // TODO: implement build
    return widget._isLoading ? Center(child: CircularProgressIndicator(),): FlatButton(
      child: Text('ORDER',style: TextStyle(color: Theme.of(context).primaryColor)),
      onPressed: ()async{
        setState(() {
          widget._isLoading = true;
        });
        try {

          await _order_provider.addToOrder(widget._cart_provider
              .getProductItems.values.toList(),
              widget._cart_provider.totalCost());


        }catch(error){await SharedErrorBox.ShowError(context,"Could not add to order. Please try after sometime.",false);}
        widget._cart_provider.clear();
        setState(() {
          widget._isLoading = false;
        });

      },
    );;
  }
}