
import 'package:pract_app/pages/auxiliary/Functions/toastMessage.dart';
import 'package:pract_app/services/Models/User_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setProfileData(String photoPath, String name, String surname) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();  // data saving
  preferences.setString('filepath', photoPath );
  preferences.setString('name', name );
  preferences.setString('surname', surname );
  returnToast("Saved!","CENTER");
}

Future<UserData> isCreated() async {
  final prefs = await SharedPreferences.getInstance();
  String name = prefs.getString('name')??'';
  String surname = prefs.getString('surname')??'';
  String filepath = prefs.getString('filepath')??'';
  UserData usData = UserData(name: name, surname: surname, photoPath: filepath);
  return usData;
}