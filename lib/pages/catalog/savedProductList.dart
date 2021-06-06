import 'package:flutter/material.dart';

class SavedProductList extends StatefulWidget{
  final bool isAuth ;
  @override
  final String title = "product list";
  const SavedProductList({ Key? key, required this.isAuth}):super(key: key);
  _SavedProductListPageState createState() =>  _SavedProductListPageState();
}
class _SavedProductListPageState extends State<SavedProductList> {
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}