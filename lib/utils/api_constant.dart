/// A class containing constant values for API endpoints and related keys.
/// Use this class to manage all API-related constants in one place.
class ApiKeys {
  /// Base URL for the API.
  // static const String baseUrl = ''; // Production
  // static const String baseUrl = ''; // Staging
  static const String baseUrl = 'http://52.205.105.138:12445';

  // Endpoints
  /// Endpoint for loading the list of databases.
  static const String sluDbLoad = 'mobile/database/list';

  /// Endpoint for fetching towing accounts.
  static const String towFetchAccount = 'towing-accounts/fetch';

  /// Endpoint for fetching types of towing.
  static const String towFetchTowingType = 'tow-dispatch-type/fetch';

  /// Endpoint for user login authentication.
  static const String login = 'login';

  static const String loggedOut = 'web/mobile/session/destroy';

  static const String download = '/download/';

  /// Endpoint for saving Firebase device token.
  static const String sendDeviceToken = 'firebase/token/save';

  /// Endpoint for uploading images related to towing dispatch.
  static const String uploadImage = 'tow-dispatch/image/upload';

  /// Endpoint for creating a new towing record.
  static const String createRecord = 'tow-dispatch/create';

  /// Endpoint for fetching dashboard data.
  static const String loadDashboardData = 'getFileData';

  /// Endpoint for fetching Thumbnail data.
  static const String loadThumbnailData = 'get_thumbnail';

  /// Endpoint for fetching Thumbnail data.
  static const String donwloadFile = 'download';

  /// Endpoint for fetching Thumbnail data.
  static const String donwloadStreamFile = 'stream_download';

  /// Endpoint for fetching dashboard data.
  static const String loadprotecation = 'update_File_info';

  // Response keys
  /// Key used in responses to indicate success.
  static const String keySuccess = 'success';

  /// Key used in responses to hold result data.
  static const String keyResult = 'result';

  /// Key used in responses to indicate unauthenticated access.
  static const String keyUnAuthenticate = 'unauthenticated';

  //TowTab
  static const String towDriversFetch = 'towing-drivers/fetch';
  static const String towVehicleFetch = 'fleet-vehicles/fetch';
  static const String towVehicleClassFetch = 'tow-vehicle-class/fetch';
  static const String towFacilitiesFetch = 'tow-facilities/fetch';
  static const String towingServicesFetch = 'towing-services/fetch';
  static const String towMethodsFetch = 'tow-methods/fetch';
  static const String towDispatchServerAction = 'tow-dispatch-server-actions/fetch';

  // File formats
  /// JPEG image format.
  static const String formatJPEG = 'JPEG';

  /// PNG image format.
  static const String formatPNG = 'PNG';

  /// JPG image format.
  static const String formatJPG = 'JPG';

  /// PDF document format.
  static const String formatPDF = 'PDF';
}