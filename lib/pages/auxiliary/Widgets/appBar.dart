import 'package:flutter/material.dart';


class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(56);

  final bool? backButton;
  final bool isAuth;
  final Function() callBack;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const AppBarWidget (
  { Key? key, this.backButton, required this.isAuth, required this.callBack, required this.scaffoldKey}
      );
  @override
  Widget build(BuildContext context) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    brightness: Brightness.dark,
    automaticallyImplyLeading: true,
    // choose set of icons
    actions: isAuth==false?<Widget>[
      IconButton(icon: Icon(Icons.refresh_rounded),//refresh data
        onPressed: (){
          callBack();
        },
      )]: <Widget>[
      IconButton(icon: Icon(Icons.refresh_rounded),//refresh data
          onPressed: (){
            callBack();
          }
      ),
      IconButton(icon: Icon(Icons.menu),
        onPressed:
            () => scaffoldKey.currentState!.openEndDrawer(),
      )],
    leading:backButton==null&&backButton!=false?IconButton(icon: Icon(Icons.arrow_back_ios),
      onPressed: () { Navigator.pop(context); },):
    isAuth==false?IconButton(icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          if(Navigator.canPop(context)){
            Navigator.pop(context);
          }
        }):Container(),
    backgroundColor: Colors.black.withOpacity(0.9),
  );
}}