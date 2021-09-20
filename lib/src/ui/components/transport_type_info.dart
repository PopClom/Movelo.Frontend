import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:fletes_31_app/src/ui/components/transport_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TransportTypeInformation extends StatelessWidget {
  const TransportTypeInformation({Key key, this.vehicleType}) : super(key: key);
  final VehicleType vehicleType;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 10
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Row(
        children: [
          VehicleTypeBox(vehicleType: vehicleType, isSelected: true),
          Expanded(child: Column(
            children: [
              Text(vehicleType.name),
              const Divider(
                  height: 60,
                  thickness: 2,
                  color: Color.fromARGB(255,23,10,61)
              ),
              Text(
                  "Dimensiones: "
                      "${vehicleType.widthInMeters}m (Ancho) x "
                      "${vehicleType.heightInMeters}m (Alto) x "
                      "${vehicleType.widthInMeters}m (Profundidad)"
              ),
              Text("Capacidad: ${vehicleType.maxWeightInKilograms}kg"),
            ],
          ))
        ],
      ),
    );
  }
}
