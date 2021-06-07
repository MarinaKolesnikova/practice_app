import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pract_app/services/Api_product.dart';
import 'package:http/http.dart' as http;
import 'package:pract_app/services/database_provider.dart';
import 'productItems.dart';

Future<List <ApiProduct>> GetProducts() async{
  Future<List<ApiProduct>> products;
  final Uri apiUrl=Uri.parse("http://smktesting.herokuapp.com/api/products/");
  var response = await http.get(apiUrl);

  if(response.statusCode==200){
    final String data =response.body.toString();
    var prodObjsJson = jsonDecode(data) as List;
    var prodObjs = prodObjsJson.map((prodJson) => ApiProduct.fromJson(prodJson)).toList() ;
    return prodObjs;
  }
  else{
    return products= <ApiProduct>[] as Future<List<ApiProduct>>;
  }
}


class ProductList extends StatefulWidget{
  final bool isAuth ;
  @override
  final String title = "product list";
  const ProductList({ Key? key, required this.isAuth}):super(key: key);
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
  void callBack(){
    setState(() {
    });
  }
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
                          padding: EdgeInsets.only(top:20),
                          child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount:  apPr!.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.85,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                               ),
                              itemBuilder: (context, index) => productItem(
                                content: apPr[index],
                                isAut: _isAuth,
                                connection:true,
                                parentAction: callBack,
                                )
                            ))
                  );
                }
                else {
                  return Center(child: CircularProgressIndicator());}
                }
                );}
              else{                                                               //from saved data
                if(_isAuth){
                  return FutureBuilder(
                      future:DatabaseProvider.db.getProducts(),
                       builder:(BuildContext context, AsyncSnapshot<List<ApiProduct>> snapshot) {
                    if(snapshot.hasData){
                      List<ApiProduct>? apPr=snapshot.data;
                      return
                         Container (
                          width: size.width,
                          padding: EdgeInsets.only(top:20),

                          child:
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child:GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount:  apPr!.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.85,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                      itemBuilder: (context, index) => productItem(
                                          content: apPr[index],
                                          isAut: _isAuth,
                                          connection:false,
                                          parentAction: callBack
                                      )
                              )),
                        );
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: "No internet connection!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER);
                        return Center(child: CircularProgressIndicator());
                      }
                   }
                   );
                }
                    else {
                      Fluttertoast.showToast(
                      msg: "No internet connection!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER);
                      return Center(child: CircularProgressIndicator());}
                  }
                }
            else{
              Fluttertoast.showToast(
                  msg: "Loading...",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER);
              return Center(child: CircularProgressIndicator());}
      }

                      )
          )
        ]
      );
  }
}

