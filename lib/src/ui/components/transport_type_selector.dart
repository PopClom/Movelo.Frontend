import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/network/vehicle_type_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fletes_31_app/src/models/vehicle_type_model.dart';

class TransportTypeSelector extends StatefulWidget {
  final Function(VehicleType) onSelectionChanged;

  const TransportTypeSelector({Key key, @required this.onSelectionChanged}) : super(key: key);

  @override
  _TransportTypeSelectorState createState() => _TransportTypeSelectorState();
}

class _TransportTypeSelectorState extends State<TransportTypeSelector> {
  Future<List<VehicleType>> futureVehicleTypes;
  VehicleType selectedVehicleType;
  VehicleTypeAPI apiService = VehicleTypeAPI(Dio());

  Future<List<VehicleType>> fetchVehicleTypes() async {
    return apiService.getVehicleTypes();
  }

  @override
  void initState() {
    super.initState();
    futureVehicleTypes = fetchVehicleTypes();
  }

  Widget drawSelectedVehicleTypeDetails() {
    if(selectedVehicleType == null)
      return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(thickness: 1),
        Text(
          selectedVehicleType.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
            "Dimensiones: "
                "${selectedVehicleType.widthInMeters}m (Ancho) x "
                "${selectedVehicleType.heightInMeters}m (Alto) x "
                "${selectedVehicleType.widthInMeters}m (Profundidad)"
        ),
        Text("Peso máximo: ${selectedVehicleType.maxWeightInKilograms}kg"),
        Divider(thickness: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VehicleType>>(
      future: futureVehicleTypes,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            spacing: 40,
            runSpacing: 40,
            children: snapshot.data.map((e) =>
                VehicleTypeBox(
                  vehicleType: e,
                  isSelected: selectedVehicleType != null && e.id == selectedVehicleType.id,
                  onClick: (e) {
                    setState(() {
                      selectedVehicleType = e;
                    });

                    this.widget.onSelectionChanged(e);
                  },
                )
            ).toList(),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class VehicleTypeBox extends StatelessWidget {
  final VehicleType vehicleType;
  final bool isSelected;
  final Function(VehicleType) onClick;

  const VehicleTypeBox({Key key, @required this.vehicleType, @required this.isSelected, @required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(vehicleType),
      child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Color.fromRGBO(160, 242, 132, 1) : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.black : Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: isSelected ? Colors.black.withOpacity(0.5) : Colors.transparent,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0.0, 0.75)
              ),
            ],
          ),
          width: 150,
          height: 120,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.network(
                  "https://localhost:44312" + vehicleType.imageUrl,
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                  color: isSelected ? Colors.black : Color.fromRGBO(112, 112, 112, 1)
              ),
              SizedBox(height: 10),
              Text(
                vehicleType.name,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isSelected ? Colors.black : Color.fromRGBO(112, 112, 112, 1)
                ),
              ),
            ],
          ),
      ),
    );
  }
}