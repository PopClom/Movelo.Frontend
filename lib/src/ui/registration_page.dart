import 'dart:math';
import 'package:flutter/material.dart';
import '../blocs/registration_bloc.dart';


class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  RegistrationBloc bloc = RegistrationBloc();

  Widget _entryField(String title, stream, onChanged, {bool isPassword = false, keyboardType = TextInputType.text}) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snap) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              labelText: title,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(width: 1.5, color: Colors.orange),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(width: 1.5, color: Colors.red),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              errorText: snap.error,
            ),
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
          ),
        );
      },
    );
  }

  Widget _dropdownField(String title, List<String> options, stream, onChanged) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snap) {
        return Container(
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            hint: Text(title),
            value: snap.data,
            decoration: InputDecoration(
              fillColor: Color(0xfff3f3f4),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(width: 1.5, color: Colors.orange),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
            ),
            onChanged: onChanged,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _inputFieldsWidget() {
    return Column(
      children: <Widget>[
        _entryField("Nombre", bloc.name, bloc.changeName),
        _entryField("Apellido", bloc.lastname, bloc.changeLastname),
        _entryField("Celular", bloc.phone, bloc.changePhone, keyboardType: TextInputType.phone),
        _entryField("Domicilio (opcional)", bloc.address, bloc.changeAddress),
        _dropdownField("Género (opcional)", ['Femenino', 'Masculino', 'No binario'], bloc.gender, bloc.changeGender),
      ],
    );
  }

  Widget _submitButton() {
    return StreamBuilder<bool>(
      stream: bloc.submitValid,
      builder: (context, snap) {
        return TextButton(
            onPressed: (!snap.hasData) ? null : bloc.submit,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  color: snap.hasData ? Colors.orange : Colors.grey.shade300),
              child: Text(
                'Continuar',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
        );
      },
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('Moto'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final deviceSize = MediaQuery.of(context).size;
    final width = min(deviceSize.width * 0.75, 360.0);

    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                          'images/logo-fletes31-inverted.png',
                          width: MediaQuery.of(context).size.width * 0.75
                      ),
                      _inputFieldsWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
