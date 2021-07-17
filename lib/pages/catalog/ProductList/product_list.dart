import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:pract_app/pages/catalog/Functions/get_products.dart';
import 'package:pract_app/pages/auxiliary/Functions/toast_message.dart';
import 'package:pract_app/pages/catalog/ProductList/grid_view_for_product_list.dart';
import 'package:pract_app/pages/catalog/ProductList/product_list_without_connection.dart';
import 'package:pract_app/services/Models/api_product.dart';

class ProductList extends StatefulWidget{
  final bool isAuth ;

  @override
  final String title = "product list";
  final Function() newCatalogState;
  const ProductList({ Key? key, required this.isAuth, required this.newCatalogState}):super(key: key);
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late List<ProductList> products;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

  bool _isAuth = widget.isAuth;
    List products;
    Size size = MediaQuery.of(context).size;
    return  Column(
        children: <Widget>[
          Container(
            width: size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10),
            color:Colors.black.withOpacity(0.9),
            child: Text(
            "CATALOG",
            style:TextStyle(fontFamily: 'Arial', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
            )),
          Expanded(child:
            FutureBuilder(
            future:Connectivity().checkConnectivity(),
            builder:(BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
            var connection =snapshot.data;
            if(connection!=ConnectivityResult.none){
              return
              FutureBuilder(
              future:GetProducts(),
              builder:(BuildContext context, AsyncSnapshot<List<ApiProduct>> snapshot) {
                if(snapshot.hasData){
                  List<ApiProduct>? apPr=snapshot.data;
                 return
                   Container (
                     width: size.width,
                            child:GridViewPL(
                                content: apPr,
                                isAuth: _isAuth,
                                connection:true,
                                newCatalogState: widget.newCatalogState
                            ),

                   );
                }
                else {
                  return Center(child: CircularProgressIndicator());}
                }
                );}
              else{                                                               //from saved data
                if(_isAuth){
                  return ProductListWithoutConnection(isAuth: _isAuth);
                }
                    else {
                      returnToast("No internet connection!","CENTER");
                      return Center(child: CircularProgressIndicator());}
                  }
                }
            else{
              returnToast("Loading...","CENTER");
              return Center(child: CircularProgressIndicator());}
      }
                      ),
          ),
        ]
      );
  }
}

