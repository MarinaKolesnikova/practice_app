import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pract_app/pages/auxiliary/Functions/toast_message.dart';
import 'package:pract_app/services/Models/api_product.dart';
import 'dart:typed_data';
import 'package:pract_app/services/Provider/database_provider.dart';

class iconButtonPL extends StatefulWidget{
  @override
  final bool connection;
  final ApiProduct? savedProduct;
  final ApiProduct content;
  final void Function() productListAction;
  const iconButtonPL(
      {Key? key,  required this.connection, required this.savedProduct,required this.content, required this.productListAction }
      ):super(key: key);
 _iconButtonPLState createState() => _iconButtonPLState();

}

class _iconButtonPLState extends State<iconButtonPL>{

  @override
  Widget build(BuildContext context) {
    final ApiProduct? savedProduct = widget.savedProduct;
    final ApiProduct content= widget.content;
    final bool connection = widget.connection;
   return  savedProduct!.id==0? IconButton(
       icon: Icon(Icons.save_alt_rounded, color:Colors.white),
       onPressed: ()async {
         if(connection){
           print(connection);
           try {
             var status = await Permission.storage.status;
             if (await Permission.storage.request().isGranted) {
               var response;
               //var content;
               response= await Dio().get(
                   "http://smktesting.herokuapp.com/static/"+content.img,
                   options: Options(responseType: ResponseType.bytes));
               final result = await ImageGallerySaver.saveImage(
                   Uint8List.fromList(response.data),
                   quality: 100,
                   name: content.img);
               print("Result $result");
               print(result['filePath'].toString().replaceFirst('file://',''));
               if(result['isSuccess']==true){
                 ApiProduct product = new ApiProduct(
                     id: content.id,
                     title: content.title,
                     text: content.text,
                     img: result['filePath'].toString().replaceFirst('file://','') );
                 DatabaseProvider.db.insert(product);
               }
               setState(() {
                 widget.productListAction();
               });
             }
             else{
               print('permission denied');
             }
           }
           catch (E) {
             print(E);
             returnToast("Error!","CENTER");}
         }
       }
   )
    : IconButton(
       icon: Icon(Icons.delete_outline, color:Colors.white),
       onPressed: ()async{
         try {
           DatabaseProvider.db.delete(savedProduct.id);
           File img = await File(savedProduct.img);
           img.deleteSync(recursive: false);
           setState(() {
             widget.productListAction();
           });
         }
         catch(E){
           print (E.toString());
         }}
         );
  }
}