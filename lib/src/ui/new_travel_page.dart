import 'dart:math';
import 'package:async/async.dart';
import 'package:fletes_31_app/src/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';
import 'package:fletes_31_app/src/ui/components/datetime_picker.dart';
import 'package:fletes_31_app/src/models/dtos/travel_pricing_result_dto.dart';
import 'package:fletes_31_app/src/ui/components/map_view.dart';
import 'package:fletes_31_app/src/blocs/new_travel_bloc.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:fletes_31_app/src/ui/landing_page.dart';
import 'package:fletes_31_app/src/utils/new_travel_args.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:fletes_31_app/src/ui/components/location_autocomplete_selector.dart';
import 'package:fletes_31_app/src/ui/components/transport_type_info.dart';
import 'package:fletes_31_app/src/ui/components/transport_type_selector.dart';

class NewTravelPage extends StatefulWidget {
  static const routeName = '/cotizar';

  NewTravelPage({ Key key }) : super(key: key);

  @override
  _NewTravelPageState createState() => _NewTravelPageState();
}

class _NewTravelPageState extends State<NewTravelPage> {
  final NewTravelBloc bloc = NewTravelBloc();

  Map<String, Marker> mapMarkers = new Map();
  CancelableOperation travelEstimation;

  String _initialOriginString;
  String _initialDestinationString;
  bool _initialArgsLoaded = false;

  void _onMapCreated(GoogleMapController controller) async {
    bloc.informMapLoaded(true);
  }

  @override
  void initState() {
    bloc.formCompleted.listen((completed) async {
      if (travelEstimation != null) {
        travelEstimation.cancel();
        bloc.changeIsSubmitting(false);
      }

      if(completed == true) {
        travelEstimation = CancelableOperation.fromFuture(
            bloc.submit()
        );
        bloc.changeIsSubmitting(true);
        travelEstimation.then((estimation) {
          bloc.changeCurrentTravelEstimation(estimation);
          bloc.changeIsSubmitting(false);
        });
      } else {
        bloc.changeCurrentTravelEstimation(null);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double mapSize = deviceSize.width * 0.35;

    final args = ModalRoute.of(context).settings.arguments as NewTravelArgs;
    if (args != null && !_initialArgsLoaded) {
      _initialOriginString = args.originPlacesDetails.formattedAddress;
      _initialDestinationString = args.destinationPlacesDetails.formattedAddress;
      bloc.changeOriginPlacesDetails(args.originPlacesDetails);
      bloc.changeDestinationPlacesDetails(args.destinationPlacesDetails);
      bloc.changeSelectedVehicleType(args.selectedVehicleType);
    } else {
      _initialOriginString = null;
      _initialDestinationString = null;
    }
    _initialArgsLoaded = true;

    return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: deviceSize.width > 1000 ? [
                    SizedBox(height: 20),
                    _buildTitle(),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _buildForm(deviceSize.width),
                        SizedBox(width: 30),
                        _buildMap(mapSize),
                      ],
                    ),
                  ] : [
                    SizedBox(height: 10),
                    _buildTitle(),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        _buildForm(deviceSize.width),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildMap(mapSize = min(600.0, deviceSize.width * 0.88)),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  _buildTitle() {
    return Center(
      child: Text(
          'Cotizá tu envío con nosotros',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25
          )
      ),
    );
  }

  _buildForm(double deviceWidth) {
    return Expanded(
      child: Column(
        children: [
          Text(
              '¿Qué vas a cargar?',
              style: TextStyle(
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 4),
          TextField(
            style: TextStyle(
              fontSize: 14,
            ),
            onChanged: bloc.changeTransportedObjectsDetails,
            autofocus: true,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0
                ),
                hintText: 'Cinco macetas grandes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                //prefixIcon: this.widget.prefixIcon,
                fillColor: Colors.white,
                filled: true
            ),
          ),
          SizedBox(height: 10),
          Text(
              'Origen de carga',
              style: TextStyle(
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 4),
          LocationAutocompleteSelector(
            label: 'Origen de carga',
            onLocationSelected: bloc.changeOriginPlacesDetails,
            initialValue: _initialOriginString,
          ),
          SizedBox(height: 10),
          Text(
              'Destino de carga',
              style: TextStyle(
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 4),
          LocationAutocompleteSelector(
            label: 'Destino de carga',
            onLocationSelected: bloc.changeDestinationPlacesDetails,
            initialValue: _initialDestinationString,
          ),
          SizedBox(height: 10),
          Text(
              '¿Qué vehículo necesitás para transportar tu carga?',
              style: TextStyle(
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 4),
          StreamBuilder(
              stream: bloc.selectedVehicleType,
              builder: (context, snapshot) {
                if(snapshot.hasData && !snapshot.hasError) {
                  return TransportTypeInformation(
                      vehicleType: snapshot.data,
                      onChangeClicked: () => bloc.changeSelectedVehicleType(null)
                  );
                } else {
                  return Container(
                      alignment: Alignment.center,
                      child:
                      TransportTypeSelector(
                          onSelectionChanged: (vehicleType) => bloc.changeSelectedVehicleType(vehicleType)
                      )
                  );
                }
              }
          ),
          SizedBox(height: 20),
          deviceWidth > 500 ? Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDriverHandlesLoading(),
                    SizedBox(height: 16),
                    _buildFitsInElevator(),
                  ],
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNumberOfHelpers(),
                    SizedBox(height: 18),
                    _buildNumberOfFloors(),
                  ],
                ),
              ),
            ],
          ) : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDriverHandlesLoading(),
                SizedBox(height: 15),
                _buildNumberOfHelpers(),
                SizedBox(height: 15),
                _buildFitsInElevator(),
                SizedBox(height: 15),
                _buildNumberOfFloors(),
              ],
          ),
          SizedBox(height: 15),
          Center(
            child: Row(
              children: [
                DatetimePickerWidget(changeDateTime:  bloc.changeDepartureDateTime),
                SizedBox(width: 10),
                StreamBuilder(
                  stream: bloc.currentTravelEstimation,
                  builder: (context, snap1) {
                    return StreamBuilder<bool>(
                        stream: bloc.isSubmitting,
                        builder: (context, snap2) {
                          return StreamBuilder<bool>(
                              stream: authBloc.isSessionValid,
                              builder: (context, snap3) {
                                bool btnEnabled = snap1.hasData
                                    && snap1.data != null
                                    && !(snap2.hasData && snap2.data != null && snap2.data);

                                bool loggedIn = snap3.hasData && snap3.data;

                                void Function() onPressed;
                                if (btnEnabled) {
                                  if (loggedIn) {
                                    onPressed = bloc.confirmTravelRequest;
                                  } else {
                                    onPressed = _showLoginDialog;
                                  }
                                }

                                return Container(
                                  child: Expanded(
                                      child: ElevatedButton(
                                        onPressed: onPressed,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                          child: (snap2.hasData && snap2.data != null && snap2.data ? SizedBox(
                                            child: CircularProgressIndicator(strokeWidth: 2.0,),
                                            height: 20.0,
                                            width: 20.0,
                                          ) : Text('REALIZAR PEDIDO')),
                                        ),
                                      )
                                  ),
                                );
                              });
                        });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  _buildMap(double mapSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onVerticalDragUpdate: (_) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Stack(
            children: [
              Container(
                height: mapSize,
                width: mapSize,
                clipBehavior: Clip.hardEdge,
                foregroundDecoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 96,46,209),
                        width: 1.5
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 96,46,209),
                        width: 1.5
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: MapView(
                  markers: bloc.originAndDestinationMarkers,
                  onMapCreated: _onMapCreated,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Wrap(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 96,46,209),
                                  width: 3
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Colors.white
                          ),
                          child: IntrinsicWidth(child: StreamBuilder(
                            stream: bloc.currentTravelEstimation,
                            builder: (context, snapshot) {
                              if(snapshot.hasData && !snapshot.hasError && snapshot.data != null) {
                                Travel travelEstimation = (snapshot.data as TravelPricingResult).travel;
                                return Column(
                                  children: [
                                    Container(
                                        color: Color.fromARGB(255, 96,46,209),
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: StreamBuilder(
                                              stream: bloc.selectedVehicleType,
                                              builder: (context, snapshot) {
                                                if(snapshot.hasData && !snapshot.hasError) {
                                                  VehicleType selectedVehicleType = snapshot.data;

                                                  return Row(
                                                    children: [
                                                      Image.network(
                                                          'https://localhost:44312' + selectedVehicleType.imageUrl,
                                                          height: 35,
                                                          fit: BoxFit.contain,
                                                          color: Colors.white
                                                      ),
                                                      Expanded(child: Text(
                                                        '\$${travelEstimation.estimatedPrice.toStringAsFixed(2)}',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ))
                                                    ],
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              }
                                          ),
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.timer,
                                            color: Color.fromARGB(255, 96,46,209),
                                          ),
                                          SizedBox(width: 10),
                                          Text('Tiempo estimado: ${(travelEstimation.estimatedRoute.travelTimeInSeconds / 60.0).toStringAsFixed(0)} minutos')
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.square_foot,
                                            color: Color.fromARGB(255, 96,46,209),
                                          ),
                                          SizedBox(width: 10),
                                          Text('Distancia a recorrer: ${(travelEstimation.estimatedRoute.distanceInMeters / 1000.0).toStringAsFixed(1)}km')
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container(
                                    color: Color.fromARGB(255, 96,46,209),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Center(
                                        child: Text(
                                          'Por favor, completá el formulario.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ),
                                    )
                                );
                              }
                            },
                          )),
                        ),
                      ],
                    )
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _buildNumberOfHelpers() {
    return StreamBuilder(
        stream: bloc.numberOfHelpers,
        builder: (context, snap) {
          return _buildDropDown(
              'Cantidad de ayudantes',
              snap.hasData ? snap.data : null,
              (value) => bloc.changeNumberOfHelpers(value),
              [
                DropdownMenuItem(child: Text('0'), value: 0),
                DropdownMenuItem(child: Text('1'), value: 1),
                DropdownMenuItem(child: Text('2'), value: 2),
              ]
          );
        }
    );
  }

  _buildNumberOfFloors() {
    return StreamBuilder(
        stream: bloc.numberOfFloors,
        builder: (context, snap) {
          return TextFormField(
              style: TextStyle(
                fontSize: 16,
              ),
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: snap.hasData ? snap.data.toString() : '',
                  selection: TextSelection.collapsed(
                    offset: snap.hasData ? snap.data.toString().length : 0,
                  ),
                ),
              ),
              decoration: InputDecoration(
                labelText: 'Cantidad de pisos',
                labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, height: 1.3),
                isDense: true,
                fillColor: Color(0xfff3f3f4),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              onChanged: (val) => bloc.changeNumberOfFloors(int.tryParse(val)),
              keyboardType: TextInputType.number
          );
        }
    );
  }

  _buildFitsInElevator() {
    return StreamBuilder(
      stream: bloc.fitsInElevator,
      builder: (context, snap) {
        return _buildDropDown(
            'Entra en el ascensor',
            snap.hasData && snap.data ? 2 : 1,
            (value) => bloc.changeFitsInElevator(value == 2),
            [
              DropdownMenuItem(child: Text('No'), value: 1),
              DropdownMenuItem(child: Text('Sí'), value: 2),
            ]
        );
      },
    );
  }

  _buildDriverHandlesLoading() {
    return StreamBuilder(
      stream: bloc.driverLoadingAndUnloadingIntStatus,
      builder: (context, snap) {
        return _buildDropDown(
            'El fletero...',
            snap.data,
            (value) {
              bloc.changeDriverLoadingAndUnloadingIntStatus(value);
              if(value == 1) {
                bloc.changeDriverHandlesLoading(true);
                bloc.changeDriverHandlesUnloading(false);
              } else if(value == 2) {
                bloc.changeDriverHandlesLoading(false);
                bloc.changeDriverHandlesUnloading(true);
              } else if(value == 3) {
                bloc.changeDriverHandlesLoading(true);
                bloc.changeDriverHandlesUnloading(true);
              } else if(value == 4) {
                bloc.changeDriverHandlesLoading(false);
                bloc.changeDriverHandlesUnloading(false);
              }
            },
            [
              DropdownMenuItem(child: Text('Carga'), value: 1),
              DropdownMenuItem(child: Text('Descarga'), value: 2),
              DropdownMenuItem(child: Text('Carga y descarga'), value: 3),
              DropdownMenuItem(child: Text('NO carga NI descarga'), value: 4),
            ]
        );
      },
    );
  }

  _buildDropDown(labelText, value, onChanged, items) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, height: 1.2),
        isDense: true,
        fillColor: Color(0xfff3f3f4),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
      onChanged: onChanged,
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      value: value,
      items: items,
    );
  }

  void _showLoginDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¡Iniciá sesión!'),
          content: Text('Para realizar este pedido, debés iniciar sesión o registrarte.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Iniciar sesión'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(
                  Navigation.navigationKey.currentContext,
                  LoginPage.routeName,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
