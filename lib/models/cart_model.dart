class CartModel{

  String? image;
  String? name;
  String? id;
  int quantity;
  double price;
  double total;
  String dateTime;


  CartModel({
    required this.image,
    required this.name,
    required this.id,
    required this.quantity,
    required this.dateTime,
    required this.price,
    required this.total,
  });

  factory CartModel.fromJson(Map<String,dynamic>json)=>CartModel(
    image: json['image'],
    name: json['name'],
    id: json['id'],
    quantity: json['quantity'] ?? 1,
    dateTime: json['dateTime'],
    price: json['price'],
    total: json['total'],
  );


  Map<String,dynamic> toMap(){
    return {
      'image':image,
      'name':name,
      'id':id,
      'quantity':quantity,
      'price':price,
      'dateTime':dateTime,
      'total':total,
    };
  }


}