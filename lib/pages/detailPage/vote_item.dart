import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:pract_app/services/Models/api_vote.dart';

class VoteItem extends StatefulWidget{
  @override
  final String title = "Signup page";
  final ApiVote content;
  const VoteItem({  Key? key, required this.content,}):super(key: key);
  _VoteItemPageState createState() => _VoteItemPageState();
}

class _VoteItemPageState extends State<VoteItem> {
  @override
  Widget build(BuildContext context) {
    ApiVote appVote= widget.content;
    Size size = MediaQuery.of(context).size; //size of screen
    return  Container(
      constraints: BoxConstraints(minHeight: 100),
      alignment: Alignment.topLeft,
      width: size.width*0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 2.0, spreadRadius: 0.4)],
          color: Colors.greenAccent,
          ),
      margin: const EdgeInsets.only(top:5),
      padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: size.width*0.9-2,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                constraints: BoxConstraints(minHeight: 100),

                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                    Row(
                        children: <Widget>[
                        Container(
                            width:size.width*0.3,
                            height: 20,
                            child:RatingBar.builder(                                              //Rating
                            initialRating: appVote.rate.toDouble(),
                            ignoreGestures: true,
                            direction: Axis.horizontal,
                            itemSize: 18.0,
                            itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                                itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.black,
                            ),
                              onRatingUpdate: (rating) {
                            }
                            )
                        ),
                        Container(
                         width:size.width*0.6-20,
                            height: 20,
                         alignment: Alignment.topRight,
                          child:Text(
                          DateFormat('dd-MM-yyyy H:m').format(appVote.created_at),
                          style: TextStyle(
                              fontSize:12, color: Colors.black)
                          )),
                      ]),
                  Container(
                      width:size.width*0.9,
                      alignment: Alignment.bottomLeft,
                      child:Text(
                          appVote.text.toString(),
                          style: TextStyle(
                              fontSize:18, color: Colors.black)
                      )),])
            )],
        ),
     // ),
    );
  }}