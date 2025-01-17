import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/configuration.dart';
import 'custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:async/async.dart';
import 'package:path/path.dart';

class ApiProvider {
  Future<dynamic> postRetrieveCookies(String url, String body) async {
    var responseJson;
    try {
      print(baseUrl + url + body);
      final response = await http.post(Uri.parse(baseUrl + url),
          body: body, headers: {'Content-Type': "application/json"});
      responseJson = _responseCookie(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _responseCookie(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = (json.decode(utf8.decode(response.bodyBytes)));
        print('Response Body ' + response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> post(String url, String body) async {
    print('POST URL = ' + baseUrl + url);
    print(body.toString());
    var responseJson;

    try {
      final response = await http.post(Uri.parse(baseUrl + url),
          body: body,
          headers: {
            'Content-Type': 'application/json',
          });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postMultiPart(
      String url, File file, var orderId, var detailId) async {
    var responseJson;
    debugPrint(url.toString());
    try {
      var stream = http.ByteStream(DelegatingStream(file.openRead()));
      var length = await file.length();
      var uri = Uri.parse(baseUrl + url);
      var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile('ATTACHMENT', stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');
      Map<String, String> headers = {
        'Content-Disposition': 'multipart/form-data',
        'Content-Type': 'multipart/form-data',
        'encytype': 'multipart/form-data',
      };
      request.headers.addAll(headers);
      request.fields['ATTACHMENT_NAME'] = 'test.png';
      request.fields['ORDER_ID'] = orderId;
      request.fields['DETAIL_ID'] = detailId;
      var responseSend = await request.send();
      var response = await http.Response.fromStream(responseSend);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(String url) async {
    print('GET URL = ' + baseUrl + url);
    var responseJson;
    try {
      final response = await http.get(Uri.parse(baseUrl + url), headers: {
        'Content-Type': 'application/json',
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = (json.decode(utf8.decode(response.bodyBytes)));
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

void saveCookie(String cookie) async {
  print('Cookie = ' + cookie);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('cookie', cookie);
}