import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:pract_app/pages/auxilary/toastMessage.dart';
import 'package:pract_app/services/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:pract_app/pages/detailPage/details.dart';
import 'package:pract_app/services/Api_product.dart';
import 'package:dio/dio.dart';

class productItem extends StatefulWidget{
  @override
  final bool isAut;
  final ApiProduct content;
  final bool connection;
  final void Function() parentAction;
  const productItem(
      {Key? key, required this.content, required this.isAut, required this.connection, required this.parentAction}
      ):super(key: key);
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<productItem>{
  @override
  Widget build(BuildContext context) {
    final bool isAut = widget.isAut;
    final ApiProduct content= widget.content;
    final bool connection = widget.connection;

  return
    FutureBuilder(
        future:DatabaseProvider.db.isExist(content.id),
        builder:(BuildContext context, AsyncSnapshot<ApiProduct> snapshot) {
          if(snapshot.hasData){
            ApiProduct? savedProduct=snapshot.data;
            bool fromSavedData=false;
              if(savedProduct!.id==0){
              fromSavedData = false;}
            else {fromSavedData = true;}
            print(fromSavedData.toString() + 'here');
            return GestureDetector(
                onTap:(){ Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Details(
                      content:content,
                      isAuth: isAut==true?true: false,
                      refresh:  widget.parentAction,
                    )),
                );
                print(connection.toString()+' con');},
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                         child:
                         Container(
                             padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.7),
                                    blurRadius: 8.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.1, 0.5)
                                ),
                              ],
                            ),
                           child:Stack(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 9),
                                    child: Align(
                                        alignment:Alignment.center,
                                        child:Hero(
                                          tag: "${content.id}",
                                          child:  fromSavedData==true&&connection==false? Image.file(File(savedProduct.img)) :
                                               Image.network('http://smktesting.herokuapp.com/static/'+content.img),
                                        ))),
                                    if(isAut==true) Align(
                                    alignment:Alignment.topRight,
                                    child:
                                    Container(
                                    width: 50.0,
                                    height: 50.0,
                                    margin: EdgeInsets.only(bottom:20),
                                    decoration: new BoxDecoration(
                                      color: Colors.black87,
                                      border: Border.all(),
                                      shape: BoxShape.circle,),
                                        child:
                                        savedProduct.id==0? IconButton(
                                            icon: Icon(Icons.save_alt_rounded, color:Colors.white),
                                            onPressed: ()async {
                                              if(connection){
                                              try {
                                                var status = await Permission.storage.status;
                                                print(status);

                                                if (await Permission.storage.request().isGranted) {
                                                  var response;
                                                  response= await Dio().get(
                                                      "http://smktesting.herokuapp.com/static/"+content.img,
                                                      options: Options(responseType: ResponseType.bytes));
                                                  final result = await ImageGallerySaver.saveImage(
                                                      Uint8List.fromList(response.data),
                                                      quality: 100,
                                                      name: content.img);
                                                  print(result);
                                                  print(result['filePath'].toString().replaceFirst('file://',''));
                                                  if(result['isSuccess']==true){
                                                    ApiProduct product = new ApiProduct(
                                                        id: content.id,
                                                        title: content.title,
                                                        text: content.text,
                                                        img: result['filePath'].toString().replaceFirst('file://','') );
                                                    DatabaseProvider.db.insert(product);
                                                  }
                                                  setState(() {
                                                  });
                                                }
                                                else{
                                                  print('permission denied');
                                                }
                                              }
                                              catch (E) {
                                                print(E);
                                                returnToast("Error!","CENTER");}
                                              }
                                            }
                                        )
                                        : IconButton(
                                            icon: Icon(Icons.delete_outline, color:Colors.white),
                                            onPressed: ()async{
                                              try {
                                                DatabaseProvider.db.delete(savedProduct.id);
                                                File img = await File(savedProduct.img);
                                                img.deleteSync(recursive: false);
                                                setState(() {
                                                  widget.parentAction();
                                                });
                                               }
                                              catch(E){
                                                print (E.toString());
                                              }}
                                        )
                                    ),
                                    )]
                           ),
                         ),
                    ),

                            Center(child:
                                  Container(
                                    width:  double.maxFinite,
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                    ),
                                      child: Text(
                                        content.title,
                                        textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                      ),
                                  ),
                            ),
                  ],
                )
            );
          }
          else{
            return Center(child:CircularProgressIndicator());
          }
        }
        );
  }}