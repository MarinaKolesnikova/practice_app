import 'dart:convert';
import 'package:pract_app/services/Api_product.dart';
import 'package:http/http.dart' as http;

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