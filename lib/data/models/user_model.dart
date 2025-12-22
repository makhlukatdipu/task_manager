
class UserModel{
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;
  final String photo;
  final String password;


  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.photo,
    required this.password,

  });

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? photo,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      photo: photo ?? this.photo,
      password: password ?? this.password,
    );
  }

 factory UserModel.fromJson(Map<String,dynamic> jsonData){
   return UserModel(
      id: jsonData['_id'],
       email: jsonData['email'] ?? '',
       firstName: jsonData['firstName'] ?? '',
       lastName: jsonData['lastName'] ?? '',
       mobile: jsonData['mobile'] ?? '',
       photo: jsonData['photo'] ?? '',
       password: jsonData['password'] ?? '',
   );
 }

 Map<String,dynamic> toJson(){
   return {
     "_id": id,
     "email":email,
     "firstName":firstName,
     "lastName":lastName,
     "mobile":mobile,
     'photo': photo,
     'password': password,
   };
 }


}