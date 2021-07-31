import 'package:dio/dio.dart';
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

  Future<List<VehicleType>> fetchVehicleTypes() async {
    Response response = await Dio().get("https://localhost:44312/api/VehicleTypes");
    // if there is a key before array, use this : return (response.data['data'] as List).map((child)=> Children.fromJson(child)).toList();
    return (response.data as List)
        .map((x) => VehicleType.fromJson(x))
        .toList();
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "¿Qué vehículo necesitás?",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold ,
                    fontSize: 20
                ),
              ),
              SizedBox(height: 15),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                direction: Axis.horizontal,
                runSpacing: 10,
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
              ),
              drawSelectedVehicleTypeDetails()
            ],
          );
        }

        return CircularProgressIndicator();
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
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.grey[400] : Colors.grey[300],
              border: Border.all(
                  color: Colors.grey[400], // Set border color
                  width: 1.0
              ),
            ),
            padding: EdgeInsets.all(10),
            child: SvgPicture.network(
                "https://localhost:44312" + vehicleType.imageUrl,
                height: 40,
                width: 40,
                color: isSelected ? Colors.orange: Colors.grey[600]
            ),
          ),
          Text(
            vehicleType.name,
            style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : null,
                fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}