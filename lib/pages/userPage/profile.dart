import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pract_app/background/background.dart';
import 'package:pract_app/services/User_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

Future<UserData> isCreated() async {
  final prefs = await SharedPreferences.getInstance();
  String name = prefs.getString('name')??'';
  String surname = prefs.getString('surname')??'';
  String filepath = prefs.getString('filepath')??'';
  UserData usData = UserData(name: name, surname: surname, photoPath: filepath);
  return usData;
}

TextEditingController _nameController = TextEditingController();
TextEditingController _surnameController = TextEditingController();

class Profile extends StatefulWidget{
  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<Profile>{
  ImagePicker _imagePicker = ImagePicker();
  String photoPath="";
  @override
  void dispose() {
    _nameController.text='';
    _surnameController.text='';
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final _isKeyboard=MediaQuery.of(context).viewInsets.bottom!=0;
    return
      Scaffold(
        body:
            Background(child:
            FutureBuilder(
                future:isCreated(),
                builder:(BuildContext context, AsyncSnapshot<UserData> snapshot) {
                  if(snapshot.hasData){
                    print(photoPath);
                    UserData? usData=snapshot.data;
                    if(photoPath.isEmpty)
                      photoPath=usData!.photoPath;
                    if(_nameController.text.isEmpty)
                      _nameController.text=usData!.name;
                    if(_surnameController.text.isEmpty)
                      _surnameController.text=usData!.surname;
                    return
                      Container (
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: size.height/20),
                          padding: EdgeInsets.all(0.0),
                          color: Colors.white.withOpacity(0.95),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:<Widget>[

                              Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                      child:
                                      SizedBox(
                                          height: 50,
                                          width: 50,
                                          child:IconButton(
                                            padding: new EdgeInsets.all(0.0),
                                            icon: Icon( Icons.cancel_presentation_rounded,
                                                color: Colors.black87,
                                                size:50),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              },
                                          ))
                                  )
                              ),
                              if(!_isKeyboard)
                                Container(
                                    width: size.width-180,
                                    margin: EdgeInsets.only(top:20.0),
                                    alignment: Alignment.center,
                                    child:
                                    Text('PLEASE, FILL OUT THE PERSONAL DATA',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',fontSize:20),)
                                )
                              else Container(),

                              if(!_isKeyboard)
                                GestureDetector( //for adding new img
                                  onTap: () async {
                                    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
                                    print(pickedFile!.path);
                                    if(pickedFile.path.isNotEmpty){
                                      setState(() {
                                        photoPath=pickedFile.path;
                                      });
                                    }
                                    },
                                  child: new Container(
                                      width: 250.0,
                                      height: 250.0,
                                      margin: EdgeInsets.symmetric(vertical: 40),
                                      decoration: new BoxDecoration(
                                          border: Border.all(),
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image:photoPath.isNotEmpty? new  FileImage(File(photoPath))  :   //fromFile or standard
                                              new AssetImage("assets/images/user.png") as ImageProvider
                                               )
                                              )),
                                ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child:
                                  SizedBox(
                                      width:size.width*0.9,
                                      child: TextField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled:true,
                                            border: OutlineInputBorder(),
                                            labelText: 'Name',
                                          ),
                                      )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child:
                                  SizedBox(
                                      width:size.width*0.9,
                                      child: TextField(
                                        controller: _surnameController,
                                        decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled:true,
                                            border: OutlineInputBorder(),
                                            labelText: 'Surname',
                                          ),
                                      ),
                                  ),),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                      width:size.width - 100,
                                      height:50,
                                      child:TextButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),),
                                          onPressed: () async{
                                            final String name =_nameController.text;
                                            final String surname =_surnameController.text;
                                            SharedPreferences preferences = await SharedPreferences.getInstance();  // data saving
                                            preferences.setString('filepath', photoPath );
                                            print(photoPath);
                                            preferences.setString('name', name );
                                            preferences.setString('surname', surname );
                                            Fluttertoast.showToast(
                                                msg: "Saved!",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM);
                                            setState(() {
                                              photoPath=photoPath;
                                            });
                                            SystemChannels.textInput.invokeMethod('TextInput.hide');},

                                          child: Text("Confirm", style: TextStyle(color:Colors.black87,fontSize:18),)
                                )
                      )
                ),
           ],
        ));
           }
           else{
            return Center(child:CircularProgressIndicator());
           }}
      )
      ));
  }

}