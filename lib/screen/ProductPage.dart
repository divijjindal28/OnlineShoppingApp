import 'package:myfirstproject/Providers/ProductProvider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  static const route = './productPage';
  @override
  Widget build(BuildContext context) {
    Product _product = ModalRoute.of(context).settings.arguments as Product;
    // TODO: implement build
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: FittedBox(

                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.black54),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_product.title),
                    )),
              ),
              background: Container(
                width: double.infinity,
                height: 300,
                child: Hero(
                    tag: _product.id,
                    child: Image.network(
                      _product.imageUrl,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Center(child:Text(_product.title,style:Theme.of(context).textTheme.title,)),
//                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  "\$${_product.price.toString()}",
                  style: Theme.of(context).textTheme.subtitle,
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _product.description,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              SizedBox(
                height: 800,
              )
            ]),
          )
        ],
      ),
    );
  }
}
