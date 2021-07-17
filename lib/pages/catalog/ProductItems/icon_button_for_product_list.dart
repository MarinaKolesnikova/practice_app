import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pract_app/pages/auxiliary/Functions/toast_message.dart';
import 'package:pract_app/pages/catalog/Functions/saving_image.dart';
import 'package:pract_app/services/Models/api_product.dart';
import 'dart:typed_data';
import 'package:pract_app/services/Provider/database_provider.dart';

class iconButtonPL extends StatefulWidget{
  @override
  final bool connection;
  final ApiProduct? savedProduct;
  final ApiProduct content;
  final void Function() itemNewState;
  final void Function() catalogNewState;
  const iconButtonPL(
      {Key? key,
        required this.connection,
        required this.savedProduct,
        required this.content,
        required this.itemNewState,
      required this.catalogNewState}
      ):super(key: key);
 _iconButtonPLState createState() => _iconButtonPLState();

}

class _iconButtonPLState extends State<iconButtonPL>{

  void callback(){
    setState(() {
      widget.itemNewState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ApiProduct? savedProduct = widget.savedProduct;
    final ApiProduct content= widget.content;
    final bool connection = widget.connection;
   return  savedProduct!.id==0? IconButton(
       icon: Icon(Icons.save_alt_rounded, color:Colors.white),
       onPressed: ()async {
         saving_image(content, connection, widget.itemNewState, widget.catalogNewState);
       }
   )
    : IconButton(
       icon: Icon(Icons.delete_outline, color:Colors.white),
       onPressed: ()async{
         try {
           DatabaseProvider.db.delete(savedProduct.id);
           File img = await File(savedProduct.img);
           img.deleteSync(recursive: false);
            widget.catalogNewState();
         }
         catch(E){
           print (E.toString());
         }}
         );
  }
}