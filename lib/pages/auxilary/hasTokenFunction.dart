import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isAuthorized() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? null;
  print(token);
  if(token!=null){return true;}
  else {return false;}
}
