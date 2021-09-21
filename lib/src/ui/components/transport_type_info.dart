import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:fletes_31_app/src/ui/components/transport_type_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class TransportTypeInformation extends StatelessWidget {
  const TransportTypeInformation({Key key, this.vehicleType}) : super(key: key);
  final VehicleType vehicleType;

  @override
  Widget build(BuildContext context) {

    return Container(
      clipBehavior: Clip.hardEdge,
      foregroundDecoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black,
              width: 2
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(160, 242, 132, 1),
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
                    color: Colors.black
                ),
                SizedBox(height: 10),
                Text(
                  vehicleType.name.toUpperCase(),
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color:Colors.black
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    vehicleType.name.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
              const Divider(
                  height: 10,
                  thickness: 2,
                  color: Color.fromARGB(255,23,10,61)
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                      "Dimensiones: "
                          "${vehicleType.widthInMeters}m (Ancho) x "
                          "${vehicleType.heightInMeters}m (Alto) x "
                          "${vehicleType.widthInMeters}m (Profundidad)"
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Capacidad: ${vehicleType.maxWeightInKilograms}kg")
              ),
            ],
          ))
        ],
      ),
    );
  }
}
