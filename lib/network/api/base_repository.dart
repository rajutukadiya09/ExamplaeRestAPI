import 'package:get/get.dart';
import '../../utils/api_constant.dart';
import '../../utils/constant.dart';
import '../../utils/utility.dart';
import '../model/api_response_model.dart';
import '../model/result_model.dart';
import 'api_base_helper.dart';

/// A base repository class to handle API calls and manage responses.
class BaseRepository {
  /// Makes an API call using the provided endpoint and request parameters.
  ///
  /// [request] is a map containing request parameters.
  /// [apiEndPoint] is the specific API endpoint to call.
  Future<ResultModel> baseRepositoryApiCall({
    Map<String, dynamic>? request,
    required String apiEndPoint,
    String? rawvalue
  }) async {
    try {
      // Make the API call
      final ApiResponseModel model = await ApiBaseHelper().post(
        api: apiEndPoint,
        baseUrl: ApiKeys.baseUrl,
        params: request, rawdata: rawvalue
      );

      if (model.success) {
        return ResultModel(
          success: true,
          result: model.apiResponse,
          message: "",
        );
      }
      else
        {
          return const ResultModel(
            success: false,
            result: "",
            message: "",
          );
        }

    } catch (e) {
      // Log and handle unexpected errors
      showLog('Error in Repository calling Api: ${e.toString()}');
      return const ResultModel(
        success: false,
        message: msgSomethingWentWrong,
      );
    }
  }
  Future<ResultModel> baseRepositoryApiCallGet({
    Map<String, dynamic>? request,
    required String apiEndPoint,
    String? rawvalue
  }) async {
    try {
      // Make the API call
      final ApiResponseModel model = await ApiBaseHelper().get(
          api: apiEndPoint,
          baseUrl: ApiKeys.baseUrl,
          params: request, rawdata: rawvalue
      );

      if (model.success) {
        return ResultModel(
          success: true,
          result: model.apiResponse,
          message: "",
        );
      }
      else
      {
        return const ResultModel(
          success: false,
          result: "",
          message: "",
        );
      }

    } catch (e) {
      // Log and handle unexpected errors
      showLog('Error in Repository calling Api: ${e.toString()}');
      return const ResultModel(
        success: false,
        message: msgSomethingWentWrong,
      );
    }
  }
}
