import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/utils/constants.dart';

part 'events_api_client.dart';

class EventsRepository {

  final EventsApiClient eventsApiClient;

  EventsRepository({required this.eventsApiClient});

  Future<http.Response> postEvents(Map<String, dynamic> requestBody, String token) async {
    return await eventsApiClient.postEvents(requestBody, token);
  }

  // Future<http.Response> postActivationCode(Map<String, dynamic> requestBody) async {
  //   return await eventsApiClient.postVerifyOTP(requestBody);
  // }

}