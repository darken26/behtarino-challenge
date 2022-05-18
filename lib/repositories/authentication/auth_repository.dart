import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/utils/constants.dart';

part 'auth_api_client.dart';

class AuthenticationRepository {

  final AuthenticationApiClient authenticationApiClient;

  AuthenticationRepository({required this.authenticationApiClient});

  Future<http.Response> postUserName(userName) async {
    return await authenticationApiClient.postUserName(userName);
  }

  Future<http.Response> postActivationCode(Map<String, dynamic> requestBody) async {
    return await authenticationApiClient.postVerifyOTP(requestBody);
  }

}