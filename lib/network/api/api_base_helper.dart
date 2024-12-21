import 'dart:io';

import 'package:dio/dio.dart';

import '../../utils/constant.dart';
import '../../utils/utility.dart';
import '../model/api_response_model.dart';

/// A helper class for making API calls using the Dio package.
class ApiBaseHelper {
  /// Makes a POST request to the specified API endpoint.
  ///
  /// [baseUrl] is the base URL of the API.
  /// [api] is the specific API endpoint.
  /// [params] are the parameters to be sent in the request body.
  Future<ApiResponseModel> post({
    required String baseUrl,
    required String api,
      Map<String, dynamic>? params,
      String? rawdata}) async {
    try {
      // Logging the request URL and parameters
      showLog('URL:: $baseUrl/$api');
      showLog('REQUEST:: ${params.toString()}');
      showLog('rawdata:: ${rawdata.toString()}');
      if (rawdata!.isNotEmpty) {
        Response<dynamic> response = await Dio().post('$baseUrl/$api',
            options: Options(headers: params), data: rawdata);

        print('response--->$response');

        if (response.statusCode == 200) {
          return ApiResponseModel(
            success: true,
            apiResponse: response.toString(),
          );
        } else {
          return ApiResponseModel(
            success: false,
            apiResponse: "",
          );
        }
      } else {
        Response<dynamic> response = await Dio().get(
          '$baseUrl/$api',
          options: Options(headers: params),
        );
        if (response.statusCode == 200) {
          return ApiResponseModel(
            success: true,
            apiResponse: response,
          );
        } else {
          return ApiResponseModel(
            success: false,
            apiResponse: "",
          );
        }
      }

    } on SocketException {
      // Handle no internet connection
      showLog('Error: No Internet connection');
      return ApiResponseModel(
        success: false,
        error: msgNoInternet,
      );
    } on DioException catch (e) {
      // Handle Dio exceptions
      showLog(
          'DioException caught: ${e.response?.data ?? e.message ?? e.toString()}');
      return dioErrorMsg(e);
    } catch (e) {
      // Handle all other exceptions
      showLog('Error in Calling (API) $api: ${e.toString()}');
      return ApiResponseModel(
        success: false,
        error: msgSomethingWentWrong,
      );
    }
  }
  Future<ApiResponseModel> get({
    required String baseUrl,
    required String api,
    Map<String, dynamic>? params,
    String? rawdata}) async {
    try {
      // Logging the request URL and parameters
      showLog('URL:: $baseUrl/$api');
      showLog('REQUEST:: ${params.toString()}');
      showLog('rawdata:: ${rawdata.toString()}');
      if (rawdata!.isNotEmpty) {
        Response<dynamic> response = await Dio().get('$baseUrl/$api',
            options: Options(headers: params), data: rawdata);

        print('response--->$response');

        if (response.statusCode == 200) {
          return ApiResponseModel(
            success: true,
            apiResponse: response.toString(),
          );
        } else {
          return ApiResponseModel(
            success: false,
            apiResponse: "",
          );
        }
      } else {
        Response<dynamic> response = await Dio().get(
          '$baseUrl/$api',
          options: Options(headers: params),
        );
        if (response.statusCode == 200) {
          return ApiResponseModel(
            success: true,
            apiResponse: response,
          );
        } else {
          return ApiResponseModel(
            success: false,
            apiResponse: "",
          );
        }
      }

    } on SocketException {
      // Handle no internet connection
      showLog('Error: No Internet connection');
      return ApiResponseModel(
        success: false,
        error: msgNoInternet,
      );
    } on DioException catch (e) {
      // Handle Dio exceptions
      showLog(
          'DioException caught: ${e.response?.data ?? e.message ?? e.toString()}');
      return dioErrorMsg(e);
    } catch (e) {
      // Handle all other exceptions
      showLog('Error in Calling (API) $api: ${e.toString()}');
      return ApiResponseModel(
        success: false,
        error: msgSomethingWentWrong,
      );
    }
  }

  /// Makes a POST request to a payment-related API endpoint.
  ///
  /// [api] is the specific API endpoint.
  /// [params] are the parameters to be sent in the request body.
  Future<Map<String, dynamic>> postPaymentApi({
    required String api,
    Map<String, dynamic>? params,
  }) async {
    try {
      // Logging the request parameters
      showLog('REQUEST:: ${params.toString()}');

      // Prepare headers
      final Map<String, String> headers = <String, String>{
        'Content-type': 'application/json',
      };

      // Make the POST request
      final Response<dynamic> response = await Dio().post(
        api,
        options: Options(headers: headers),
        data: params,
      );

      // Ensure response data is valid
      if (response.data == null) {
        throw Exception("Response data is null");
      }
      if (response.data is! Map<String, dynamic>) {
        throw Exception("Unexpected response data type");
      }

      // Parse response data
      final Map<String, dynamic> responseJson =
          response.data as Map<String, dynamic>;
      showLog('RESPONSE:: ${response.data}');
      return responseJson;
    } on SocketException {
      // Handle no internet connection
      showLog('Error: No Internet connection');
      throw Exception(msgNoInternet);
    } on DioException catch (e) {
      // Handle Dio exceptions
      showLog(
          'DioException caught: ${e.response?.data ?? e.message ?? e.toString()}');
      throw Exception(e.message ?? msgSomethingWentWrong);
    } catch (e) {
      // Handle all other exceptions
      showLog('Error in Calling (API) $api: ${e.toString()}');
      throw Exception(msgSomethingWentWrong);
    }
  }

  /// Returns an appropriate error message based on the DioException.
  ///
  /// [e] is the DioException that occurred.
  ApiResponseModel dioErrorMsg(DioException e) {
    if (e.response != null) {
      // Log the response data for debugging
      showLog('DioException response: ${e.response!.data}');

      // Map HTTP status codes to error messages
      switch (e.response!.statusCode) {
        case 403:
          return ApiResponseModel(
            success: false,
            error: msgUnauthorised,
          );
        case 400:
          return ApiResponseModel(
            success: false,
            error: msgInvalidRequest + (e.response!.statusMessage ?? ''),
          );
        case 500:
          return ApiResponseModel(
            success: false,
            error: msgInternalServerError + (e.response!.statusMessage ?? ''),
          );
        case 404:
          return ApiResponseModel(
            success: false,
            error: msgPageNotFound,
          );
        default:
          return ApiResponseModel(
            success: false,
            error: msgSomethingWentWrong,
          );
      }
    } else {
      // Handle cases where there is no response
      showLog(
          'Error in api call (base_helper) : ${e.message ?? "Unknown error"}');
      return ApiResponseModel(
        success: false,
        error: msgSomethingWentWrong,
      );
    }
  }
}
