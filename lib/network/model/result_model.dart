// A model to represent the result of an operation, with optional message, status, and result data.
class ResultModel {
  // Constructor with required success field and optional message, result, and status.
  const ResultModel({
    required this.success,
    this.message,
    this.result,
    this.status,  this. body,
  });

  // Fields to hold result data, success flag, and optional message and status information.
  final bool success;
  final String? message;
  final String? status;
  final dynamic result;
  final dynamic body;

  // Method to create an instance of ResultModel from a JSON object.
  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      success: json['success'],
      message: json['message'],
      result: json['result'],
      status: json['status'],
      body: json['body'],
    );
  }

  // Method to convert the ResultModel instance into a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'result': result,
      'status': status,
      'body': body,
    };
  }
}
