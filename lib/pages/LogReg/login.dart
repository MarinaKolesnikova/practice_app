import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pract_app/background/background.dart';
import 'package:pract_app/pages/LogReg/Functions/loginFunction.dart';
import 'package:pract_app/pages/auxiliary/Widgets/text_field_widget.dart';
import 'package:pract_app/pages/auxiliary/Widgets/unfocus.dart';
import 'package:pract_app/pages/catalog/catalog.dart';
import 'package:pract_app/services/Models/api_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LogIn extends StatefulWidget
{
  @override
  final String title = "Login page";
  _LogInPageState createState() => _LogInPageState();
}



class _LogInPageState extends State<LogIn> {

  late final TextEditingController _nameController;
  late final TextEditingController _passController;
  bool _isLoading=false;

  @override
  void initState(){
    _nameController = TextEditingController();
    _passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _isKeyboard=MediaQuery.of(context).viewInsets.bottom!=0; // keyboard visibility check\
    return
        Scaffold(
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.dark,
              centerTitle: true,
              automaticallyImplyLeading: true,
              leading:IconButton(icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
              backgroundColor: Colors.black.withOpacity(0.9),
            ),
          body:new Unfocus(
            child: Background(
              child:Column(
              mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[
                  _isLoading? Center(child: CircularProgressIndicator()):
                  !_isKeyboard?Row(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding:EdgeInsets.fromLTRB(size.width/6, 0.0, 0.0, 10.0),
                            child:  Text(
                               "LOG",
                               style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',fontSize:80,color:Colors.black87),
                            )),
                        Container(
                            padding:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                            child:  Text(
                                "IN",
                                 style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',fontSize:80,color:Colors.greenAccent),
                            )),
                      ]):Row(),
                Container (
                    width: size.width-180,
                    margin: EdgeInsets.only(top:20.0),
                    alignment: Alignment.center,
                    child:Text(
                         "PLEASE, ENTER YOUR DATA TO LOGIN ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',fontSize:20),
                 )),
                Container (
                 margin: EdgeInsets.only(top:20.0, bottom: 10.0),
                 child:
                 TextFieldWidget(
                 controller: _nameController,
                 labelText: 'Username',
                  icon:Icons.account_circle_outlined ,
                  obscureText:false
                 )
                ),
                Container (
                 margin: EdgeInsets.only(bottom: 10.0),
                  child:
                    TextFieldWidget(
                      controller: _passController,
                      labelText: 'Password',
                      icon:Icons.lock_outline_rounded ,
                      obscureText:true
                    )
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width:size.width - 100,
                        height:50,
                        child:TextButton(
                            style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),),
                            onPressed: ()async{
                              setState(() {
                                _isLoading=true;
                              });
                              final String name =_nameController.text;
                              final String pass =_passController.text;
                              final ApiUserResult res = await Login(name, pass);
                              if(res.success){

                                  SharedPreferences preferences = await SharedPreferences.getInstance();
                                  preferences.setString('token', res.token);
                                  //Navigator.of(context).pushNamedAndRemoveUntil('/catalog', ModalRoute.withName('/home'));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => new Catalog(),
                                    ),
                                        (route) => false,
                                  );
                                  setState(() {
                                     _isLoading=false;
                                   });
                                 }
                              else{
                                Fluttertoast.showToast(
                                msg: "Username or password is wrong",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER);
                                setState(() {
                                  _isLoading=false;
                                });
                            }},
                            child: Text("OK", style: TextStyle(color:Colors.black87,fontSize:18),)
                     )
                    )
                ),
              ]
              )
         ),
          ),
        );
  }
}