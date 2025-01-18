class ProductModel {
 int id;
String title;
dynamic price;
String description;
String? image;
RatingModel rating;

ProductModel({

  required this.id,
  required this.title,
  required this.price,
  required this.description,
  required this.image,
  required this.rating,

});


factory ProductModel .fromJson(Map<String,dynamic>json)=>ProductModel(
  id :json['id'],
  title : json['title'],
  price : json['price'],
  description : json['description'],
  image : json['image'],
  rating: RatingModel.fromJson( json['rating']),
);

}


class RatingModel{
  dynamic rate;
  int count;
  RatingModel({
    required this.rate,
    required this.count,
});
  factory RatingModel.fromJson(Map<String,dynamic>json)=>RatingModel(
    rate :json['rate'],
    count : json['count'],
  );




}