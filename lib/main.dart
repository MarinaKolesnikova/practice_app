import 'package:flutter/material.dart';
import 'package:pract_app/pages/auxiliary/Functions/has_token_function.dart';
import 'package:pract_app/pages/catalog/catalog.dart';
import 'package:pract_app/pages/firstpage.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
    runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    String value='';
    SharedPreferences.getInstance().then((instance){
      value = instance.getString('token')!;
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      FutureBuilder(
        future:isAuthorized(),
        builder:(BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.hasData) {
          print(snapshot.hasData);
          bool? isAuth = snapshot.data;
          if (isAuth == true) {
            return Catalog();
          }
          else {
            return FirstPage();
          }
        }
        else{
          return Center(child:CircularProgressIndicator()); }}
    ,)
    );
  }}


