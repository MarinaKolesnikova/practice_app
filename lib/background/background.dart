import 'package:flutter/material.dart';

class Background extends StatelessWidget{
final Widget child;
const Background({  Key? key, required this.child,}):super(key: key);
  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
  return   Container(
    height: size.height,
    width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_cow1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child:
        Stack(
            children: <Widget>[ child ]),
      ),
    );
}
}

