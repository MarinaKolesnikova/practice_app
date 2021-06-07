import 'dart:convert';
import 'dart:io';
import 'package:condition/condition.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_app/pages/auxilary/menuBar.dart';
import 'package:pract_app/pages/detailPage/voteItem.dart';
import 'package:pract_app/services/Api_product.dart';
import 'package:pract_app/services/Api_vote.dart';
import 'package:http/http.dart' as http;
import 'package:pract_app/services/database_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../auxilary/hasTokenFunction.dart';

double rate=0.0;

Object redrawObject= Object();// key for listview update
Future<List <ApiVote>> GetComments(int id) async{
  List<ApiVote> comments;
  final Uri apiUrl=Uri.parse("http://smktesting.herokuapp.com/api/reviews/$id");
  var response = await http.get(apiUrl);

  if(response.statusCode==200){
    final String data =response.body.toString();
    var voteObjsJson = jsonDecode(data) as List;
    comments = voteObjsJson.map((prodJson) => ApiVote.fromJson(prodJson)).toList();
    comments.sort((a,b)=>b.created_at.compareTo(a.created_at));
    return comments;
  }
  else{
    return comments= <ApiVote>[] as List<ApiVote>;
  }
}

final TextEditingController commentController = TextEditingController();

class Details extends StatefulWidget{
  @override
  final ApiProduct content;
  final bool isAuth;
  final Function() refresh;
  const Details(
      {  Key? key, required this.content, required this.isAuth, required this.refresh}):super(key: key);
  _DetailsPageState createState() => _DetailsPageState();

}

class _DetailsPageState extends State<Details>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState(){
    super .initState();
  }
  @override
  Widget build(BuildContext context) {

    final ApiProduct content = widget.content;
    final bool isAuth = widget.isAuth;

    final _isKeyboard=MediaQuery.of(context).viewInsets.bottom!=0; // keyboard visibility check

    Size size = MediaQuery.of(context).size;

    //set comment
    void createComment(int id, String comment, int rating) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? 0;
      final response= await http.post(
        Uri.parse('http://smktesting.herokuapp.com/api/reviews/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':'Token '+token.toString()
        },
        body: jsonEncode(<String, String>{
          "rate": rating.toString(),
          "text": comment
        }),
      );
      if(response.statusCode==200){
        var JsonData=json.decode(response.body);

        if (JsonData['success']==true){
          SystemChannels.textInput.invokeMethod('TextInput.hide'); //for keyboard dismissing
          setState(() {
            commentController.text="";
            rate=0.0;
          });
        }
      }
    }
         return  Scaffold(
            key:_scaffoldKey,
            appBar: AppBar(
            centerTitle: true,
              brightness: Brightness.dark,
              automaticallyImplyLeading: true,
              // choose set of icons
              actions: isAuth==false?<Widget>[
              IconButton(icon: Icon(Icons.refresh_rounded),//refresh data
              onPressed: (){
                  if (mounted) setState(() {});
                },
              )]: <Widget>[
              IconButton(icon: Icon(Icons.refresh_rounded),//refresh data
                onPressed: (){
                  if (mounted) setState(() {});
              }
              ),
              IconButton(icon: Icon(Icons.menu),
              onPressed:
              () => _scaffoldKey.currentState!.openEndDrawer(),
              )],
              leading:IconButton(icon: Icon(Icons.arrow_back_ios),
            onPressed: () { Navigator.pop(context); },),
            backgroundColor: Colors.black,),
            endDrawer:
            Drawer(
             child:MenuBar()),
            body:
            FutureBuilder(
             future:Connectivity().checkConnectivity(), // check internet connection
              builder:(BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var result = snapshot.data;
                  final bool connection;
                  if(result != ConnectivityResult.none){
                  connection =  true;}
                  else {connection=false;};
                  print(connection);
                  return
                    Container(
                        color:Colors.white,
                        child:
                        SingleChildScrollView( //scroll
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  FutureBuilder(
                                  future:DatabaseProvider.db.isExist(content.id), // check item in DB
                                  builder:(BuildContext context, AsyncSnapshot<ApiProduct> snapshot) {
                                    if(snapshot.hasData) {
                                      ApiProduct? savedProduct = snapshot.data;
                                     if(!_isKeyboard){
                                       return
                                       Container(
                                       padding: EdgeInsets.only(top:10, left:10, right: 10),
                                        width: size.width,
                                       decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 12.0,
                                        spreadRadius: 0.1,
                                        offset: Offset(2, 5)
                                        )
                                         ]),
                                          child: Conditioned(
                                            cases: [
                                              Case(connection==true && savedProduct!.img!=content.img, builder: () =>
                                                  Image(
                                                image: NetworkImage('http://smktesting.herokuapp.com/static/'+content.img),
                                                fit: BoxFit.fitWidth, )),
                                              Case(connection==true && savedProduct!.img==content.img, builder: () =>
                                                  Image(
                                                    image:FileImage(File(savedProduct!.img)),
                                                    fit: BoxFit.fitWidth, )),
                                              Case(connection==false &&savedProduct!.id!=0, builder: () =>
                                                  Image(
                                                    image:FileImage(File(savedProduct!.img)),
                                                    fit: BoxFit.fitWidth,)),
                                            ],
                                            defaultBuilder: () => Image(image: AssetImage("assets/images/noImage.jpg")),
                                    ),
                                            );
                                          }
                                      else{return Container();}
                                    }
                                    else{
                                      return Container(); }}),
                                  if(!_isKeyboard)
                                    Container(
                                        margin: EdgeInsets.only(top:5),
                                        padding: EdgeInsets.only(top: 10, left:20, right: 20),
                                        child:Text(
                                          content.title ,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Arial',
                                              fontSize:40,
                                              color:Colors.black87),
                                        )
                                    ),
                                  if(!_isKeyboard)
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical:10),
                                        child:
                                        Text(content.text ,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Arial',
                                              fontSize:20,
                                              color:Colors.black87),
                                        )),
                                  connection==true? const Divider(
                                    height: 20,
                                    thickness: 2,
                                    indent: 20,
                                    endIndent: 20,
                                  ):Divider(),
                                  connection==true?
                                  FutureBuilder(
                                      future:isAuthorized(),
                                      builder:(BuildContext context, AsyncSnapshot<bool> snapshot) {
                                        if(snapshot.hasData){
                                          bool? isAuth=snapshot.data;
                                          if(isAuth==true){
                                            return
                                              Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                        margin: EdgeInsets.only(top: 10),
                                                        child:
                                                        RatingBar.builder(                                              //Rating
                                                          initialRating: rate,
                                                          minRating: 1,
                                                          direction: Axis.horizontal,
                                                          allowHalfRating: false,
                                                          itemCount: 5,
                                                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                          itemBuilder: (context, _) => Icon(
                                                            Icons.star,
                                                            color: Colors.black,
                                                          ),
                                                          onRatingUpdate: (rating) {
                                                            setState(() {
                                                              rate=rating;});
                                                            },
                                                        )
                                                    ),
                                                    Container(
                                                        padding: EdgeInsets.only(left: 20, right:20, top: 10),
                                                        child: Column(
                                                          children: <Widget>[
                                                            SizedBox(
                                                                width:size.width*0.9,
                                                                child: TextField(
                                                                    keyboardType: TextInputType.multiline,
                                                                    maxLines: _isKeyboard?10:2,
                                                                    controller: commentController,
                                                                    decoration: InputDecoration(
                                                                      fillColor: Colors.white,
                                                                      filled:true,
                                                                      border: OutlineInputBorder(),
                                                                      labelText: 'Comment',
                                                                    )
                                                                )
                                                            ),
                                                            Container(
                                                                margin:EdgeInsets.only(top:5),
                                                                width:size.width*0.9,
                                                                height:40,
                                                                child:TextButton(
                                                                    style: ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all<Color>(Colors.greenAccent),),
                                                                    onPressed:(){                                       //send comment
                                                                       final String comment =commentController.text;
                                                                       var isReady=createComment(content.id,comment, rate.toInt());
                                                                       },
                                                                    child: Text(
                                                                      "Send",
                                                                      style: TextStyle(color:Colors.black87,fontSize:18),)
                                                                )
                                                            )
                                                          ],
                                                        ) //this Column
                                        ) //this container
                                         ]
                                              );
                                          }
                                          else{
                                            return Container();
                                          }}
                                        else{
                                          return Container();
                                        }}
                                        ):Container(),
                                  connection==true? Container(
                                      child:
                                      FutureBuilder(
                                          future:GetComments(content.id),
                                          builder:(BuildContext context, AsyncSnapshot<List<ApiVote>> snapshot) {
                                            if(snapshot.hasData){
                                              List<ApiVote>? apVote=snapshot.data;
                                              return
                                                Container (
                                                    width: size.width,
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                        width: size.width*0.9,
                                                        child:
                                                        ListView.builder(
                                                            physics: NeverScrollableScrollPhysics(),
                                                            key:ValueKey<Object>(redrawObject),
                                                            itemCount:  apVote!.length,
                                                            shrinkWrap: true,
                                                            itemBuilder: (context, index) =>VoteItem(content: apVote[index]))
                                                    ));
                                            }
                                            else {
                                              return Center(child:CircularProgressIndicator()); }}
                                              )
                                  ):Container(),
                                ]
                            )
                        )
                    );}
                else {
                  return Center(child: CircularProgressIndicator());
                }}
                ));
  }}



