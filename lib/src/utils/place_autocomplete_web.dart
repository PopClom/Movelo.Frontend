@JS()
library gmaps;


import 'dart:convert';

import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart' as jsutil;

@JS("getPlacesDetails")
external String getPlacesDetailsJavaScript(String filter, String sessionToken);

@JS("getLocationPredictions")
external String getLocationPredictionsJavaScript(String filter, String sessionToken);

class GoogleMapsHelpers {
  static Future<GooglePlacesAutocompleteResponse> getLocationPredictions(String filter, String sessionToken) async {
    var resultJson = await jsutil.promiseToFuture<String>(getLocationPredictionsJavaScript(filter, sessionToken));

    final properties = jsonDecode(resultJson) as Map<String, dynamic>;

    return GooglePlacesAutocompleteResponse.fromJson(properties);
  }

  static Future<GooglePlacesDetails> getPlacesDetails(String placeId, String sessionToken) async {
    var resultJson = await jsutil.promiseToFuture<String>(getPlacesDetailsJavaScript(placeId, sessionToken));

    final properties = jsonDecode(resultJson) as Map<String, dynamic>;

    return GooglePlacesDetails.fromJson(properties);
  }

}