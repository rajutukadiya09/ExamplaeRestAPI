// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  int uid;
  bool isSystem;
  bool isAdmin;
  UserContext userContext;
  String db;
  String serverVersion;
  List<dynamic> serverVersionInfo;
  String supportUrl;
  String name;
  String username;
  String partnerDisplayName;
  int companyId;
  int partnerId;
  String webBaseUrl;
  int activeIdsLimit;
  dynamic profileSession;
  dynamic profileCollectors;
  dynamic profileParams;
  int maxFileUploadSize;
  bool homeActionId;
  CacheHashes cacheHashes;
  Currencies currencies;
  BundleParams bundleParams;
  UserCompanies userCompanies;
  bool showEffect;
  bool displaySwitchCompanyMenu;
  List<int> userId;
  int maxTimeBetweenKeysInMs;
  String notificationType;
  bool odoobotInitialized;
  bool bgColor;
  String userImage;
  String sessionSid;
  bool spiffyInstalled;
  String preventAutoSaveWarningMsg;

  LoginResponseModel({
    required this.uid,
    required this.isSystem,
    required this.isAdmin,
    required this.userContext,
    required this.db,
    required this.serverVersion,
    required this.serverVersionInfo,
    required this.supportUrl,
    required this.name,
    required this.username,
    required this.partnerDisplayName,
    required this.companyId,
    required this.partnerId,
    required this.webBaseUrl,
    required this.activeIdsLimit,
    required this.profileSession,
    required this.profileCollectors,
    required this.profileParams,
    required this.maxFileUploadSize,
    required this.homeActionId,
    required this.cacheHashes,
    required this.currencies,
    required this.bundleParams,
    required this.userCompanies,
    required this.showEffect,
    required this.displaySwitchCompanyMenu,
    required this.userId,
    required this.maxTimeBetweenKeysInMs,
    required this.notificationType,
    required this.odoobotInitialized,
    required this.bgColor,
    required this.userImage,
    required this.sessionSid,
    required this.spiffyInstalled,
    required this.preventAutoSaveWarningMsg,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    uid: json["uid"],
    isSystem: json["is_system"],
    isAdmin: json["is_admin"],
    userContext: UserContext.fromJson(json["user_context"]),
    db: json["db"],
    serverVersion: json["server_version"],
    serverVersionInfo: List<dynamic>.from(json["server_version_info"].map((x) => x)),
    supportUrl: json["support_url"],
    name: json["name"],
    username: json["username"],
    partnerDisplayName: json["partner_display_name"],
    companyId: json["company_id"],
    partnerId: json["partner_id"],
    webBaseUrl: json["web.base.url"],
    activeIdsLimit: json["active_ids_limit"],
    profileSession: json["profile_session"],
    profileCollectors: json["profile_collectors"],
    profileParams: json["profile_params"],
    maxFileUploadSize: json["max_file_upload_size"],
    homeActionId: json["home_action_id"],
    cacheHashes: CacheHashes.fromJson(json["cache_hashes"]),
    currencies: Currencies.fromJson(json["currencies"]),
    bundleParams: BundleParams.fromJson(json["bundle_params"]),
    userCompanies: UserCompanies.fromJson(json["user_companies"]),
    showEffect: json["show_effect"],
    displaySwitchCompanyMenu: json["display_switch_company_menu"],
    userId: List<int>.from(json["user_id"].map((x) => x)),
    maxTimeBetweenKeysInMs: json["max_time_between_keys_in_ms"],
    notificationType: json["notification_type"],
    odoobotInitialized: json["odoobot_initialized"],
    bgColor: json["bg_color"],
    userImage: json["user_image"],
    sessionSid: json["session_sid"],
    spiffyInstalled: json["spiffy_installed"],
    preventAutoSaveWarningMsg: json["prevent_auto_save_warning_msg"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "is_system": isSystem,
    "is_admin": isAdmin,
    "user_context": userContext.toJson(),
    "db": db,
    "server_version": serverVersion,
    "server_version_info": List<dynamic>.from(serverVersionInfo.map((x) => x)),
    "support_url": supportUrl,
    "name": name,
    "username": username,
    "partner_display_name": partnerDisplayName,
    "company_id": companyId,
    "partner_id": partnerId,
    "web.base.url": webBaseUrl,
    "active_ids_limit": activeIdsLimit,
    "profile_session": profileSession,
    "profile_collectors": profileCollectors,
    "profile_params": profileParams,
    "max_file_upload_size": maxFileUploadSize,
    "home_action_id": homeActionId,
    "cache_hashes": cacheHashes.toJson(),
    "currencies": currencies.toJson(),
    "bundle_params": bundleParams.toJson(),
    "user_companies": userCompanies.toJson(),
    "show_effect": showEffect,
    "display_switch_company_menu": displaySwitchCompanyMenu,
    "user_id": List<dynamic>.from(userId.map((x) => x)),
    "max_time_between_keys_in_ms": maxTimeBetweenKeysInMs,
    "notification_type": notificationType,
    "odoobot_initialized": odoobotInitialized,
    "bg_color": bgColor,
    "user_image": userImage,
    "session_sid": sessionSid,
    "spiffy_installed": spiffyInstalled,
    "prevent_auto_save_warning_msg": preventAutoSaveWarningMsg,
  };
}

class BundleParams {
  String lang;

  BundleParams({
    required this.lang,
  });

  factory BundleParams.fromJson(Map<String, dynamic> json) => BundleParams(
    lang: json["lang"],
  );

  Map<String, dynamic> toJson() => {
    "lang": lang,
  };
}

class CacheHashes {
  String translations;
  String loadMenus;

  CacheHashes({
    required this.translations,
    required this.loadMenus,
  });

  factory CacheHashes.fromJson(Map<String, dynamic> json) => CacheHashes(
    translations: json["translations"],
    loadMenus: json["load_menus"],
  );

  Map<String, dynamic> toJson() => {
    "translations": translations,
    "load_menus": loadMenus,
  };
}

class Currencies {
  Currencies1 the1;

  Currencies({
    required this.the1,
  });

  factory Currencies.fromJson(Map<String, dynamic> json) => Currencies(
    the1: Currencies1.fromJson(json["1"]),
  );

  Map<String, dynamic> toJson() => {
    "1": the1.toJson(),
  };
}

class Currencies1 {
  String symbol;
  String position;
  List<int> digits;

  Currencies1({
    required this.symbol,
    required this.position,
    required this.digits,
  });

  factory Currencies1.fromJson(Map<String, dynamic> json) => Currencies1(
    symbol: json["symbol"],
    position: json["position"],
    digits: List<int>.from(json["digits"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "position": position,
    "digits": List<dynamic>.from(digits.map((x) => x)),
  };
}

class UserCompanies {
  int currentCompany;
  AllowedCompanies allowedCompanies;

  UserCompanies({
    required this.currentCompany,
    required this.allowedCompanies,
  });

  factory UserCompanies.fromJson(Map<String, dynamic> json) => UserCompanies(
    currentCompany: json["current_company"],
    allowedCompanies: AllowedCompanies.fromJson(json["allowed_companies"]),
  );

  Map<String, dynamic> toJson() => {
    "current_company": currentCompany,
    "allowed_companies": allowedCompanies.toJson(),
  };
}

class AllowedCompanies {
  AllowedCompanies1 the1;

  AllowedCompanies({
    required this.the1,
  });

  factory AllowedCompanies.fromJson(Map<String, dynamic> json) => AllowedCompanies(
    the1: AllowedCompanies1.fromJson(json["1"]),
  );

  Map<String, dynamic> toJson() => {
    "1": the1.toJson(),
  };
}

class AllowedCompanies1 {
  int id;
  String name;
  int sequence;

  AllowedCompanies1({
    required this.id,
    required this.name,
    required this.sequence,
  });

  factory AllowedCompanies1.fromJson(Map<String, dynamic> json) => AllowedCompanies1(
    id: json["id"],
    name: json["name"],
    sequence: json["sequence"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sequence": sequence,
  };
}

class UserContext {
  String lang;
  String tz;
  int uid;

  UserContext({
    required this.lang,
    required this.tz,
    required this.uid,
  });

  factory UserContext.fromJson(Map<String, dynamic> json) => UserContext(
    lang: json["lang"],
    tz: json["tz"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "lang": lang,
    "tz": tz,
    "uid": uid,
  };
}
