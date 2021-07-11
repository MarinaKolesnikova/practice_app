import 'package:flutter/material.dart';
import 'package:pract_app/background/background.dart';
import 'package:pract_app/pages/LogReg/Functions/registrationFunction.dart';
import 'package:pract_app/pages/auxiliary/Widgets/text_field_widget.dart';
import 'package:pract_app/pages/auxiliary/Widgets/unfocus.dart';
import 'package:pract_app/pages/catalog/catalog.dart';
import 'package:pract_app/services/Models/api_user.dart';
import 'package:pract_app/pages/userPage/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget
{
  @override
  final String title = "Signup page";
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {

  late final TextEditingController _nameController ;
  late final TextEditingController _passController ;
  late final TextEditingController _passConfirmController;
  bool _isLoading=false;//for circleBar

  @override
  void initState(){
    _nameController = TextEditingController();
    _passController = TextEditingController();
    _passConfirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passController.dispose();
    _passConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //size of screen
    final _isKeyboard=MediaQuery.of(context).viewInsets.bottom!=0;// keyboard visibility check\
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

          body:Unfocus(
            child: Background(
             child: Align(
               child:Column(
                   mainAxisAlignment:MainAxisAlignment.center,
                   children: <Widget>[
                     _isLoading? Center(child: CircularProgressIndicator()):
                     !_isKeyboard?Row(
                     children: <Widget>[
                      Container(
                         padding:EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 10.0),
                         child:  Text(
                             "SIGN",
                              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',fontSize:80,color:Colors.black87),
                         )),
                      Container(
                         alignment: Alignment.center,
                         padding:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                         child:  Text(
                         "UP",
                         style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',fontSize:80,color:Colors.greenAccent),
                     )),
               ]):
                     Row(),
                    Container (
                        width: size.width-180,
                        margin: EdgeInsets.only(top:20.0),
                         child:Text(
                              "PLEASE, ENTER YOUR DATA TO SIGNUP ",
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
                     Container (
                         child:
                         TextFieldWidget(
                             controller: _passConfirmController,
                             labelText: 'Confirm password',
                             icon:Icons.lock_outline_rounded ,
                             obscureText:true
                         )
                         ),
                  Container(
                      margin:  EdgeInsets.only(top:10.0 ),
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          width:size.width - 100,
                          height:50,
                          child:TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),),
                                onPressed: () async{
                                setState(() {
                                  _isLoading=true;
                                });
                                final String name =_nameController.text;
                                final String pass =_passController.text;
                                final String passConf =_passConfirmController.text;
                                final ApiUserResult res = await Registation(name, pass); //perform registration
                                if(pass==passConf){
                                  if(res.success){
                                    SharedPreferences preferences = await SharedPreferences.getInstance();
                                    preferences.setString('token', res.token); // token saving
                                    Navigator.pop(context);
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) => new Catalog()),
                                            (Route<dynamic> route) => false);
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => new Profile()),);
                                    setState(() {
                                      _isLoading=false;
                                    });
                                  }
                                 else{ Fluttertoast.showToast(
                                      msg: "User with such username already exists",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER
                                  );
                                  setState(() {
                                    _isLoading=false;
                                  });
                                }}
                                else{
                                  Fluttertoast.showToast(
                                      msg: "Passwords doesn`t match",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER
                                  );
                                  setState(() {
                                    _isLoading=false;
                                  });
                                }
                              },
                              child: Text("OK", style: TextStyle(color:Colors.black87,fontSize:18),)
                          ),
                      ),
                  ),]
               ),
             ),
            ),
          ),
      );
  }
}