import 'package:flutter/material.dart';
import 'package:myfirstproject/items/productGridItem.dart';

import 'package:myfirstproject/Providers/ProductProvider.dart';
import 'package:provider/provider.dart';

class GridViewItem extends StatelessWidget {

  List<Product> _loaded_products = [];
  GridViewItem(this._loaded_products);
  @override
  Widget build(BuildContext context) {
    var _orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
        itemCount: _loaded_products.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2/2.5,
            crossAxisCount: (_orientation == Orientation.portrait) ? 2 : 4),

        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
            value: _loaded_products[index],
            child: productGridItem(),

          );
        });
  }
}
