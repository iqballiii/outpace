import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  Future apiCall(int mobile, String latitude, String longitude) async {
    http.Response response = await http.post(
        'http://dev.eosinfotech.com:5000/signup/create',
        body: jsonEncode({
          'mobileNumber': mobile,
          'latitude': latitude,
          'longitude': longitude
        }));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      print(decodedData);
      return decodedData;
    } else {
      print(response.statusCode);
    }
  }
}
