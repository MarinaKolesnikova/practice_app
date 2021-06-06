
// import 'package:pract_app/services/database_provider.dart';
//
// class ProductModel {
//   int id;
//   String title;
//   String description;
//   String photo;
//
//   ProductModel({required this.id, required this.title,
//     required this.description, required this.photo});
//
//   Map<String, dynamic> toMap() {
//     var map = <String, dynamic>{
//       DatabaseProvider.COLUMN_ID: id,
//       DatabaseProvider.COLUMN_TITLE: title,
//       DatabaseProvider.COLUMN_DESCRIPTION: description,
//       DatabaseProvider.COLUMN_PHOTO: photo
//     };
//
//     if (id.isFinite) {
//       map[DatabaseProvider.COLUMN_ID] = id;
//     }
//     return map;
//   }
//
//   factory ProductModel.fromMap(Map<String, dynamic> map){
//     return ProductModel(
//         id: map[DatabaseProvider.COLUMN_ID],
//         title: map[DatabaseProvider.COLUMN_TITLE],
//         description: map[DatabaseProvider.COLUMN_DESCRIPTION],
//         photo: map[DatabaseProvider.COLUMN_PHOTO]);
//   }
// }