import 'package:flutter/material.dart';
import 'package:pract_app/background/background.dart';
import 'package:pract_app/pages/catalog/catalog.dart';
import 'package:pract_app/services/Api_user.dart';
import 'package:pract_app/pages/userPage/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


Future<ApiUserResult> Registation(String username, String password ) async{
  final Uri apiUrl=Uri.parse("http://smktesting.herokuapp.com/api/register/");
  final response = await http.post(apiUrl, body: {
    'username': username,
    'password': password
  });

  if(response.statusCode==201){

    final String responseString = response.body;
    return apiUserResultFromJson(responseString);
  }
  else{
    return ApiUserResult(success: false, token:'-1' );
  }
}
//global variables
final TextEditingController _nameController = TextEditingController();
final TextEditingController _passController = TextEditingController();
final TextEditingController _passConfirmController = TextEditingController();
bool _isLoading=false;//for circleBar

class SignUp extends StatefulWidget
{
  @override
  final String title = "Signup page";
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  @override
  void dispose() {
    _nameController.text='';
    _passController.text='';
    _passConfirmController.text='';
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //size of screen
    return
      Scaffold(
          body:Background(
             child: Align(
               child:Column(

                   mainAxisAlignment:MainAxisAlignment.center,
                   children: <Widget>[
                     _isLoading? Center(child: CircularProgressIndicator()):
                     Row(
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
               ]),
                    Container (
                        width: size.width-180,
                        margin: EdgeInsets.only(top:20.0),
                         child:Text(
                              "PLEASE, ENTER YOUR DATA TO SIGNUP ",
                               style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',fontSize:20),
                       )),
                  Container (
                      margin: EdgeInsets.only(top:20.0, bottom: 10.0),
                      child: SizedBox(
                          width:size.width - 50,
                         child:  TextField(
                           controller:_nameController,
                            decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled:true,
                            prefixIcon: Icon(Icons.account_circle_outlined),
                            border: OutlineInputBorder(),
                            labelText: 'User name',
                  ),
                ))),
                     Container (
                         margin: EdgeInsets.only(bottom: 10.0),
                         child: SizedBox(
                             width:size.width - 50,
                             child:  TextField(
                               controller:_passController,
                               obscureText: true,
                               decoration: InputDecoration(
                                 fillColor: Colors.white,
                                 filled:true,
                                 border: OutlineInputBorder(),
                                 prefixIcon: Icon(Icons.lock_outline_rounded),
                                 labelText: 'Password',
                               ),
                             ))),
                     Container (
                         child: SizedBox(
                             width:size.width - 50,
                             child:  TextField(
                               controller: _passConfirmController,
                               obscureText: true,
                               decoration: InputDecoration(
                                 fillColor: Colors.white,
                                 filled:true,
                                 border: OutlineInputBorder(),
                                 prefixIcon: Icon(Icons.lock_outline_rounded),
                                 labelText: 'Confirm password',
                               ),
                             ))),
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
             )),
      );
  }
}