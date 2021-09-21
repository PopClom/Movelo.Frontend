import 'package:fletes_31_app/src/blocs/new_travel_fragment_bloc.dart';
import 'package:fletes_31_app/src/ui/components/location_autocomplete_selector.dart';
import 'package:fletes_31_app/src/ui/components/transport_type_selector.dart';
import 'package:fletes_31_app/src/ui/new_travel_page.dart';
import 'package:fletes_31_app/src/utils/new_travel_args.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewTravelFragment extends StatefulWidget {
  const NewTravelFragment({Key key}) : super(key: key);

  @override
  _NewTravelFragmentState createState() => _NewTravelFragmentState();
}

class _NewTravelFragmentState extends State<NewTravelFragment> {
  final NewTravelFragmentBloc bloc = NewTravelFragmentBloc();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final Widget origin = Column(
      children: [
        Text(
          "Origen de carga",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Poppins'
          ),
        ),
        SizedBox(height: 7),
        LocationAutocompleteSelector(
          label: "Origen de carga",
          prefixIcon: Icon(Icons.location_pin, color: Colors.black,),
          onLocationSelected: bloc.changeOriginPlacesDetails,
        ),
      ],
    );

    final Widget destiny = Column(
      children: [
        Text(
          "Destino de carga",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Poppins'
          ),
        ),
        SizedBox(height: 7),
        LocationAutocompleteSelector(
          label: "Destino de carga",
          prefixIcon: Icon(Icons.location_pin, color: Colors.black,),
          onLocationSelected: bloc.changeDestinationPlacesDetails,
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          deviceSize.width > 900 ? Row(
            children: [
              Expanded(child: origin),
              SizedBox(width: 10),
              Expanded(child: destiny),
            ],
          ) : Column(
            children: [
              origin,
              SizedBox(height: 10),
              destiny,
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
            child: StreamBuilder<NewTravelArgs>(
                stream: bloc.newTravelArgs,
                builder: (context, snap) {
                  return OutlinedButton(
                    onPressed: (!snap.hasData || snap.data == null) ? null : () {
                      Navigator.pushReplacementNamed(
                        context,
                        NewTravelPage.routeName,
                        arguments: snap.data,
                      );
                    },
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
                      side: BorderSide(width: 3.0, color: Color.fromARGB(255,160,242,132)),
                      onSurface: Color.fromARGB(255,160,242,132),
                      /*primary: Colors.transparent,
                onPrimary: Colors.transparent,*/
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
