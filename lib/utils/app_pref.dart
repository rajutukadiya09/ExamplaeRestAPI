import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A class for managing application preferences using SharedPreferences
class AppPref {
  // Keys for SharedPreferences
  String isLoginPrefix = '_isLogin'; // Key to track if user is logged in
  String loginUserDetailPrefix =
      'login_user_detail'; // Key to store user login details
  String fcmToken = '_fcmToken'; // Key to store FCM token
  String seasonToken = '_seasonToken'; // Key to store session/season token
  String accessToken = '_accessToken'; // Key to store session/season token
  String cartCountPrefix = '_cartCount'; // Key to store cart count

  /// Store the FCM token in SharedPreferences
  Future<void> putFcmToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(fcmToken, token); // Save FCM token
  }

  /// Retrieve the FCM token from SharedPreferences
  Future<String> getFcmToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(fcmToken) ??
        ''; // Return the token or an empty string if null
  }

  /// Store an attachment ID in SharedPreferences as a list of integers
  Future<void> storeAttachmentId(int newAttachmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedIds = prefs.getString(
        'attachment_ids'); // Get stored attachment IDs as a JSON string

    List<int> attachmentIds = [];

    // If stored IDs exist, decode them into a list
    if (storedIds != null) {
      attachmentIds = List<int>.from(jsonDecode(storedIds));
    }

    attachmentIds.add(newAttachmentId); // Add the new attachment ID

    await prefs.setString('attachment_ids',
        jsonEncode(attachmentIds)); // Store the updated list as a JSON string

    print(
        'Stored Attachment IDs: $attachmentIds'); // Debugging: Print stored IDs
  }

  /// Retrieve the list of stored attachment IDs
  Future<List<int>> getStoredAttachmentIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedIds = prefs.getString(
        'attachment_ids'); // Get stored attachment IDs as JSON string

    if (storedIds != null) {
      return List<int>.from(
          jsonDecode(storedIds)); // Return decoded list of IDs
    }
    return []; // Return an empty list if no IDs are found

  }

  /// Clear the stored attachment IDs from SharedPreferences
  Future<void> clearStoredAttachmentIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('attachment_ids'); // Remove the attachment_ids key
    print("Attachment IDs cleared from storage."); // Debugging: Confirm removal
  }

  /// Store the session token in SharedPreferences
  Future<void> putSeasonToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(seasonToken, token); // Save session token
  }

  /// Retrieve the session token from SharedPreferences
  Future<String> getSeasonToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(seasonToken) ??
        ''; // Return the session token or empty string if null
  }
  Future<void> putAccessToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(accessToken, token); // Save session token
  }

  /// Retrieve the session token from SharedPreferences
  Future<String> getAccessToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(accessToken) ??
        ''; // Return the session token or empty string if null
  }

  /// Store the cart count in SharedPreferences
  Future<void> putCartCount(int count) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt(cartCountPrefix, count); // Save cart count
  }

  /// Retrieve the cart count from SharedPreferences
  Future<int> getCartCount() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(cartCountPrefix) ??
        0; // Return cart count or 0 if not found
  }

  /// Check if the user is logged in (returns true/false)
  Future<bool> getIsLogIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(isLoginPrefix) ??
        false; // Return login status or false if not found
  }

  /// Set the login status to true in SharedPreferences
  Future<void> putIsLogIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(isLoginPrefix, true); // Set login status to true
  }

  /// Clear a specific key-value pair from SharedPreferences
  Future<void> clearSinglePref({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key); // Remove the key-value pair
  }

  /// Clear all user-related data such as login, session, and cart info
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(loginUserDetailPrefix); // Remove login details
    prefs.remove(isLoginPrefix); // Remove login status
    prefs.remove(seasonToken); // Remove session token
    prefs.remove(cartCountPrefix); // Remove cart count
  }
}
