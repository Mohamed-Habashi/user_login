class UserModel{
  String?name;
  String?phone;
  String?email;
  String?image;
  String? uId;

  UserModel({
   required this.name,
   required this.phone,
   required this.image,
   required this.email,
   required this.uId,
});

  UserModel.fromJson(Map<String,dynamic>json){
    name=json['name'];
    phone=json['phone'];
    image=json['image'];
    email=json['email'];
    uId=json['uId'];
  }

  Map<String,dynamic>toMap(){
    return {
      'name':name,
      'email':email,
      'image':image,
      'phone':phone,
      'uId':uId,
  };
}
}

