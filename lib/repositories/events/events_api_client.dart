part of 'events_repository.dart';

class EventsApiClient {

  final http.Client httpClient;

  EventsApiClient({required this.httpClient});

  Future<http.Response> postEvents(Map<String, dynamic> requestBody, String token) async {
    const url = '$kBaseRouteV1/calendar/create';
    final data = jsonEncode(requestBody).toString();

    final response = await httpClient.post(Uri.parse(url), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "bearer $token",
    });

    return response;
  }

  // Future<Response> postVerifyOTP(Map<String, dynamic> requestBody) async {
  //   const url = '$kBaseRouteV1/Sms/Verification';
  //   final data = jsonEncode(requestBody).toString();
  //
  //   final response = await httpClient.post(Uri.parse(url), body: data, headers: {
  //     "Accept": "application/json",
  //     "content-type": "application/json",
  //   });
  //
  //   return response;
  // }

}