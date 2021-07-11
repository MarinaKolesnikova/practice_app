import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pract_app/services/Models/api_user.dart';

Future<ApiUserResult> Login(String username, String password ) async{
  final Uri apiUrl=Uri.parse("http://smktesting.herokuapp.com/api/login/");
  final response = await http.post(apiUrl, body: {
    'username': username,
    'password': password
  });

  if(response.statusCode==200){
    var JsonData;
    final String responseString = response.body;
    JsonData=json.decode(response.body);
    if (JsonData['success']==true){
      return apiUserResultFromJson(responseString);
    }
    else{
      return ApiUserResult(success: false, token:'-1' );
    }
  }
  else{
    return ApiUserResult(success: false, token:'-1' );
  }
}

