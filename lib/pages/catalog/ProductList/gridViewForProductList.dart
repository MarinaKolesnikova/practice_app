import 'package:flutter/material.dart';
import 'package:pract_app/pages/catalog/ProductItems/productItems.dart';
import 'package:pract_app/services/Models/Api_product.dart';

class GridViewPL extends StatelessWidget{
  final bool isAuth;
  final List<ApiProduct>? content;
  final bool connection;
  final void Function() callback;
  const GridViewPL(
      {Key? key, required this.content, required this.isAuth, required this.connection, required this.callback}
      ):super(key: key);

  Widget build(BuildContext context) {
    return
      Container(
        child:GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount:  content!.length,
          padding: const EdgeInsets.only(left: 20, right: 20, top:20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) => productItem(
              content: content![index],
              isAut: isAuth,
              connection:connection,
              parentAction: callback
          ),
        ),
      );

}}