import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pract_app/services/Models/Api_vote.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//set comment
void createComment(int id, String comment, int rating, Function() newState) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? 0;
  final response= await http.post(
    Uri.parse('http://smktesting.herokuapp.com/api/reviews/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':'Token '+token.toString()
    },
    body: jsonEncode(<String, String>{
      "rate": rating.toString(),
      "text": comment
    }),
  );

  if(response.statusCode==200){
    var JsonData=json.decode(response.body);
    if (JsonData['success']==true){
      print('sent');
      SystemChannels.textInput.invokeMethod('TextInput.hide'); //for keyboard dismissing
      newState();
    }
  }
  else{
    print('was not sent');
  }
}

//Get list of comments
Future<List <ApiVote>> GetComments(int id) async{
  List<ApiVote> comments;
  final Uri apiUrl=Uri.parse("http://smktesting.herokuapp.com/api/reviews/$id");
  var response = await http.get(apiUrl);

  if(response.statusCode==200){
    final String data =response.body.toString();
    var voteObjsJson = jsonDecode(data) as List;
    comments = voteObjsJson.map((prodJson) => ApiVote.fromJson(prodJson)).toList();
    comments.sort((a,b)=>b.created_at.compareTo(a.created_at));
    return comments;
  }
  else{
    return comments= <ApiVote>[] as List<ApiVote>;
  }
}