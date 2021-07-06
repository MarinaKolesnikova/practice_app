import 'dart:io';

import 'package:condition/condition.dart';
import 'package:flutter/material.dart';
import 'package:pract_app/services/Models/Api_product.dart';

class ProductImage extends StatelessWidget {
  final bool connection;
  final  ApiProduct? savedProduct;
  final  ApiProduct content;
  const ProductImage({
  Key? key, required this.connection, required this.savedProduct, required this.content
}) ;

  @override
Widget build(BuildContext context){
    Size size= MediaQuery.of(context).size;
    return
      Container(
        padding: EdgeInsets.only(top:10, left:10, right: 10),
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 12.0,
                  spreadRadius: 0.1,
                  offset: Offset(2, 5)
              )
            ]),
        child: Conditioned(
          cases: [
            Case(connection==true && savedProduct!.img!=content.img, builder: () =>
                Image(
                  image: NetworkImage('http://smktesting.herokuapp.com/static/'+content.img),
                  fit: BoxFit.fitWidth, )),
            Case(connection==true && savedProduct!.img==content.img, builder: () =>
                Image(
                  image:FileImage(File(savedProduct!.img)),
                  fit: BoxFit.fitWidth, )),
            Case(connection==false &&savedProduct!.id!=0, builder: () =>
                Image(
                  image:FileImage(File(savedProduct!.img)),
                  fit: BoxFit.fitWidth,)),
          ],
          defaultBuilder: () => Image(image: AssetImage("assets/images/noImage.jpg")),
        ),
      );
  }
}