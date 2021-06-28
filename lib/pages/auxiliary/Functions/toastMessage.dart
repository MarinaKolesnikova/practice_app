import 'package:fluttertoast/fluttertoast.dart';

//return message
returnToast(String message, String place){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: place=='CENTER'?ToastGravity.CENTER:ToastGravity.BOTTOM);
}
