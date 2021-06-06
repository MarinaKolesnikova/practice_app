import 'package:flutter/material.dart';
import 'package:pract_app/background/background.dart';
import 'package:pract_app/pages/catalog/catalog.dart';
import 'package:pract_app/pages/login.dart';
import 'package:pract_app/pages/signup.dart';


class FirstPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body:Background(
            child:Column(
                mainAxisAlignment:MainAxisAlignment.end,
              children: <Widget>[
                Row(
                    children: <Widget>[
                  Container(
                    padding:EdgeInsets.fromLTRB(size.width/6, 50.0, 0.0, 0.0),
                      child:  Text(
                    "HI",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',fontSize:80,color:Colors.black87),
                  )),
                  Container(
                    padding:EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                    child:  Text(
                      ",",
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',fontSize:80,color:Colors.greenAccent),
                    ))]),
                Container(
                    width: size.width ,
                    padding:EdgeInsets.fromLTRB(size.width/6, 0.0, 0.0, size.height/6),
                    child:  Text(
                      "friend",
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',fontSize:80,color:Colors.black87),
                    )),
                  Container(
                  margin:  EdgeInsets.symmetric( vertical: 10),
                      child:SizedBox(
                          width:size.width - 100,
                          height:50,
                          child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),),
                              onPressed: (){
                                Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => new LogIn()),);
                                },
                              child: Text("LOGIN", style: TextStyle(color:Colors.black87,fontSize:18),)
                          )
                      )
                  ),
                Container(
                    margin:  EdgeInsets.symmetric( vertical: 10),
                    child:SizedBox(
                        width:size.width - 100,
                        height:50,
                        child:TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new SignUp()),);
                              },
                            child: Text("SIGN UP", style: TextStyle(color:Colors.black87,fontSize:18))
                        )
                    )
                ),
                Container(
                    margin:  EdgeInsets.only(top:10.0, bottom: size.height/8 ),
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width:size.width - 100,
                        height:50,
                        child:TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),),
                            onPressed: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => new Catalog()),);
                              },
                            child: Text("CONTINUE", style: TextStyle(color:Colors.black87,fontSize:18),)
                        )
                    )
                ),
              ]
            )
        ));
  }
}