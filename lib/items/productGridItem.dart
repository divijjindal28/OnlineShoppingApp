import 'package:myfirstproject/HtttpException.dart';
import 'package:myfirstproject/Providers/AuthProvider.dart';
import 'package:myfirstproject/Providers/CartProvider.dart';
import 'package:myfirstproject/Providers/ProductProvider.dart';
import 'package:myfirstproject/items/SharedErrorBox.dart';
import 'package:myfirstproject/screen/ProductPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class productGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _product=Provider.of<Product>(context,listen: false);
    var  _cart_provider=Provider.of<CartProvider>(context,listen: false);

    // TODO: implement build
    return Card(
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          Navigator.of(context).pushNamed(ProductPage.route,arguments: _product);
        },
        splashColor: Colors.grey,
        child: Column(


           children: <Widget>[
             LayoutBuilder(
               builder: (ctx,constraints)=>Container(
                 height: constraints.maxWidth/1.2,
                 child: Hero(
                   tag: _product.id,
                   child: FadeInImage(
                     placeholder: AssetImage('assets/images/tshirt.png'),
                     image: NetworkImage(
                     _product.imageUrl,

                   ),
                     fit: BoxFit.cover,
                   ),
                 ),
               ),
             ),
             GridTileBar(
               backgroundColor: Colors.white70,
               leading:favoriteButton(_product.id),
               title: Text(
                 _product.title,
                 style:Theme.of(context).textTheme.title,
               ),
               subtitle: Text(_product.price.toString(),style:Theme.of(context).textTheme.subtitle,),
               trailing: IconButton(
                 icon:const Icon(
                   Icons.shopping_cart,
                   color: Colors.grey,
                 ),
                 onPressed: (){
                   _cart_provider.addToCart(_product.id, _product.title, _product.price);
                   Scaffold.of(context).hideCurrentSnackBar();
                   Scaffold.of(context).showSnackBar(SnackBar(content:const Text('Product added to cart.'),duration:const Duration(seconds: 1),backgroundColor: Theme.of(context).primaryColor,
                     action: SnackBarAction(
                       label: 'UNDO',
                       textColor: Theme.of(context).textTheme.button.color,
                       onPressed: (){
                         _cart_provider.removeFromCart(_product.id);
                       },
                     ),));
                 },
               ),
             ),
           ],
        ),
      ),
    );
  }
}

class favoriteButton extends StatefulWidget{
  final String _productId;
  favoriteButton(this._productId);
  var _isLoading = false;
  @override
  _favoriteButtonState createState() => _favoriteButtonState();
}

class _favoriteButtonState extends State<favoriteButton> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context);
    // TODO: implement build
    return Consumer<Product>(
      builder: (ctx,_cons_product,_) => widget._isLoading ? Center(child: CircularProgressIndicator(),
      ) : IconButton(icon:_cons_product.isFav
          ? Icon(
        Icons.favorite,
        color: Colors.red,
      )
          : Icon(
        Icons.favorite_border,
        color: Colors.red,
      ) ,
        onPressed: ()async{

        setState(() {
          widget._isLoading=true;
        });
          try {
            print("hi");


            print("user"+auth.user);
            await _cons_product.toggleFav(widget._productId,auth.user,auth.token);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Favorites updated"),
              duration: Duration(seconds: 2),

            ));
          }on HttpException catch(er){
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Could not add to favorites!"),
              duration: Duration(seconds: 2),

            ));
          }catch(error){
            await SharedErrorBox.ShowError(context, "Could not add to favorites! Please try after sometime .",false);
          }
        setState(() {
          widget._isLoading=false;
        });
        },

      ),
    ) ;
  }
}
