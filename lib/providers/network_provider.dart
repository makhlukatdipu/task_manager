import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/enums/api_state.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class NetworkProvider extends ChangeNotifier{

  ApiState _loginState = ApiState.initial;
  ApiState _registrationState = ApiState.initial;
  ApiState _profileUpdateState = ApiState.initial;

  String? _errorMessage;

  ApiState get logInState => _loginState;
  ApiState get registrationState => _registrationState;
  ApiState get profileUpdateState => _profileUpdateState;
  String? get errorMessage => _errorMessage;

  Future<Map<String,dynamic>?> logIn({
    required String email,
    required String password,
}) async{
    Map<String,dynamic> requestBody = {
      "email": email,
      "password": password,
    };
    final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.logInUrl,
      body: requestBody,

    );

    if(response.isSuccess){
      _loginState = ApiState.success;
      notifyListeners();
      return {
        'user': UserModel.fromJson(response.responseData['data']),
        'token': response.responseData['token'],
      };
    }else{
      _loginState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'Login failed';
      notifyListeners();
      return null;
    }
  }


  Future<Map<String,dynamic>?> register({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String password,
  }) async{
    _registrationState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    Map<String,dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.registrationUrl,
      body: requestBody,

    );

    if(response.isSuccess){
      _registrationState = ApiState.success;
      notifyListeners();
      return response.responseData;
    }else{
      _registrationState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'Registration failed';
      notifyListeners();
      return null;
    }
  }

  // network_provider.dart ফাইলে

  ApiState _forgetPasswordEmailVerifyState = ApiState.initial;
  ApiState get forgetPasswordEmailVerifyState => _forgetPasswordEmailVerifyState;

  // network_provider.dart ফাইলে
  Future<Map<String, dynamic>> verifyEmailForPasswordRecovery({
    required String email,
  }) async {
    _forgetPasswordEmailVerifyState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    final ApiResponse response = await ApiCaller.postRequestWithoutToken(
      url: Urls.recoverVerifyEmailUrl(email),
      body: {'email': email},
    );

    if (response.isSuccess) {
      _forgetPasswordEmailVerifyState = ApiState.success;
      notifyListeners();
      return {'success': true, 'data': response.responseData}; // ✅ Map return
    } else {
      _forgetPasswordEmailVerifyState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'Email verification failed';
      notifyListeners();
      return {'success': false, 'error': _errorMessage}; // ✅ Map return
    }
  }


  // network_provider.dart ফাইলে
  ApiState _otpVerificationState = ApiState.initial;
  ApiState get otpVerificationState => _otpVerificationState;

  Future<Map<String, dynamic>> verifyOTPForPasswordRecovery({
    required String email,
    required String otp,
  }) async {
    _otpVerificationState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    final ApiResponse response = await ApiCaller.postRequestWithoutToken(
      url: Urls.recoverVerifyOTPUrl(email, otp), // URL টা আপনার Urls ফাইলে তৈরি করুন
      body: {
        'email': email,
        'otp': otp,
      },
    );

    if (response.isSuccess) {
      _otpVerificationState = ApiState.success;
      notifyListeners();
      return {'success': true, 'data': response.responseData};
    } else {
      _otpVerificationState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'OTP verification failed';
      notifyListeners();
      return {'success': false, 'error': _errorMessage};
    }
  }

  // network_provider.dart ফাইলে
  ApiState _resetPasswordState = ApiState.initial;
  ApiState get resetPasswordState => _resetPasswordState;

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    _resetPasswordState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "OTP": otp,
      "password": password,
    };

    final ApiResponse response = await ApiCaller.postRequestWithoutToken(
      url: Urls.resetPasswordUrl, // আপনার URL যোগ করুন
      body: requestBody,
    );

    if (response.isSuccess) {
      _resetPasswordState = ApiState.success;
      notifyListeners();
      return {'success': true, 'data': response.responseData};
    } else {
      _resetPasswordState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'Password reset failed';
      notifyListeners();
      return {'success': false, 'error': _errorMessage};
    }
  }

}