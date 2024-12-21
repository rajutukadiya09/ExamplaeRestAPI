import '../../utils/api_constant.dart';

/// Represents a general API response model.
class ApiResponseModel {
  /// Constructor for initializing ApiResponseModel with success flag, optional response, and optional error message.
  ApiResponseModel({
    required this.success,
    this.apiResponse,
    this.error = '',
  });

  /// Indicates whether the API call was successful.
  final bool success;

  /// Holds the response data if the API call was successful.
  final dynamic apiResponse;

  /// Contains an error message if the API call failed.
  final String error;
}

/// Represents the structure of a typical JSON-RPC response.
class ResponseDto {
  /// Constructor for initializing ResponseDto with optional fields.
  ResponseDto({
    this.jsonrpc,
    this.id,
    this.result,
    this.error,
  });

  /// Factory constructor for creating an instance from a JSON map.
  factory ResponseDto.fromJson(Map<String, dynamic> map) {
    return ResponseDto(
      jsonrpc: map['jsonrpc'],
      id: map['id'] == null ? '' : map['id'].toString(),
      result: map[ApiKeys.keyResult],
      error: map["error"] == null ? null : ErrorModel.fromJson(map["error"]),
    );
  }

  /// JSON-RPC version used in the response.
  final String? jsonrpc;

  /// Identifier for the request, if applicable.
  final String? id;

  /// Contains the result of the API call if successful.
  final dynamic result;

  /// Contains error details if the API call failed.
  final ErrorModel? error;
}

/// Represents an error model with details about the error.
class ErrorModel {
  /// Constructor for initializing ErrorModel with code, message, and optional data.
  ErrorModel({
    required this.code,
    required this.message,
    required this.data,
  });

  /// Factory constructor for creating an instance from a JSON map.
  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        code: json["code"],
        message: json["message"],
        data: json["data"],
      );

  /// Error code representing the type of error.
  final int code;

  /// Error message describing the error.
  final String message;

  /// Additional data related to the error, if any.
  final dynamic data;
}

/// Represents a result DTO that includes result data, message, status, and other relevant information.
class ResultDto {
  /// Constructor for initializing ResultDto with optional result, message, data, and status.
  ResultDto({
    this.result,
    this.message,
    this.data,
    this.status,
  });

  /// Factory constructor for creating an instance from a JSON map.
  factory ResultDto.fromJson(Map<String, dynamic> map) {
    return ResultDto(
      result: map['result'],
      status: map['status'],
      message: map['message'] == null ? '' : map['message'].toString(),
      data: map['data'],
    );
  }

  /// Contains the result of the API call.
  final String? result;

  /// Message associated with the result, if any.
  final String? message;

  /// Additional data related to the result.
  final dynamic data;

  /// Status of the result, if applicable.
  final String? status;
}
