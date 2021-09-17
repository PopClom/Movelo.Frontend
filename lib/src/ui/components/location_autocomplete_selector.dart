import 'package:dropdown_search/dropdown_search.dart';
import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:fletes_31_app/src/utils/place_autocomplete_mobile.dart' if (dart.library.js) 'package:fletes_31_app/src/utils/place_autocomplete_web.dart';

class LocationAutocompleteSelector extends StatefulWidget {
  //TODO instancio uno estatico o que?
  static final Uuid uuid = Uuid();
  final String label;
  final Function(GooglePlacesDetails) onLocationSelected;
  final Icon prefixIcon;

  LocationAutocompleteSelector({
    @required this.label,
    this.onLocationSelected, this.prefixIcon
  });

  @override
  _LocationAutocompleteSelectorState createState() => _LocationAutocompleteSelectorState();
}

class _LocationAutocompleteSelectorState extends State<LocationAutocompleteSelector> {
  String sessionToken = LocationAutocompleteSelector.uuid.v4();

  Widget build(BuildContext context) {
    return DropdownSearch<GooglePlacesAutocompletePrediction>(
      hint: "Ingrese una dirección: calle y número",
      itemAsString: (GooglePlacesAutocompletePrediction u) => u.description,
      showSearchBox: true,
      mode: Mode.MENU,
      searchBoxDecoration: InputDecoration(
        prefixIcon: this.widget.prefixIcon ?? null,
        labelText: this.widget.label,
        hintText: "Ingrese una dirección: calle y número",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      dropdownSearchDecoration: InputDecoration(
        prefixIcon: this.widget.prefixIcon ?? null,
        isCollapsed: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.only(top: 5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelStyle: TextStyle(
          color: Color.fromRGBO(112, 112, 112, 1)
        )
      ),
      isFilteredOnline: true,
      autoFocusSearchBox: true,
      onFind: (String filter) async {
        if(filter.isEmpty)
          return [];

        return (await GoogleMapsHelpers.getLocationPredictions(filter, sessionToken)).predictions;
      },
      onChanged: (prediction) async {
        GooglePlacesDetails place = await GoogleMapsHelpers.getPlacesDetails(prediction.placeId, sessionToken);

        this.widget.onLocationSelected(place);

        //TODO esto no es una monstruosidad? Usaria state pero no quiero que redibuje
        sessionToken = LocationAutocompleteSelector.uuid.v4();
      }
    );
  }
}
