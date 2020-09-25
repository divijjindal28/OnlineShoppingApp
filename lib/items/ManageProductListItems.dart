import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirstproject/Providers/OrderProvider.dart';
import 'package:myfirstproject/Providers/ProductProvider.dart';
import 'package:myfirstproject/items/MainTabPageDrawer.dart';
import 'package:myfirstproject/items/SharedErrorBox.dart';
import 'package:myfirstproject/screen/AddNEditProductScreen.dart';
import 'package:provider/provider.dart';

class ManageProductListItems extends StatelessWidget {
  Product _product;
  ManageProductListItems(this._product);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(

      builder:(_,constraints) => Column(

          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_product.imageUrl),
                radius: 25,
              ),
              title:Text(_product.title) ,
              trailing: Container(
                width: constraints.maxWidth * 0.3,
                child: Row(

                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit,color: Theme.of(context).primaryColor,),
                      onPressed: (){
                        Navigator.of(context).pushNamed(AddNEditProductScreen.route,arguments:  _product.id);
                      },
                    ),
                    IconButton(
                      icon:  Icon(Icons.delete,color: Theme.of(context).errorColor,),
                      onPressed: (){
                        showDialog(context: context,builder: (ctx) => AlertDialog(
                          title: const Text('Delete Item'),
                          content:  const Text('Do you want to delete item  ?'),
                          actions: <Widget>[
                            FlatButton(
                              child: const Text('Cancel'),
                              onPressed: (){
                                Navigator.of(ctx).pop();
                              },
                            ),
                            FlatButton(
                              child: const Text('Okay'),
                              onPressed: () async{
                                try {
                                  await Provider.of<ProductProvider>(
                                      context, listen: false).removeProduct(
                                      _product.id);
                                }catch(error){
                                  await SharedErrorBox.ShowError(context,"Could not remove item. Please try after sometime.",false);
                                }
                                Scaffold.of(context).showSnackBar(SnackBar(content:const Text('Product Removed'),duration:const Duration(seconds: 1),backgroundColor: Theme.of(context).primaryColor));
                                Navigator.of(ctx).pop();



                              },
                            )
                          ],
                        ));


                      },
                    )
                  ],
                ),
              ),

            ),
            Divider()
          ],
        ),

    );
  }
}
