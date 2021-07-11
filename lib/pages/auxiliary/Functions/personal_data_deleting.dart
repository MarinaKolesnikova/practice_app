import 'package:shared_preferences/shared_preferences.dart';

//deleting personal data and token in case of exit from acc
void deleteData() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.remove('token');
  await preferences.remove('name');
  await preferences.remove('surname');
  await preferences.remove('filepath');
  await preferences.clear();
  //DatabaseProvider.db.destroyDB();
}