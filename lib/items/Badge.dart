import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget{
  final Widget _widget;
  final int _number_of_items;
  Badge(this._widget,this._number_of_items);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            _widget,
            Positioned(
              top: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                radius: 10,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: FittedBox(
                    child: Text(_number_of_items.toString(),style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  }
