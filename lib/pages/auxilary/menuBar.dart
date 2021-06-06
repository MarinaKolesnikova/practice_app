import 'package:flutter/material.dart';
import 'package:pract_app/pages/firstpage.dart';
import 'package:pract_app/pages/userPage/profile.dart';
import 'package:pract_app/services/database_provider.dart';
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

class MenuBar extends StatelessWidget {
  @override
Widget build(BuildContext context) {
    return
      ListView(
        padding: EdgeInsets.zero,
        children: ListTile.divideTiles( //          <-- ListTile.divideTiles
            context: context,
            tiles: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
             ),
                child: Text(' MENU '),
    ),
           ListTile(
             title: Text('Exit'),
             leading: Icon(
               Icons.exit_to_app,
               color: Colors.black87,
               size: 24.0,
          ),
             onTap: () {
               deleteData();
               Navigator.pushAndRemoveUntil(
                 context,
                 MaterialPageRoute(
                   builder: (BuildContext context) => FirstPage(),
                 ),
                     (route) => false,
               );
               },
           ),
              ListTile(
                title: Text('Profile'),
                leading: Icon(
                  Icons.account_circle_rounded,
                  color: Colors.black87,
                  size: 24.0,
                ),
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Profile()),);
                  },
              )
            ]
        ).toList(),
      );
  }
}