import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';

class AuthController {
  static String _accessTokenKey = 'token';
  static String _userModelKey = 'user-data';
  static String? accessToken;
  static UserModel? userModel;
  static String? password;


  static Future saveUserData(UserModel model, String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(
      _userModelKey,
      jsonEncode(model.toJson()),
    );
    accessToken = token;
    userModel = model;
    password = model.password;
  }



  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);

    if (token != null) {
      accessToken = token;
      String? userData = sharedPreferences.getString(_userModelKey);

      if (userData != null && userData.isNotEmpty) {
        try {
          userModel = UserModel.fromJson(jsonDecode(userData));
          fullName = '${userModel?.firstName} ${userModel?.lastName}';
          email = userModel?.email;
          mobile = userModel?.mobile;


          if (userModel?.photo != null &&
              userModel!.photo!.isNotEmpty &&
              userModel!.photo!.trim() != '""' &&
              userModel!.photo!.trim() != 'null' &&
              userModel!.photo!.startsWith('http')) {
            userPhoto = userModel!.photo;
          } else {
            userPhoto = null;
          }

          print('Loaded user photo: $userPhoto');
        } catch (e) {
          print('Error parsing user data: $e');
        }
      }
    }
  }

  static Future<bool> isUserLoggedIn()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    return token != null;

  }

  static Future<void> clearUserData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  static Future<void> updateProfileImage(String imageUrl) async {
    userPhoto = imageUrl;


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (userModel != null) {
      userModel = UserModel(
        id: userModel!.id,
        firstName: userModel!.firstName,
        lastName: userModel!.lastName,
        email: userModel!.email,
        mobile: userModel!.mobile,
        photo: imageUrl,
        password: userModel!.password,
      );

      await sharedPreferences.setString(
        _userModelKey,
        jsonEncode(userModel!.toJson()),
      );
    }
  }



  static String? fullName;
  static String? email;
  static String? userPhoto;
  static String? mobile;



  static Future<void> saveUserProfileData(Map<String, dynamic> data) async {
    try {
      fullName = '${data['firstName']?.toString() ?? ''} ${data['lastName']?.toString() ?? ''}'.trim();
      email = data['email']?.toString();
      mobile = data['mobile']?.toString();


      if (data.containsKey('photo') &&
          data['photo'] != null &&
          data['photo'].toString().isNotEmpty &&
          data['photo'].toString() != 'null' &&
          data['photo'].toString() != '""') {

        final photoUrl = data['photo'].toString();
        if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
          userPhoto = photoUrl;
          print('Photo URL saved to AuthController: $userPhoto');
        } else {
          userPhoto = null;
          print('Invalid photo URL format: $photoUrl');
        }
      } else {
        userPhoto = null;
        print('No valid photo in profile data');
      }

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


      if (userModel != null) {
        userModel = UserModel(
          id : data['_id'] ?? userModel!.id,
          firstName: data['firstName']?.toString() ?? userModel!.firstName,
          lastName: data['lastName']?.toString() ?? userModel!.lastName,
          email: data['email']?.toString() ?? userModel!.email,
          mobile: data['mobile']?.toString() ?? userModel!.mobile,
          photo: userPhoto!,
          password: userModel!.password, // পাসওয়ার্ড আগেরটা রাখুন
        );

        await sharedPreferences.setString(
          _userModelKey,
          jsonEncode(userModel!.toJson()),
        );
      } else {
        print('userModel is null, cannot save to SharedPreferences');
      }
    } catch (e) {
      print('Error in saveUserProfileData: $e');
    }
  }

}
