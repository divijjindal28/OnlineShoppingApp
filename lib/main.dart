import 'package:flutter/material.dart';
import 'package:myfirstproject/CustomPageTransitionBuilder.dart';
import 'package:myfirstproject/Providers/AuthProvider.dart';
import 'package:myfirstproject/Providers/CartProvider.dart';
import 'package:myfirstproject/Providers/OrderProvider.dart';
import 'package:myfirstproject/Providers/ProductProvider.dart';
import 'package:myfirstproject/screen/AddNEditProductScreen.dart';
import 'package:myfirstproject/screen/AuthScreen.dart';
import 'package:myfirstproject/screen/CartPage.dart';
import 'package:myfirstproject/screen/MainTabPage.dart';
import 'package:myfirstproject/screen/ManageOrderScreen.dart';
import 'package:myfirstproject/screen/OrderScreen.dart';
import 'package:myfirstproject/screen/ProductPage.dart';
import 'package:myfirstproject/screen/WaitingScreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const route='./';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          update: (ctx, auth, provider_product) => ProductProvider(
              provider_product == null ? [] : provider_product.getProductItems,auth.token,auth.user),
        ),
        ChangeNotifierProvider.value(value: CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          update: (ctx, auth, provider_order) => OrderProvider(
              provider_order == null ? [] : provider_order.geOrderItems,auth.token,auth.user),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MartBag',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            textTheme: ThemeData.light().textTheme.copyWith(
                  body1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                  body2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                  title: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  button: TextStyle(color: Colors.white, fontSize: 12),
                  subtitle: TextStyle(color: Colors.grey, fontSize: 12),
                ),
            pageTransitionsTheme: PageTransitionsTheme( builders: {
              TargetPlatform.android:CustomPageTransitionBuilder(),
              TargetPlatform.iOS:CustomPageTransitionBuilder()
            })
          ),
          home: auth.Auth ? MainTabPage() :FutureBuilder(
            future: auth.autoLogIn(),
            builder: (ctx,dataSnapshot){
              if(dataSnapshot.connectionState == ConnectionState.waiting)
                {
                  return WaitingScreen();
                }
                  return AuthScreen();


            },
          ),

          routes: {
            ProductPage.route: (_) => ProductPage(),
            CartPage.route: (_) => CartPage(),
            OrderScreen.route: (_) => OrderScreen(),
            MainTabPage.route: (_) => MainTabPage(),
            ManageOrderScreen.route: (_) => ManageOrderScreen(),
            AddNEditProductScreen.route: (_) => AddNEditProductScreen(),
            AuthScreen.route: (_) => AuthScreen(),
            MyApp.route: (_) => MyApp()
          },
        ),
      ),
    );
  }
}
