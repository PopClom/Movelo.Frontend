import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:uuid/uuid.dart';

import 'package:fletes_31_app/src/utils/place_autocomplete_mobile.dart' if (dart.library.js) 'package:fletes_31_app/src/utils/place_autocomplete_web.dart';

class LocationAutocompleteSelector extends StatefulWidget {
  //TODO instancio uno estatico o que?
  static final Uuid uuid = Uuid();
  final String label;
  final Function(GooglePlacesDetails) onLocationSelected;
  final Icon prefixIcon;
  final String initialValue;

  LocationAutocompleteSelector({
    @required this.label,
    this.onLocationSelected, this.prefixIcon, this.initialValue,
  });

  @override
  _LocationAutocompleteSelectorState createState() => _LocationAutocompleteSelectorState();
}

class _LocationAutocompleteSelectorState extends State<LocationAutocompleteSelector> {
  String sessionToken = LocationAutocompleteSelector.uuid.v4();

  final TextEditingController _typeAheadController = TextEditingController();

  Widget build(BuildContext context) {
    TextSelection prevSelection = _typeAheadController.selection;
    _typeAheadController.text = widget.initialValue;
    _typeAheadController.selection = prevSelection;

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: this._typeAheadController,
        autofocus: true,
        style: DefaultTextStyle.of(context).style.copyWith(
          //fontStyle: FontStyle.italic,
        ),
        decoration: InputDecoration(
            hintText: 'Escribí una dirección: calle y número',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 10.0
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: this.widget.prefixIcon,
            fillColor: Colors.white,
            filled: true
          ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      suggestionsCallback: (String filter) async {
        if(filter.isEmpty)
          return [];
        return (await GoogleMapsHelpers.getLocationPredictions(filter, sessionToken)).predictions;
      },
      itemBuilder: (context, prediction) {
        return ListTile(
          leading: this.widget.prefixIcon,
          title: Text(prediction.structuredFormatting.mainText),
          subtitle: Text(prediction.structuredFormatting.secondaryText),
        );
      },
      onSuggestionSelected: (prediction) async {
        this._typeAheadController.text = prediction.description;

        GooglePlacesDetails place = await GoogleMapsHelpers.getPlacesDetails(prediction.placeId, sessionToken);

        this.widget.onLocationSelected(place);

        //TODO esto no es una monstruosidad? Usaria state pero no quiero que redibuje
        sessionToken = LocationAutocompleteSelector.uuid.v4();
      },
      errorBuilder: (BuildContext context, Object error) =>
          ListTile(
            title: Text(
                '$error',
                style: TextStyle(
                    color: Theme.of(context).errorColor
                )
            ),
          ),
      noItemsFoundBuilder: (BuildContext context) =>
          ListTile(
            title: Text(
                'No se encontraron resultados para esa búsqueda',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                )
            ),
          ),
    );
  }
}
