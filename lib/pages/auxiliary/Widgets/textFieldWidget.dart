import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
final TextEditingController controller;
final String labelText;
final IconData? icon;
final bool obscureText;
const TextFieldWidget(
    {Key? key,
      required this.controller,
      required this.labelText,
      this.icon,
      required this.obscureText }
    ):super(key: key);
  @override
  Widget build(BuildContext context)  {
    Size size = MediaQuery.of(context).size;
   return
      SizedBox(
          width:size.width - 50,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              prefixIcon:icon!=null?Icon(icon):null,
              fillColor: Colors.white,
              filled:true,
              border: OutlineInputBorder(),
              labelText: labelText,
            ),
          ),
      );
  }}