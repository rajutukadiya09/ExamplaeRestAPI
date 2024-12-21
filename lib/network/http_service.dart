import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/instance_manager.dart';
import '../enum/Method.dart';

// Define the base URL for API requests
const url = "";
const baseUrl = url;

class HttpService {
  Dio? _dio; // Dio instance for HTTP requests
  var i = 1; // An unused variable, consider removing if not needed
  var paging = true; // An unused variable, consider removing if not needed

  // Method to provide default headers for API requests
  static Map<String, String> header() => {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      };

  // Initialize Dio instance and set up interceptors
  HttpService init() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ));
    initInterceptors(); // Set up request/response interceptors
    return this;
  }

  // Set up interceptors for logging and handling responses/errors
  void initInterceptors() {
    _dio!.interceptors.addAll([
      InterceptorsWrapper(
        onResponse: (response, handler) {
          print(
              "RESPONSE[${response.statusCode}] => RES DATA: ${response.data}");
          return handler.next(response); // Pass response to next handler
        },
        onError: (err, handler) {
          print("Error[${err.response?.statusCode}]");
          return handler.next(err); // Pass error to next handler
        },
      ),
      LogInterceptor(requestBody: true), // Log request and response data
    ]);
  }

  // Method for handling multipart requests
  Future<dynamic> requestMultipart({
    required String url,
    required Method method,
    FormData? param,
  }) async {
    Response response;

    try {
      // Perform HTTP POST request with multipart data
      response = await _dio!.post(url, data: param);

      // Check response status and handle accordingly
      if (response.statusCode == 200) {
        var res = response.data as Map<String, dynamic>;
        if (res.containsKey('errors')) {
          throw Exception("API returned errors");
        } else {
          return res;
        }
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something went wrong");
      }
    } on SocketException {
      throw Exception("No Internet Connection");
    } on FormatException {
      throw Exception("Bad response format");
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  // Method for handling various types of API requests
  Future<dynamic> request({
    required String url,
    required Method method,
    Map<String, dynamic>? params,
    Map<String, dynamic>? qParams,
    String? token,
  }) async {
    Response response;

    try {
      // Add the token header if provided
      final headers = token != null ? {'token': token} : null;

      // Perform HTTP request based on the method
      switch (method) {
        case Method.post:
          response = await _dio!.post(url,
              data: params,
              queryParameters: qParams,
              options: Options(headers: headers));
          break;
        case Method.delete:
          response =
              await _dio!.delete(url, options: Options(headers: headers));
          break;
        case Method.patch:
          response = await _dio!.patch(url, options: Options(headers: headers));
          break;
        case Method.get:
        default:
          response = await _dio!.get(url,
              queryParameters: params, options: Options(headers: headers));
          break;
      }

      // Check response status and handle accordingly
      if (response.statusCode == 200) {
        var res = response.data as Map<String, dynamic>;
        return res;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something went wrong");
      }
    } on SocketException {
      // Handle no internet connection
      // Helper().noInternetSnackBar();
      throw Exception("No Internet Connection");
    } on FormatException {
      throw Exception("Bad response format");
    } on DioException catch (e) {
      throw Exception(e.message);
    } on Error catch (err) {
      Get.showSnackbar(GetSnackBar(
        message: err.toString(),
        duration: const Duration(seconds: 3),
      ));
      throw Exception("An error occurred");
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }
}
