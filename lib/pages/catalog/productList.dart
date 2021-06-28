import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:pract_app/pages/catalog/Functions/getProducts.dart';
import 'package:pract_app/pages/auxiliary/Functions/toastMessage.dart';
import 'package:pract_app/services/Api_product.dart';
import 'package:pract_app/services/database_provider.dart';
import 'productItems.dart';

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
                                      ),
                              ),
                          ),
                        );
                      }
                      else{
                      returnToast("No internet connection!","CENTER");
                        return Center(child: CircularProgressIndicator());
                      }
                   }
                   );
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

