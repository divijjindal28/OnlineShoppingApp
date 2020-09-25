import 'package:myfirstproject/Providers/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartListItem extends StatelessWidget {
  String _id;
  CartListItem(this._id);
  @override
  Widget build(BuildContext context) {
    var _cart_provider = Provider.of<CartProvider>(context);

    // TODO: implement build
    return LayoutBuilder(
      builder: (c, constraints) => Card(
        margin: const EdgeInsets.all(5),
        child: Dismissible(
          key: ValueKey(_id),
          background: Container(
            color: Theme.of(context).errorColor,
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),

            alignment: Alignment.centerRight,
            child:  const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 30,

                ),
              
          ),


          direction: DismissDirection.endToStart,
          // Provide a function that tells the app
          // what to do after an item has been swiped away.

          confirmDismiss: (direction){
            return showDialog(context: context,builder: (ctx) => AlertDialog(
              title: const Text('Delete Item'),
              content:  const Text('Do you want to delete item form the cart ?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Cancel'),
                  onPressed: (){
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: const Text('Okay'),
                  onPressed: (){
                    Navigator.of(ctx).pop();
                    _cart_provider.remove(_id);
                    Scaffold.of(context).showSnackBar(SnackBar(content:const Text('Product removed to cart.'),duration:const Duration(seconds: 1),backgroundColor: Theme.of(context).primaryColor,
                    ));


                  },
                )
              ],
            ));
          },

          onDismissed: (_){

          },



          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 25,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FittedBox(
                    child: Text(
                      '\$${_cart_provider.getProductItems[_id].price.toString()}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              title: Text(_cart_provider.getProductItems[_id].title),
              subtitle: Text(
                  "Total : \$${(_cart_provider.getProductItems[_id].price * _cart_provider.getProductItems[_id].quantity).toStringAsFixed(2)}"),
              trailing: Container(
                width: constraints.maxWidth * 0.35,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        _cart_provider.removeFromCart(_id);
                      },
                    ),
                    Text(_cart_provider.getProductItems[_id].quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _cart_provider.addToCart(
                            _id,
                            _cart_provider.getProductItems[_id].title,
                            _cart_provider.getProductItems[_id].price);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
