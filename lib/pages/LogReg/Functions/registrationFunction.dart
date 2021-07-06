import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pract_app/services/Models/Api_user.dart';


Future<ApiUserResult> Registation(String username, String password ) async{
  final Uri apiUrl=Uri.parse("http://smktesting.herokuapp.com/api/register/");
  final response = await http.post(apiUrl, body: {
    'username': username,
    'password': password
  });

  if(response.statusCode==201){
    final String responseString = response.body;
    print('Success signup');
    return apiUserResultFromJson(responseString);
  }
  else{
    print('Fail signup');
    return ApiUserResult(success: false, token:'-1' );
  }
}