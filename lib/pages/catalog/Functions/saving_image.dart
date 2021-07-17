import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pract_app/pages/auxiliary/Functions/toast_message.dart';
import 'package:pract_app/services/Models/api_product.dart';
import 'package:pract_app/services/Provider/database_provider.dart';

void saving_image (ApiProduct content, bool connection, Function() refreshItem, Function() refreshCatalog) async{
  if(connection){
    print(connection);
    try {
      var status = await Permission.storage.status;
      if (await Permission.storage.request().isGranted) {
        var response;
        //var content;
        response= await Dio().get(
            "http://smktesting.herokuapp.com/static/"+content.img,
            options: Options(responseType: ResponseType.bytes));
        final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data),
            quality: 100,
            name: content.img);
        if(result['isSuccess']==true){
          ApiProduct product = new ApiProduct(
              id: content.id,
              title: content.title,
              text: content.text,
              img: result['filePath'].toString().replaceFirst('file://','') );
           DatabaseProvider.db.insert(product);
        await  refreshItem();
        }
      }}
        catch(e){
          print(e);
          returnToast("Error!","CENTER");
          refreshCatalog();}
        }
}