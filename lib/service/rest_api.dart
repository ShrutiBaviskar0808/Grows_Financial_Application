import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:growsfinancial/utils/config.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:http/http.dart' as http;

class RestApi {
  //Make Request
  Future<dynamic> _makeRequest(
    String url,
    String method, {
    Map<String, dynamic>? data,
  }) async {
    Config config = Config();
    bool isConnected = await config.checkConnection();
    if (isConnected) {
      Stopwatch stopwatch = Stopwatch()..start();
      var headers = {'Content-Type': 'application/json'};
      http.Response response;

      switch (method) {
        case 'POST':
          response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: data != null ? jsonEncode(data) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            Uri.parse(url),
            headers: headers,
            body: data != null ? jsonEncode(data) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(Uri.parse(url), headers: headers);
          break;
        default:
          response = await http.get(Uri.parse(url), headers: headers);
      }

      stopwatch.stop();
      int responseTime = stopwatch.elapsedMilliseconds;

      config.debugLog(
        "URL: $url \nMethod: $method \nPOST Data: $data \nResponse Time: ${responseTime}ms",
      );
      if (responseTime > 2000) {
        debugPrint("WARNING: Response took longer than 2 seconds!");
      }
      config.debugLog(
        "Response Status Code: ${response.statusCode},Response Body: ${response.body}",
      );
      if ((response.statusCode >= 200 && response.statusCode < 300) ||
          response.statusCode == 401) {
        // config.debugLog("Response Body: ${response.body}");

        return jsonDecode(response.body);
      } else {
        return null;
      }
    } else {
      config.showToastFailure("No Internet Connection");
    }
  }

  // Contact Us
  Future<dynamic> contactUs(
    String name,
    String email,
    String phone,
    String subject,
    String message,
  ) async {
    String url = '${apiUrl}contactus';

    var map = <String, dynamic>{
      "name": name.trim(),
      "email": email.trim(),
      "phoneno": phone.trim(),
      "subject": subject.trim(),
      "detail": message.trim(),
    };

    return await _makeRequest(url, 'POST', data: map);
  }

  // Login
  Future<dynamic> login(
    String userName,
    String password,
    String deviceToken,
  ) async {
    String url = '${apiUrl}login.php';

    var map = <String, dynamic>{};
    map["email"] = userName.trim();
    map["password"] = password.trim();
    map["deviceToken"] = deviceToken.trim();
    map["currentVersion"] = appVersion;
    map["deviceType"] = Platform.operatingSystem.toLowerCase();

    return await _makeRequest(url, 'POST', data: map);
  }

  // Logout
  Future<dynamic> logout(String userID, String deviceToken) async {
    String url = '${apiUrl}user-logout';

    var map = <String, dynamic>{};
    map["userId"] = userID.trim();
    map["deviceToken"] = deviceToken.trim();

    return await _makeRequest(url, 'POST', data: map);
  }

  // Forget Password
  Future<dynamic> forgetPassword(String email) async {
    String url = '${apiUrl}send-reset-password-link';

    var map = <String, dynamic>{};
    map["email"] = email.trim();

    return await _makeRequest(url, 'POST', data: map);
  }

  // Register
  Future<dynamic> register(
    String name,
    String mobileNumber,
    String email,
    String password,
    String dob,
    String sin,
  ) async {
    String url = '${apiUrl}register.php';

    var map = <String, dynamic>{
      "name": name.trim(),
      "mobileNumber": mobileNumber.trim(),
      "email": email.trim(),
      "password": password.trim(),
      "dob": dob.trim(),
      "sin": sin.trim(),
    };

    return await _makeRequest(url, 'POST', data: map);
  }

  // Register
  Future<dynamic> sendOtp(String email) async {
    String url = '${apiUrl}email_otp.php';

    var map = <String, dynamic>{"email": email.trim()};

    return await _makeRequest(url, 'POST', data: map);
  }

  // Generate OTP
  Future<dynamic> generateOTP(String phone) async {
    String url = '${apiUrl}generate-otp';

    var map = <String, dynamic>{"phoneNumber": phone.trim()};

    return await _makeRequest(url, 'POST', data: map);
  }

  // Verify OTP
  Future<dynamic> verifyOTP(String phone, String otp, String userID) async {
    String url = '${apiUrl}verify-otp';

    var map = <String, dynamic>{
      "phoneNumber": phone.trim(),
      "otp": otp.trim(),
      "userID": userID.trim(),
    };

    return await _makeRequest(url, 'POST', data: map);
  }

  // User Get
  Future<dynamic> getUser(String id) async {
    String url = '${apiUrl}clientDetail.php';
    Config config = Config();
    String deviceToken = await config.getStringSharedPreferences("deviceToken");
    var map = <String, dynamic>{
      "clientID": id.trim(),
      "deviceToken": deviceToken.trim(),
    };
    return await _makeRequest(url, 'POST', data: map);
  }

  // Business Get
  Future<dynamic> getBusiness(String id) async {
    String url = '${apiUrl}businessDetail.php';
    var map = <String, dynamic>{"businessID": id.trim()};
    return await _makeRequest(url, 'POST', data: map);
  }

  // Account Get
  Future<dynamic> getAccounts(String id) async {
    String url = '${apiUrl}accounts.php';
    var map = <String, dynamic>{"clientID": id.trim()};
    return await _makeRequest(url, 'POST', data: map);
  }

  // Document Request Get
  Future<dynamic> getDocumentRequest(String id) async {
    String url = '${apiUrl}clientDocumentRequest.php';
    var map = <String, dynamic>{"clientID": id.trim()};
    return await _makeRequest(url, 'POST', data: map);
  }

  // Services Get
  Future<dynamic> getServices(String type) async {
    String url = '${apiUrl}services.php?type=$type';
    return await _makeRequest(url, 'GET');
  }

  // Services Get
  Future<dynamic> getBusinessType() async {
    String url = '${apiUrl}businessTypes.php';
    return await _makeRequest(url, 'GET');
  }

  // Client Services Get
  Future<dynamic> getClientServices(
    String clientID,
    String serviceID,
    String type,
    String businessID,
  ) async {
    String url = '${apiUrl}clientService.php';
    var map = <String, dynamic>{
      "clientID": clientID.trim(),
      "serviceID": serviceID.trim(),
      "type": type.trim(),
      "businessID": businessID.trim(),
    };
    return await _makeRequest(url, 'POST', data: map);
  }

  // Add Business Profile
  Future<dynamic> addAccount(
    String clientID,
    String selectedBusinessType,
    String businessName,
    String bn,
  ) async {
    String url = '${apiUrl}addAccounts.php';
    var map = <String, dynamic>{
      "clientID": clientID.trim(),
      "businessType": selectedBusinessType.trim(),
      "businessName": businessName.trim(),
      "corporationBN": bn.trim(),
    };
    return await _makeRequest(url, 'POST', data: map);
  }

  // Form Years
  Future<dynamic> formYears() async {
    String url = '${apiUrl}formYears.php';

    return await _makeRequest(url, 'GET');
  }

  // Form Options
  Future<dynamic> formOptions(
    String clientID,
    String serviceID,
    String type,
    String businessID,
    String period,
  ) async {
    String url = '${apiUrl}formOptions.php';
    var map = <String, dynamic>{
      "clientID": clientID.trim(),
      "serviceID": serviceID.trim(),
      "type": type.trim(),
      "businessID": businessID.trim(),
      "period": period.trim(),
    };
    return await _makeRequest(url, 'POST', data: map);
  }

  // Client Service Form
  Future<dynamic> addClientService(
    String csID,
    Map<String, dynamic> formData,
  ) async {
    String url = '${apiUrl}addClientService.php';
    var map = <String, dynamic>{
      "cs_id": csID.trim(),
      "form_data": jsonEncode(formData),
    };
    return await _makeRequest(url, 'POST', data: map);
  }

  // Client Service Detail
  Future<dynamic> getClientService(
    String csID,
    String clientID,
    String serviceID,
  ) async {
    String url = '${apiUrl}serviceDetail.php';
    var map = <String, dynamic>{
      "cs_id": csID.trim(),
      "client_id": clientID.trim(),
      "service_id": serviceID.trim(),
    };
    return await _makeRequest(url, 'POST', data: map);
  }

  // Profile Verify
  Future<dynamic> verifyProfile(String csId) async {
    String url = '${apiUrl}profile_verify.php';
    return await _makeRequest(url, 'POST', data: {"cs_id": csId});
  }


  //update profile photo
  Future<dynamic> uploadProfilePhoto(String clientID, String file) async {
    String url = '${apiUrl}upload_profile_pic.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    if (file.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('profile_pic', file));
    }
    request.fields['client_id'] = clientID.trim();

    http.StreamedResponse streamedResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamedResponse);
    /* Config config = Config();
    config.debugLog(
      "URL: $url \nMethod: POST \nPOST Data: ${request.fields}\nResponse Staus: ${response.statusCode}",
    );
    config.debugLog("Response Body: ${response.body}");*/

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  // Update User Profile
  Future<dynamic> updateUserProfile(
    String id,
    String name,
    String email,
    String phone,
    String sin,
  ) async {
    String url = '${apiUrl}update_profile.php';
    var map = <String, dynamic>{
      "clientID": id.trim(),
      "name": name.trim(),
      "email": email.trim(),
      "mobileNumber": phone.trim(),
      "sin": sin.trim(),
    };
    return await _makeRequest(url, 'POST', data: map);
  }

  // Update User Password
  Future<dynamic> updatePassword(
    String id,
    String oldPassword,
    String newPassword,
  ) async {
    String url = '${apiUrl}update_password.php';
    var map = <String, dynamic>{
      "clientID": id.trim(),
      "oldPassword": oldPassword.trim(),
      "newPassword": newPassword.trim(),
    };
    return await _makeRequest(url, 'POST', data: map);
  }

  //Client Document Request Upload
  Future<Map<String, dynamic>?> uploadDocuments(
    String csID,
    String requestID,
    String categoryID,
    List<String> filePaths,
  ) async {
    final uri = Uri.parse("${apiUrl}uploadDocumentRequest.php");

    final req = http.MultipartRequest('POST', uri);
    req.fields['cs_id'] = csID.trim();
    req.fields['request_id'] = requestID.trim();
    req.fields['category_id'] = categoryID.trim();
    for (final path in filePaths) {
      req.files.add(await http.MultipartFile.fromPath('documents[]', path));
      // or 'document[]' depending on backend key
    }

    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);

    // parse json
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  // Bookkeeping Form Options
  Future<dynamic> bookKeepingFormOptions(String businessID) async {
    String url = '${apiUrl}bookKeepingFormOptions.php';
    var map = <String, dynamic>{"businessID": businessID.trim()};
    return await _makeRequest(url, 'POST', data: map);
  }

  // Bookkeeping Form
  Future<dynamic> addBookKeepingDetails(
    String businessID,
    Map<String, dynamic> formData,
  ) async {
    String url = '${apiUrl}addBookKeepingDetails.php';
    var map = <String, dynamic>{
      "business_id": businessID.trim(),
      "form_data": jsonEncode(formData),
    };
    return await _makeRequest(url, 'POST', data: map);
  }

  // Service Inquiry Form
  Future<dynamic> addServiceInquiry(
    String clientID,
    String businessID,
    String serviceID,
    String notes,
    String type,
  ) async {
    String url = '${apiUrl}add_inquiry.php';
    var map = <String, dynamic>{
      "client_id": clientID.trim(),
      "business_id": businessID.trim(),
      "service_id": serviceID.trim(),
      "notes": notes.trim(),
      "type": type.trim(),
    };
    return await _makeRequest(url, 'POST', data: map);
  }
}
