import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';

class GoogleMapsHelpers {
  static Future<GooglePlacesAutocompleteResponse> getLocationPredictions(String filter, String sessionToken) async {
    var response = await Dio().get(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json',
      queryParameters: {
        'key': 'AIzaSyDHwZdNQeCf2lZWSyMkALVcmGGahBkxPhs',
        'sessiontoken': sessionToken,
        'language': 'es_ES',
        'location': '-34.581834427449245,-58.37982525831364',
        'radius': 1000000,
        'strictbounds': null,
        //TODO "types": "establishment,address",
        'input': filter,
      },
    );
    return GooglePlacesAutocompleteResponse.fromJson(response.data);
  }

  static Future<GooglePlacesDetails> getPlacesDetails(String placeId, String sessionToken) async {
    var response = await Dio().get(
      'https://maps.googleapis.com/maps/api/place/details/json',
      queryParameters: {
        'key': 'AIzaSyDHwZdNQeCf2lZWSyMkALVcmGGahBkxPhs',
        'sessiontoken': sessionToken,
        'language': 'es_ES',
        'fields': 'name,geometry,formatted_address',
        'place_id': placeId,
      },
    );
    return GooglePlacesDetailsResponse.fromJson(response.data).result;
  }
}