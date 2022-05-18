part of 'auth_repository.dart';

class AuthenticationApiClient {

  final http.Client httpClient;

  AuthenticationApiClient({required this.httpClient});

  Future<http.Response> postUserName(String userName) async {
    const url = '$kBaseRouteV1/auth/login';
    final data = jsonEncode({
      'username': userName,
    });

    final response = await httpClient.post(Uri.parse(url), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });

    return response;
  }

  Future<http.Response> postVerifyOTP(Map<String, dynamic> requestBody) async {
    const url = '$kBaseRouteV1/auth/verify';
    final data = jsonEncode(requestBody).toString();

    final response = await httpClient.post(Uri.parse(url), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });

    return response;
  }

}