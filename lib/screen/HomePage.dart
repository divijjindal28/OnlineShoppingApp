import 'package:flutter/material.dart';
import 'package:myfirstproject/items/GridViewItem.dart';

import 'package:myfirstproject/Providers/ProductProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    var _loaded_products = Provider.of<ProductProvider>(context).getProductItems;
    print(_loaded_products.length);

    return GridViewItem(_loaded_products);;
  }
}
