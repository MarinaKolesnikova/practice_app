import 'package:flutter/material.dart';
import 'package:pract_app/pages/auxiliary/Functions/toastMessage.dart';
import 'package:pract_app/pages/catalog/ProductList/gridViewForProductList.dart';
import 'package:pract_app/services/Models/Api_product.dart';
import 'package:pract_app/services/Provider/database_provider.dart';

class ProductListWithoutConnection extends StatefulWidget{
  final bool isAuth ;

  @override
  final String title = "product list";
  const ProductListWithoutConnection({ Key? key, required this.isAuth}):super(key: key);
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductListWithoutConnection> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    void callBack(){
      setState(() {
      });
    }
    bool _isAuth = widget.isAuth;

    Size size = MediaQuery.of(context).size;
    return  FutureBuilder(
        future:DatabaseProvider.db.getProducts(),
        builder:(BuildContext context, AsyncSnapshot<List<ApiProduct>> snapshot) {
          if(snapshot.hasData){
            List<ApiProduct>? apPr=snapshot.data;
            return
              Container (
                width: size.width,
                child:
                GridViewPL(
                content: apPr,
                isAuth: _isAuth,
                connection:false,
                callback: callBack
                ),
              );
          }
          else{
            returnToast("No internet connection!","CENTER");
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }}
