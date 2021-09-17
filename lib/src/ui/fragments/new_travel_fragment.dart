import 'package:fletes_31_app/src/blocs/new_travel_bloc.dart';
import 'package:fletes_31_app/src/ui/components/location_autocomplete_selector.dart';
import 'package:fletes_31_app/src/ui/components/transport_type_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewTravelFragment extends StatefulWidget {
  const NewTravelFragment({Key key}) : super(key: key);

  @override
  _NewTravelFragmentState createState() => _NewTravelFragmentState();
}

class _NewTravelFragmentState extends State<NewTravelFragment> {
  final NewTravelBloc bloc = NewTravelBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 15,
        children: [
          Row(
            children: [
              Expanded(child: Column(
                children: [
                  Text(
                    "¿Desde donde vas?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 7),
                  LocationAutocompleteSelector(
                    label: "¿Desde donde vas?",
                    prefixIcon: Icon(Icons.location_pin, color: Colors.black,),
                    onLocationSelected: bloc.changeOriginPlacesDetails,
                  ),
                ],
              )),
              SizedBox(width: 10),
              Expanded(child: Column(
                children: [
                  Text(
                    "¿Hasta donde vas?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 7),
                  LocationAutocompleteSelector(
                    label: "¿Hasta donde vas?",
                    prefixIcon: Icon(Icons.location_pin, color: Colors.black,),
                    onLocationSelected: bloc.changeDestinationPlacesDetails,
                  ),
                ],
              ))
            ],
          ),
          TransportTypeSelector(
            onSelectionChanged: bloc.changeSelectedVehicleType,
          ),
          Center(
            child: ElevatedButton(
              onPressed: /*!(snap.hasData && snap.data) ? null :*/ () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text("COTIZÁ AHORA"),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onPrimary: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
