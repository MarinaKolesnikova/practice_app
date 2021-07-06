
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingWidget extends StatelessWidget {
  final double rate;
  final Function(double rating) callBack;
  const RatingWidget({
    Key? key, required this.rate, required this.callBack
}): super(key:key);
  Widget build (BuildContext context){
   return Container(
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
            callBack(rating);
          },
        ),
    );
  }
}