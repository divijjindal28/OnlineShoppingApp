import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirstproject/Providers/OrderProvider.dart';
import 'package:provider/provider.dart';

class OrderListItems extends StatefulWidget {
  static const route = './orderScreen';
  Order _order;
  OrderListItems(this._order);
  bool _isExpanded = false;
  @override
  _OrderListItemsState createState() => _OrderListItemsState();
}

class _OrderListItemsState extends State<OrderListItems> {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("\$${widget._order.total_price.toStringAsFixed(2)}"),
              subtitle: Text(DateFormat.MMMMEEEEd().format(DateTime.parse(widget._order.dateTime.toIso8601String()))),
              trailing:
                  IconButton(
                    icon:widget._isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
                    onPressed: (){
                      setState(() {
                        widget._isExpanded = !widget._isExpanded;
                      });
                    },
                  )

            ),

              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,

                height: widget._isExpanded ? min( double.parse(widget._order.cart_items.length.toString()) * 20.00 + 30.00 , 100.00):0,
                child: ListView(
                  children: <Widget>[
                    ...widget._order.cart_items.map((cart) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 3.0,),
                      child: ListTile(
                        leading: Text(cart.title),
                        trailing: Text("${cart.quantity} x \$${cart.price}"),
                      ),
                    )).toList()
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
