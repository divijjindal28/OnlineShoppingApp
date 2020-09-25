import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirstproject/Providers/ProductProvider.dart';
import 'package:myfirstproject/items/SharedErrorBox.dart';
import 'package:provider/provider.dart';


class AddNEditProductScreen extends StatefulWidget{
  static const route = './addNeditProductScreen';

  @override
  _AddNEditProductScreenState createState() => _AddNEditProductScreenState();
}

class _AddNEditProductScreenState extends State<AddNEditProductScreen> {

  bool _isLoading = false;
  var _init = false;
  final _name_focus=FocusNode();
  final _price_focus=FocusNode();
  final _description_focus=FocusNode();
  final _image_focus=FocusNode();
  final _textFieldController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var  _product = Product(id: null, title: '', price: 0, imageUrl: ' ', description: '');


  @override
  void initState() {
    _image_focus.addListener(urlControllerListener);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _name_focus.dispose();
    _price_focus.dispose();
    _image_focus.removeListener(urlControllerListener);
    _image_focus.dispose();
    _description_focus.dispose();
    _textFieldController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if(!_init){
      final productId = ModalRoute
          .of(context)
          .settings
          .arguments;
      if(productId != null) {
        _product = Provider.of<ProductProvider>(context,listen: false).getProduct(productId);
        _textFieldController.text = _product.imageUrl;
        print("data check_001 ${_product.title}  and ${_product.id}");
      }
    }
    _init = true;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  void urlControllerListener(){
    if(!_image_focus.hasFocus){
      if((_textFieldController.text.isEmpty) && ((_textFieldController.text.startsWith('http'))||(_textFieldController.text.startsWith('https')))){
        return;

      }
    }
    setState(() {

    });

  }

  Future<void> ShowError(BuildContext context,String error)
  {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Something went wrong!'),
          content: Text("Please try again after sometime"),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed:() => Navigator.of(ctx).pop(),
            )
          ],
        )
    );
  }

  Future<void> _onSvaed() async{



    if(_form.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      _form.currentState.save();
      try {
        if (_product.id == null) {
            await Provider.of<ProductProvider>(context, listen: false)
                .addProduct(
                DateTime.now().toString(), _product.title, _product.imageUrl,
                _product.price, _product.description);

        } else {
            await Provider.of<ProductProvider>(context, listen: false)
                .updateProduct(
                _product.id, _product);

        }
      }catch(error){await SharedErrorBox.ShowError(context, "",true);}
      setState(() {
        _isLoading=false;
      });

      Navigator.of(context).pop();
  }}

  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return Scaffold(

      appBar: AppBar(

        title: Text('Add / Edit Product'),

      ),
      body: _isLoading? Center(child: CircularProgressIndicator(),) :  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,

          child: ListView(
            children: <Widget>[
              Center(
                child: Container(

                  width: 150,
                  height: 150,
                  child:

                      _textFieldController.text.isEmpty ? Card(child: Center(child: Text('Enter Image Url'),),): FittedBox(child: Image.network(_textFieldController.text,fit: BoxFit.cover,))


                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                child: TextFormField(

                  focusNode: _image_focus,
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    labelText: 'Url of Product',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(_name_focus);

                  },
                  validator: (value){
                    if(!value.startsWith('https')){
                      return "Please enter valid url";
                    }else if(value.isEmpty){
                      return "Please enter url";
                    }
                    return null;

                  },
                  onSaved: (value){
                    _product = Product(id: _product.id, title: _product.title, price:_product.price, imageUrl: value, description: _product.description);

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: _product.title,
                  decoration: InputDecoration(
                    labelText: 'Name of Product',
                  ),
                  focusNode: _name_focus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(_price_focus);
                    print('shoukd work');

                  },

                  validator: (value){
                    if(value.isEmpty){
                      return "Please enter the name of product";
                    }
                    return null;

                  },
                  onSaved: (value){
                    _product = Product(id: _product.id, title: value, price:_product.price, imageUrl: _product.imageUrl, description: _product.description);

                  },
                ),
              ),
              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: _product.price.toString(),
                  decoration: InputDecoration(
                      labelText: 'Price of Product',
                  ),
                  focusNode: _price_focus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (_){
                    _price_focus.unfocus();
                    FocusScope.of(context).requestFocus(_description_focus);

                  },
                  onSaved: (value){
                    _product = Product(id: _product.id, title: _product.title, price:double.parse(value), imageUrl: _product.imageUrl, description: _product.description);

                  },
                  validator: (value){
                    if(double.parse(value)  <= 0){
                      return "Please enter the correct price of product";
                    }
                    return null;

                  },
                ),
              ),
              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  maxLines: 3,
                  initialValue: _product.description,
                  decoration: InputDecoration(
                      labelText: 'Description of Product',
                  ),
                  focusNode: _description_focus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (_){

                  },
                  onSaved: (value){
                    _product = Product(id: _product.id, title: _product.title, price:_product.price, imageUrl: _product.imageUrl, description: value);

                  },
                  validator: (value){
                    if(value.isEmpty){
                      return "Please enter the description of product";
                    }else if (value.length < 10)
                      {
                        return "Please enter more derscription";
                      }
                    return null;

                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(

                    child: Text('Submit',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15),),

                    onPressed: (){
                      _onSvaed();
                    },
                  ),
                ),
              )

            ],
          ),
        ),
      )

    );
  }
}