import 'dart:io';
import 'package:pract_app/pages/catalog/ProductItems/icon_button_for_product_list.dart';
import 'package:pract_app/services/Provider/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:pract_app/pages/detailPage/details.dart';
import 'package:pract_app/services/Models/api_product.dart';

class productItem extends StatefulWidget{
  @override
  final bool isAut;
  final ApiProduct content;
  final bool connection;
  final void Function() newCatalogState;
  const productItem(
      {Key? key, required this.content, required this.isAut, required this.connection, required this.newCatalogState}
      ):super(key: key);
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<productItem>{

  late bool isAut;
  late ApiProduct content;
  late bool connection;

  void itemRefresh(){
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  void initState() {
    isAut = widget.isAut;
    content= widget.content;
    connection = widget.connection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return
    FutureBuilder(
        future:DatabaseProvider.db.isExist(content.id),
        builder:(BuildContext context, AsyncSnapshot<ApiProduct> snapshot) {
          if(snapshot.hasData){
            ApiProduct? savedProduct=snapshot.data;
            bool fromSavedData=false;
              if(savedProduct!.id==0){
              fromSavedData = false;}
            else {fromSavedData = true;}
            return GestureDetector(
                onTap:(){ Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Details(
                      content:content,
                      isAuth: isAut==true?true: false,
                      refresh:  widget.newCatalogState,
                    )),
                );
                },
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                         child:
                         Container(
                             padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.7),
                                    blurRadius: 8.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0, 0)
                                ),
                              ],
                            ),
                           child:Stack(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 9),
                                    child: Align(
                                        alignment:Alignment.center,
                                        child:Hero(
                                          tag: "${content.id}",
                                          child:  fromSavedData==true&&connection==false? Image.file(File(savedProduct.img)) :
                                               Image.network('http://smktesting.herokuapp.com/static/'+content.img),
                                        ))),
                                    if(isAut==true) Align(
                                    alignment:Alignment.topRight,
                                    child:
                                    Container(
                                    width: 50.0,
                                    height: 50.0,
                                    margin: EdgeInsets.only(bottom:20),
                                    decoration: new BoxDecoration(
                                      color: Colors.black87,
                                      border: Border.all(),
                                      shape: BoxShape.circle,),
                                        child: iconButtonPL(
                                            connection: connection,
                                            content: content,
                                            savedProduct: savedProduct,
                                            itemNewState: itemRefresh,
                                          catalogNewState: widget.newCatalogState,
                                        ),
                                    ),
                                    )]
                           ),
                         ),
                    ),

                            Center(child:
                                  Container(
                                    width:  double.maxFinite,
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.7),
                                            blurRadius: 8.0,
                                            spreadRadius: 0.5,
                                            offset: Offset(0, 0)
                                        ),
                                      ],
                                    ),
                                      child: Text(
                                        content.title,
                                        textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                      ),
                                  ),
                            ),
                  ],
                )
            );
          }
          else{
            return Center(child:CircularProgressIndicator());
          }
        }
        );
  }}