import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';

class ApiCaller {

  static final Logger _logger = Logger();
  static String? accessToken;
  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url);
      Response response = await get(uri,headers: {
        //'token': AuthController.accessToken ?? '',  provider
        'token': accessToken ?? '',
      });

      _logResponse(url, response);

      final int statusCode = response.statusCode;

      final decodedData = jsonDecode(response.body);

      if (statusCode == 200) {
        return ApiResponse(
          responseCode: statusCode,
          isSuccess: true,
          responseData: decodedData,
        );
      } else if(statusCode == 401){
        await _moveToLogin();
        return ApiResponse(
            responseCode: -1,
            isSuccess: false,
            responseData: null);
      }

      else {
        return ApiResponse(
          responseCode: statusCode,
          isSuccess: false,
          responseData: decodedData,
        );
      }
    } catch (e) {
      return ApiResponse(
        responseCode: -1,
        isSuccess: false,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<ApiResponse> postRequest({required String url, Map<String, dynamic>? body,}) async {

    try {
      Uri uri = Uri.parse(url);
      _logRequest(url,body: body);
      Response response = await post(uri,
      headers: {
        "Accept":"application/json",
        "Content-Type":"application/json",
        'token':


        accessToken ?? '',
      },
      body: body !=null ? jsonEncode(body) : null,
      );

      _logResponse(url, response);

      final int statusCode = response.statusCode;

      final decodedData = jsonDecode(response.body);

      if ((statusCode == 200 || statusCode == 201) &&
          decodedData['status'] == 'success') {
        return ApiResponse(
          responseCode: statusCode,
          isSuccess: true,
          responseData: decodedData,
        );
      }
      else if(statusCode == 401){
        await _moveToLogin();
        return ApiResponse(
            responseCode: -1,
            isSuccess: false,
            responseData: null);
      }
      else {
        return ApiResponse(
          responseCode: statusCode,
          isSuccess: false,
          responseData: decodedData,
        );
      }
    } catch (e) {
      return ApiResponse(
        responseCode: -1,
        isSuccess: false,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  //-----
  static Future<ApiResponse> profileUpdateMultipart({
    required String url,
    required Map<String, String> body,
    XFile? image,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, body: body);

      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'token': AuthController.accessToken ?? '',
      });

      request.fields.addAll(body);

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            image.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      final statusCode = streamedResponse.statusCode;
      final decodedData = jsonDecode(responseBody);

      _logger.i(
        'URL => $url\n'
            'Status Code => $statusCode\n'
            'Response Body => $responseBody\n',
      );

      if ((statusCode == 200 || statusCode == 201) &&
          decodedData['status'] == 'success') {
        return ApiResponse(
          responseCode: statusCode,
          isSuccess: true,
          responseData: decodedData,
        );
      } else if (statusCode == 401) {
        await _moveToLogin();
        return ApiResponse(
          responseCode: -1,
          isSuccess: false,
          responseData: null,
        );
      } else {
        return ApiResponse(
          responseCode: statusCode,
          isSuccess: false,
          responseData: decodedData,
        );
      }
    } catch (e) {
      return ApiResponse(
        responseCode: -1,
        isSuccess: false,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  //------

  static void _logRequest(String url, {Map<String, dynamic>? body}) {
    _logger.i(
      'URL => $url\n'
          'Request Body => $body\n',
    );
  }

  static void _logResponse(String url, Response response) {
    _logger.i(
      'URL => $url\n'
          'Status Code => ${response.statusCode}\n'
          'Response Body => ${response.body}\n',
    );
  }

  static Future<void> _moveToLogin()async{
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(TaskManagerApp.navigator.currentContext!, '/Login', (protected)=>false);
  }

  // api_caller.dart ফাইলে

  static Future<ApiResponse> getRequestWithoutToken({
    required String url,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url);

      Response response = await get(uri, headers: {
        "Accept": "application/json",
      });

      _logResponse(url, response);

      final int statusCode = response.statusCode;
      final decodedData = jsonDecode(response.body);

      if (statusCode == 200) {
        return ApiResponse(
          responseCode: statusCode,
          isSuccess: true,
          responseData: decodedData,
        );
      } else {
        return ApiResponse(
          responseCode: statusCode,
          isSuccess: false,
          responseData: decodedData,
          errorMessage: decodedData['message'] ?? 'Request failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        responseCode: -1,
        isSuccess: false,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  // api_caller.dart ফাইলে

  static Future<ApiResponse> postRequestWithoutToken({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, body: body);

      Response response = await post(uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          // Forget password এর জন্য token ছাড়াই
        },
        body: body != null ? jsonEncode(body) : null,
      );

      _logResponse(url, response);

      final int statusCode = response.statusCode;
      final decodedData = jsonDecode(response.body);

      if ((statusCode == 200 || statusCode == 201) &&
          decodedData['status'] == 'success') {
        return ApiResponse(
          responseCode: statusCode,
          isSuccess: true,
          responseData: decodedData,
        );
      } else {
        return ApiResponse(
          responseCode: statusCode,
          isSuccess: false,
          responseData: decodedData,
          errorMessage: decodedData['message'] ?? 'Request failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        responseCode: -1,
        isSuccess: false,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }



}


// api response

//body, status code, decode


class ApiResponse {
  final int responseCode;
  final dynamic responseData;
  final bool isSuccess;
  final String? errorMessage;

  ApiResponse({
    required this.responseCode,
    required this.isSuccess,
    required this.responseData,
    this.errorMessage = 'Something wrong',
  });
}
