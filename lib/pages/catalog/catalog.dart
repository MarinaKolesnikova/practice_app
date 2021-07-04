import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_app/background/background.dart';
import 'package:pract_app/pages/auxiliary/Functions/hasTokenFunction.dart';
import 'package:pract_app/pages/auxiliary/Widgets/menuBar.dart';
import 'package:pract_app/pages/catalog/ProductList/productList.dart';

class Catalog extends StatefulWidget{
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<Catalog> {
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
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.dark,
              centerTitle: true,
              automaticallyImplyLeading: isAuth==false?true:false,
              actions: isAuth==false?<Widget>[
                IconButton(onPressed: (){
                  setState(() {});
                  },
                    icon: Icon(Icons.refresh_rounded)
                ),]
                  :
              <Widget>[
                IconButton(onPressed: (){ //refresh data
                  setState(() {});
                  },
                    icon: Icon(Icons.refresh_rounded)),
                IconButton(icon: Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                ),
              ],
              leading:isAuth==false?IconButton(icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                if(Navigator.canPop(context)){
                  Navigator.pop(context);
                }
              }):Container(),
              backgroundColor: Colors.black.withOpacity(0.9),),
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
