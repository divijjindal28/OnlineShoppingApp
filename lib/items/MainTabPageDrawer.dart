import 'package:flutter/material.dart';
import 'package:myfirstproject/Providers/AuthProvider.dart';
import 'package:myfirstproject/items/SharedErrorBox.dart';
import 'package:myfirstproject/main.dart';
import 'package:myfirstproject/screen/AuthScreen.dart';
import 'package:myfirstproject/screen/MainTabPage.dart';
import 'package:myfirstproject/screen/ManageOrderScreen.dart';
import 'package:myfirstproject/screen/OrderScreen.dart';
import 'package:provider/provider.dart';


class MainTabPageDrawer extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {



    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title:const Text('Hi there !'),
          ),
          buildListTile(Icons.home,"Home",context,MainTabPage.route),
          buildListTile(Icons.payment,"Order",context,OrderScreen.route),
          buildListTile(Icons.edit,"Manage Products",context,ManageOrderScreen.route),
      Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.arrow_forward),
            title:  Text("LogOut"),
            onTap: ()async{
              Navigator.of(context).pop();
              try {
                 await Provider.of<AuthProvider>(context, listen: false).logOut();
              }catch(error){
                 SharedErrorBox.ShowError(context, "Could not Log out. Try after sometime",true);
              }
              Navigator.of(context).pushReplacementNamed(MyApp.route);
            },
          ),

          Divider()
        ],
      )
        ],
      ),
    );

  }

  Widget buildListTile(IconData icon,String name,BuildContext ctx, String routeName) {
    return Column(
      children: <Widget>[
        ListTile(
              leading: Icon(icon),
              title:  Text(name),
          onTap: (){
                Navigator.of(ctx).pushReplacementNamed(routeName);
          },
            ),

        Divider()
      ],
    );
  }
}
