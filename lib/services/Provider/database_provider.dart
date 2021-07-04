import 'package:pract_app/services/Models/Api_product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';


class DatabaseProvider{
  static const String TABLE_PRODUCT ="product";
  static const String COLUMN_ID ="id";
  static const String COLUMN_TITLE ="title";
  static const String COLUMN_DESCRIPTION ="description";
  static const String COLUMN_PHOTO ="photo";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  late Database _database;
  bool _isInitialized = false;
  Future<Database> get database async {
    print("Database getter called");
    if(_isInitialized){
      print(_isInitialized);
      return _database;
    }
    _database = await createDatabase();
    _isInitialized=true;
    return _database;
}
  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'productDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating product table");

        await database.execute(
          "CREATE TABLE $TABLE_PRODUCT("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$COLUMN_TITLE TEXT,"
              "$COLUMN_DESCRIPTION TEXT,"
              "$COLUMN_PHOTO TEXT )"
        );
      },
    );
  }

  Future<List<ApiProduct>> getProducts() async {
    final db = await database;
    var products = await db
        .query(TABLE_PRODUCT,
        columns: [COLUMN_ID, COLUMN_TITLE, COLUMN_DESCRIPTION, COLUMN_PHOTO]);

    List<ApiProduct> productList = [];

    products.forEach((currentProduct) {
      ApiProduct product = ApiProduct.fromMap(currentProduct);
      productList.add(product);
    });
    return productList;
  }

  Future<ApiProduct> isExist(int id) async{
    final db = await database;
    ApiProduct product = new ApiProduct(id: 0, img: '', text: '', title: '');
    try{
      var items = await db.rawQuery("SELECT * FROM $TABLE_PRODUCT WHERE $COLUMN_ID=$id");
      items.forEach((currentProduct) {
        product = new ApiProduct.fromMap(currentProduct);}
      );
      return product;
    }
        catch(E){
          print(E.toString()+" was caught in isExist/database_provider");
          return product;
        }
  }

  Future<ApiProduct> insert(ApiProduct product) async {
    final db = await database;
    try{
    product.id = await db.insert(
      TABLE_PRODUCT,
      product.toMap()
    );}
    catch(E){
      print(E.toString()+" was caught in insert/database_provider");
    }
    return product;
  }

  Future<int> delete(int id) async {
    final db = await database;
    try{
    return await db.delete(
      TABLE_PRODUCT,
      where: "id = ?",
      whereArgs: [id],
    );}
    catch(E){
     print(E.toString()+"was caught in delete/database_provider");
     return 0;
}
  }

  Future<int> update(ApiProduct product) async {
    final db = await database;
    try{
    return await db.update(
      TABLE_PRODUCT,
      product.toMap(),
      where: "id = ?",
      whereArgs: [product.id],
    );}
    catch(E){
      print(E.toString()+"was caught in update/database_provider");
      return 0;
    }
  }

  void destroyDB() async{
    try{
    var databasesPath = await getDatabasesPath();
    _isInitialized=false;
    String path = join(databasesPath, 'productDB.db');
    await deleteDatabase(path);
    print('DB was deleted');}
    catch(E){
      print(E.toString()+"was caught in destroyDB/database_provider");
    }
  }
}

