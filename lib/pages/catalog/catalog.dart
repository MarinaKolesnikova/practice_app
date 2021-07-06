import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_app/background/background.dart';
import 'package:pract_app/pages/auxiliary/Functions/hasTokenFunction.dart';
import 'package:pract_app/pages/auxiliary/Widgets/menuBar.dart';
import 'package:pract_app/pages/catalog/ProductList/productList.dart';
import 'package:pract_app/pages/auxiliary/Widgets/appBar.dart';

class Catalog extends StatefulWidget{
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<Catalog> {

  void newState(){
    if(mounted)
      setState(() {
      });}

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double back_pressed;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    return  FutureBuilder(
        future:isAuthorized(),
        builder:(BuildContext context, AsyncSnapshot<bool> snapshot)  {
        if(snapshot.hasData){
          print(snapshot.hasData);
          bool? isAuth=snapshot.data;
          return Scaffold(
            key:_scaffoldKey,
            appBar:
            AppBarWidget(
              isAuth:isAuth==true? true:false,
              callBack: newState,
              scaffoldKey: _scaffoldKey,
              backButton: false,
            ),

            endDrawer:Drawer(
              child: MenuBar(),
            ),
            body: Background (child: ProductList(isAuth: isAuth==true? true:false,)
            ),
          );
        }
        else{
          return Center(child:CircularProgressIndicator()); }
        });
  }
}
