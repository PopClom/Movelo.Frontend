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
      child: Column(
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
                        fontSize: 20,
                        fontFamily: 'Poppins'
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
                        fontSize: 20,
                        fontFamily: 'Poppins'
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
          const Divider(
            height: 60,
            thickness: 2,
            color: Color.fromARGB(255,172,149,231)
          ),
          Center(
            child: Column(
              children: [
                Text(
                  "¿Qué vehículo necesitás para transportar tu carga?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Poppins'
                  ),
                ),
                SizedBox(height: 15),
                TransportTypeSelector(
                  onSelectionChanged: bloc.changeSelectedVehicleType,
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: OutlinedButton(
              onPressed: /*!(snap.hasData && snap.data) ? null :*/ () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text("COTIZÁ AHORA"),
              ),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                padding: EdgeInsets.all(20),
                textStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins'
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                side: BorderSide(width: 5.0, color: Color.fromARGB(255,160,242,132)),
                /*primary: Colors.transparent,
                onPrimary: Colors.transparent,*/
              ),
            ),
          ),
        ],
      ),
    );
  }
}
