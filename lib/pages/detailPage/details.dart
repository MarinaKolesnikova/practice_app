import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_app/pages/detailPage/Functions/commentInterface.dart';
import 'package:pract_app/pages/auxiliary/Widgets/app_bar.dart';
import 'package:pract_app/pages/detailPage/product_image.dart';
import 'package:pract_app/pages/detailPage/rating_bar.dart';
import 'package:pract_app/pages/auxiliary/Widgets/menu_bar.dart';
import 'package:pract_app/pages/auxiliary/Widgets/unfocus.dart';
import 'package:pract_app/pages/detailPage/vote_item.dart';
import 'package:pract_app/services/Models/api_product.dart';
import 'package:pract_app/services/Models/api_vote.dart';
import 'package:pract_app/services/Provider/database_provider.dart';
import '../auxiliary/Functions/has_token_function.dart';

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
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late double rate;
  Object redrawObject= Object();// key for listview update
  late final TextEditingController commentController ;

  @override
  void initState(){
    rate=1.0;
    commentController = TextEditingController();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    super .initState();
  }

  @override
  void dispose(){
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    void newState(){
      if(mounted)
      setState(() {
        commentController.text="";
        rate=1.0;
      });}

      void callBack(double rating){
      setState(() {
        rate=rating;
      });
      }

    final ApiProduct content = widget.content;
    final bool isAuth = widget.isAuth;
    final _isKeyboard=MediaQuery.of(context).viewInsets.bottom!=0; // keyboard visibility check\
    Size size = MediaQuery.of(context).size;

         return  Scaffold(
            key:_scaffoldKey,
             appBar: AppBarWidget(
               isAuth:isAuth,
               callBack: newState,
               scaffoldKey: _scaffoldKey,
             ),
            endDrawer:
            Drawer(
             child:MenuBar()),
            body: Unfocus(
                child:
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
                                         ProductImage(
                                           connection:connection,
                                           savedProduct:savedProduct,
                                           content:content
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
                                                    RatingWidget(
                                                      rate:rate,
                                                      callBack:callBack
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
                                                                       var isReady=createComment(content.id,comment, rate.toInt(), newState);
                                                                       },
                                                                    child: Text(
                                                                      "Send",
                                                                      style: TextStyle(color:Colors.black87,fontSize:18),)
                                                                ),
                                                            ),
                                                          ],
                                                        ),//this Column
                                        ), //this container
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
                            ),
                        ),
                    );}
                else {
                  return Center(child: CircularProgressIndicator());
                }}
                ),
    ),
         );
  }}



