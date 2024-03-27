// import 'dart:html';
import 'dart:developer';
import 'dart:io';

import '../models/address_model.dart';
// import '../models/item_cart.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/my_order_model.dart';
import '../services/auth_service.dart';

// import 'models/user.dart';

class DataBase{
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path =
    join(directory.path, 'prduct.db'); //create path to database create
    // join(directory.path, 'prduct.db'); //create path to database create

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          """CREATE TABLE cart(Id INTEGER  PRIMARY KEY ASC AUTOINCREMENT,rest_id TEXT,item_id TEXT,type TEXT,img TEXT)""");
      await db.execute(  """ CREATE TABLE  cart2(id_outo INTEGER AUTO_INCREMENT [PRIMARY KEY],name TEXT, id TEXT,type TEXT,
      cost TEXT,img TEXT,old TEXT,id_rest TEXT,description TEXT,Commodity TEXT,
      url TEXT,      size TEXT,      colore TEXT)""");
      await db.execute(  """ CREATE TABLE  cart3(id_outo INTEGER  PRIMARY KEY ASC AUTOINCREMENT,
      name TEXT, id TEXT,type TEXT,                   
      id_rest TEXT,des TEXT,cost TEXT,img TEXT,                       
      old TEXT, count TEXT)""");
      await db.execute(  """ CREATE TABLE  mylocation(id INTEGER  PRIMARY KEY ASC AUTOINCREMENT,
      address TEXT,description TEXT, latitude TEXT ,longitude TEXT, defaults TEXT,                  
       note TEXT)""");
      // await db.execute(  """ CREATE TABLE ordere(id INTEGER AUTO_INCREMENT [PRIMARY KEY],
      await db.execute(  """ CREATE TABLE ordere(id INTEGER  PRIMARY KEY ASC AUTOINCREMENT,
      id_rest TEXT,rest_name TEXT,id_food TEXT, food_name TEXT , size_id TEXT, 
      size_name TEXT,total TEXT,color_id TEXT, color_name TEXT,
      part_id TEXT, part_name TEXT,  much TEXT, price TEXT, url TEXT)""");



      // await db.execute(
      //     """CREATE TABLE wishlist(Id INTEGER AUTO_INCREMENT [PRIMARY KEY],productId INTEGER)""");
      // await db.execute(
      //     """CREATE TABLE cart(Id INTEGER AUTO_INCREMENT [PRIMARY KEY],vendorStockId INTEGER, campaignId INTEGER, quantity INTEGER)""");
      await db.close();
    }
    ,onUpgrade: (db,oldVersion,newVersion) async {
      log("Upgrading database from version " + oldVersion.toString() + " to " + newVersion.toString());
      // await db.execute(
      //   'ALTER TABLE ordere ADD COLUMN withcook TEXT DEFAULT 0, ADD COLUMN column2 INTEGER',
      // );
        });
  }

  // Future<int> saveItemCart(ItemCart item) async {
  //   var dbClient  = await init();
  //   int res = await dbClient.insert("cart", item.toMap());
  //   // print('done saveUser2(CustomD user)');
  //   return res;
  // }
  // Future<int> saveItemCart2(Clothe item) async {
  //   var dbClient  = await init();
  //   int res = await dbClient.insert("cart2", item.toJson());
  //   // print('done saveItemCart2(Clothes id: $res)');
  //   return res;
  // }
  Future<int> saveMyLocation(Address item) async {
    var dbClient  = await init();
    int res = await dbClient.insert("mylocation", item.toJson2());
    // print('done my location (Clothes id: $res)');
    return res;
  }
  Future<int> saveMyOrder(MyOrder item) async {
    var dbClient  = await init();
    // prints("${item.toJson()}");
    int res = await dbClient.insert("ordere", item.toJson());
    // print('done my location (Clothes id: $res)');
    return res;
  }
  Future<int> updateMyOrder(MyOrder item) async {
    var dbClient  = await init();
    // prints("${item.toJson()}");
    int res = await dbClient.update("ordere", item.toJson(),where: "id= ? ",whereArgs: [item.id]);
    // print('done my location (Clothes id: $res)');
    return res;
  }
  Future<MyOrder> searchItem(MyOrder item) async {
    var dbClient  = await init();
    // prints("${item.toJson()}");
    MyOrder my=MyOrder();
    int id=0;
    List<Map<String,dynamic>> res = await dbClient.query("ordere",where:"food_name= ? and part_name= ? ",whereArgs: [item.food_name,item.part_name] );
    if(res.length>0){
   my=   MyOrder.fromJson(res[0]);
      id=res[0]["id"];
    }
    // print('done my location (Clothes id: $res)');
    return my;
  }
  // Future<int> saveItemCart3(Food item) async {
  //   var dbClient  = await init();
  //   int res = await dbClient.insert("cart3", item.toJson());
  //   // print('done saveItemCart2(Clothes id: $res)');
  //   return res;
  // }
  // Future<List<ItemCart>> getItemCart() async {
  //   Database db =  await init();
  //   List<Map<String,dynamic>> todoMapList;
  //
  //   todoMapList = await db.query('cart');
  //   prints("----${todoMapList}");
  //   int count = todoMapList.length;         // Count the number of map entries in db table
  //
  //   List<ItemCart> todoList = [];
  //   // For loop to create a 'todo List' from a 'Map List'
  //   for (int i = 0; i < count; i++) {
  //     todoList.add(ItemCart.fromMap(todoMapList[i]));
  //   }
  //   print('hereeeeeeeeeeee ${todoList.toString()}');
  //   return todoList;
  // }
  // Future<List<Clothe>> getItemCart2() async {
  //   Database db =  await init();
  //   List<Map<String,dynamic>> todoMapList;
  //
  //   todoMapList = await db.query('cart2',groupBy: "id_rest");
  //   prints("----${todoMapList}");
  //   int count = todoMapList.length;         // Count the number of map entries in db table
  //
  //   List<Clothe> todoList = [];
  //   // For loop to create a 'todo List' from a 'Map List'
  //   for (int i = 0; i < count; i++) {
  //     todoList.add(Clothe.fromJson(todoMapList[i]));
  //   }
  //   // print('hereeeeeeeeeeee ${todoList.toString()}');
  //   return todoList;
  // }
  // Future<List<Food>> getItemCart3() async {
  //   Database db =  await init();
  //   List<Map<String,dynamic>> todoMapList;
  //
  //   todoMapList = await db.query('cart3',groupBy: "id_rest");
  //   prints("----${todoMapList}");
  //   int count = todoMapList.length;         // Count the number of map entries in db table
  //
  //   List<Food> todoList = [];
  //   // For loop to create a 'todo List' from a 'Map List'
  //   for (int i = 0; i < count; i++) {
  //     todoList.add(Food.fromJson(todoMapList[i]));
  //   }
  //   // print('hereeeeeeeeeeee ${todoList.toString()}');
  //   return todoList;
  // }
  Future<List<Address>> getMylocathons() async {
    Database db =  await init();
    List<Map<String,dynamic>> todoMapList;

    todoMapList = await db.query('mylocation');
    // prints("----${todoMapList}");
    int count = todoMapList.length;         // Count the number of map entries in db table

    List<Address> todoList = [];
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(Address.fromJson2(todoMapList[i]));
    }
    // print('hereeeeeeeeeeee ${todoList.toString()}');
    return todoList;
  }
  // Future<List<Clothe>> getItemCart3clothes(String id) async {
  //   Database db =  await init();
  //   List<Map<String,dynamic>> todoMapList;
  //
  //   todoMapList = await db.query('cart2',where: "id_rest=$id");
  //   // prints("----${todoMapList}");
  //   int count = todoMapList.length;         // Count the number of map entries in db table
  //
  //   List<Clothe> todoList = [];
  //   // For loop to create a 'todo List' from a 'Map List'
  //   for (int i = 0; i < count; i++) {
  //     todoList.add(Clothe.fromJson(todoMapList[i]));
  //   }
  //   // print('hereeeeeeeeeeee ${todoList.toString()}');
  //   return todoList;
  // }
  Future<List<MyOrder>> getItemMyOrder() async {
    Database db =  await init();
    List<Map<String,dynamic>> todoMapList;

    todoMapList = await db.query('ordere',groupBy: "id_rest");
    // prints("----${todoMapList}");
    int count = todoMapList.length;         // Count the number of map entries in db table

    List<MyOrder> todoList = [];
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(MyOrder.fromJson(todoMapList[i]));
    }
    //print('hereeeeeeeeeeee ${todoList.toString()}');
    return todoList;
  }
  Future<List<MyOrder>> getAllMyOrder() async {
    Database db =  await init();
    List<Map<String,dynamic>> todoMapList;

    todoMapList = await db.query('ordere');
    // prints("ppp ${todoMapList}");
    int count = todoMapList.length;         // Count the number of map entries in db table

    List<MyOrder> todoList = [];
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(MyOrder.fromJson(todoMapList[i]));
    }
    // print('hereeeeeeeeeeee ${todoList.toString()}');
    return todoList;
  }
  // Future<List<Food>> getItemCart3food(String id) async {
  //   Database db =  await init();
  //   List<Map<String,dynamic>> todoMapList;
  //
  //   todoMapList = await db.query('cart3',where: "id_rest=$id");
  //   // prints("----${todoMapList}");
  //   int count = todoMapList.length;         // Count the number of map entries in db table
  //
  //   List<Food> todoList = [];
  //   // For loop to create a 'todo List' from a 'Map List'
  //   for (int i = 0; i < count; i++) {
  //     todoList.add(Food.fromJson(todoMapList[i]));
  //   }
  //   //print('hereeeeeeeeeeee ${todoList.toString()}');
  //   return todoList;
  // }

  Future<List<MyOrder>> getItemMyOrderById(String id) async {
    Database db =  await init();
    List<Map<String,dynamic>> todoMapList;

    todoMapList = await db.query('ordere',where: "id_rest=$id");
    // prints("----${todoMapList}");
    int count = todoMapList.length;         // Count the number of map entries in db table

    List<MyOrder> todoList = [];
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(MyOrder.fromJson(todoMapList[i]));
    }
    // print('hereeeeeeeeeeee ${todoList.toString()}');
    return todoList;
  }

  // Future<int> deletCart(String id) async {
  //   Database db =  await init();
  //     int res=  await db.delete('ordere',where: "id_rest=$id");
  //     return res;
  // }
  // Future<int> deletFood(String id) async {
  //   Database db =  await init();
  //     int res=  await db.delete('ordere',where: "id=$id");
  //     return res;
  // }
  Future<int> deletAddress(String id) async {
    Database db =  await init();
      int res=  await db.delete('mylocation',where: "address='$id'");
      return res;
  }

  Future<int> deletFood(String id) async {
    Database db =  await init();
    int res=  await db.delete('ordere',where: "id=$id");
    return res;
  }

  Future<int> deletCart(String id) async {
    Database db =  await init();
    int res=  await db.delete('ordere',where: "id_rest=$id");
    return res;
  }

  // Future<List<Map<String,dynamic>>> fetchProfile() async {
  //   final db = await init();
  //   var profile = await db.query('profile');
  //   return profile;
  //
  // }




}