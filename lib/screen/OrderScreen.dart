import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirstproject/Providers/OrderProvider.dart';
import 'package:myfirstproject/items/MainTabPageDrawer.dart';
import 'package:myfirstproject/items/OrderListItems.dart';
import 'package:myfirstproject/items/SharedErrorBox.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const route = './orderScreen';

  @override
  Widget build(BuildContext context) {
    var order_provider = Provider.of<OrderProvider>(context, listen: false);

    Future<void> futureFunction() async{
      try{
        await Provider.of<OrderProvider>(context, listen: false)
            .getAndFetchOrders();
      }catch(error){
        await SharedErrorBox.ShowError(context, "Could not fetch orers. Please try after sometime.",false);
      }
    }

    // TODO: implement build
    return Scaffold(
        drawer: MainTabPageDrawer(),
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        body: FutureBuilder(
          future:futureFunction(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Text(dataSnapshot.error.toString());
                //SharedErrorBox.ShowError(context,dataSnapshot.err.toString());
              } else {
                return ListView(
                  children: <Widget>[
                    ...order_provider.geOrderItems
                        .map((order) => OrderListItems(order))
                        .toList()
                  ],
                );
              }
            }
          },
        ));
  }
}
