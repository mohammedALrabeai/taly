
class MyOrder{
 var t= """ CREATE TABLE  order(
 id INTEGER AUTO_INCREMENT [PRIMARY KEY],
      id_rest TEXT,rest_name TEXT,id_food TEXT, food_name TEXT , size_id TEXT, 
      size_name TEXT,total TEXT,color_id TEXT, color_name TEXT,
      part_id TEXT, part_name TEXT,  much TEXT, price TEXT, url TEXT)""";
     int id;
     String id_rest;
     String rest_name;
     String id_food;
     String food_name;
     String size_id;
     String size_name;
     String total;
     String color_id;
     String color_name;
     String part_id;
     String part_name;
     String much;
     String price;
     String url;

  bool withcook=false;
  num cook_price=0.0;

 MyOrder(  {
      this.id,
      this.id_rest,
      this.rest_name,
      this.id_food,
      this.food_name,
      this.size_id,
      this.size_name,
      this.total,
      this.color_id,
      this.color_name,
      this.part_id,
      this.part_name,
      this.much,
      this.price,
      this.url});
 Map<String, dynamic> toJson() => {
   "id": id == null ? null : id,
   "id_rest": id_rest == null ? null : id_rest,
   "rest_name": rest_name == null ? null : rest_name,
   "id_food": id_food == null ? null : id_food,
   "food_name": food_name == null ? null : food_name,
   "size_id": size_id == null ? null : size_id,
   "size_name": size_name == null ? null : size_name,
   "total": total == null ? null : total,
   "color_id": color_id == null ? null : color_id,
   "color_name": color_name == null ? null : color_name,
   "part_id": part_id == null ? null : part_id,
   "part_name": part_name == null ? null : part_name,
   "much": much == null ? null : much,
   "price": price == null ? null : price,
   "url": url == null ? null : url,
 };
   factory MyOrder.fromJson(Map<String, dynamic> json) => MyOrder(
     id: json["id"] == null ? null : int.parse(json["id"].toString()),
     id_rest: json["id_rest"] == null ? null : json["id_rest"].toString(),
     rest_name: json["rest_name"] == null ? null : json["rest_name"].toString(),
     id_food: json["id_food"] == null ? null : json["id_food"].toString(),
     food_name: json["food_name"] == null ? null : json["food_name"].toString(),
     size_id: json["size_id"] == null ? null : json["size_id"].toString(),
     size_name: json["size_name"] == null ? null : json["size_name"].toString(),
     total: json["total"] == null ? null : json["total"].toString(),
     color_id: json["color_id"] == null ? null : json["color_id"].toString(),
     color_name: json["color_name"] == null ? null : json["color_name"].toString(),
     part_id: json["part_id"] == null ? null : json["part_id"].toString(),
     part_name: json["part_name"] == null ? null : json["part_name"].toString(),
     much: json["much"] == null ? null : json["much"].toString(),
     price: json["price"] == null ? null : json["price"].toString(),
     url: json["url"] == null ? null : json["url"].toString(),
   );









}