class UserModel{

  String name ;
  String email;
  String uId;
  String image;
  String wallet;


  UserModel({
    required this.name,
    required this.email,
    required this.uId,
    required this.wallet,
    required this.image,
  });

  factory UserModel.fromJson(Map<String,dynamic>json)=>UserModel(
    name: json['name']??'',
    email: json['email']??'',
    uId: json['uId']??'',
    wallet: json['wallet']??'0' ,
    image: json['image']??'https://icons.veryicon.com/png/o/miscellaneous/graph-library/person-liable-1.png',
  );


  UserModel copyWith({
    String? name,
    String? email,
    String? uId,
    String? image,
    String? wallet,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      uId: uId ?? this.uId,
      wallet: wallet ?? this.wallet,
      image: image ?? this.image,
    );
  }



  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'email':email,
      'uId':uId,
      'wallet':wallet,
      'image':image,
    };
  }


}